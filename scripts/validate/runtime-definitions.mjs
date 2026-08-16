#!/usr/bin/env node

import { execFileSync } from "node:child_process"
import {
  existsSync,
  readFileSync,
  readdirSync,
  statSync,
} from "node:fs"
import { dirname, join, relative, resolve, sep } from "node:path"
import { fileURLToPath } from "node:url"
import { parse } from "yaml"

const SCRIPT_DIR = dirname(fileURLToPath(import.meta.url))
const REPOSITORY_ROOT = resolve(SCRIPT_DIR, "../..")
const FIXTURE_ROOT = join(SCRIPT_DIR, "fixtures/runtime-definitions")
const VALID_AGENT_MODES = new Set(["primary", "subagent", "all"])
const VALID_PHASES = new Set([
  "planning",
  "spec-hardening",
  "implementation",
  "verification",
  "archive",
])
const PHASE_SKILLS = new Map([
  ["planning", "openspec-planning"],
  ["spec-hardening", "openspec-spec-hardening"],
  ["implementation", "openspec-implementation"],
  ["verification", "openspec-verification"],
  ["archive", "openspec-archive"],
])
const OBSOLETE_PHASE_AGENTS = new Set(["planner", "spec-hardener", "implementer", "verifier", "archiver"])
const MODEL_POLICY = new Map([
  ["orchestrator", { model: "openai/gpt-5.6-sol", steps: 40, leaf: false }],
  ["subagent/code-documentation-subagent", { model: "openai/gpt-5.6-luna", steps: 10, leaf: true }],
  ["subagent/design-doc-subagent", { model: "openai/gpt-5.6-luna", steps: 12, leaf: true }],
  ["subagent/refined-task-executor-subagent", { model: "openai/gpt-5.6-luna", variant: "high", steps: 50, leaf: true }],
  ["subagent/pulumi-infrastructure-subagent", { model: "openai/gpt-5.6-sol", steps: 20, leaf: true }],
  ["subagent/tdd-tests-subagent", { model: "openai/gpt-5.6-sol", steps: 20, leaf: true }],
])

function toPosix(path) {
  return path.split(sep).join("/")
}

function displayPath(root, path) {
  return toPosix(relative(root, path)) || "."
}

function addIssue(result, severity, code, path, message) {
  result[severity === "error" ? "errors" : "warnings"].push({
    severity,
    code,
    path,
    message,
  })
}

function addError(result, code, path, message) {
  addIssue(result, "error", code, path, message)
}

function addWarning(result, code, path, message) {
  addIssue(result, "warning", code, path, message)
}

function readYaml(root, path, result, code) {
  try {
    const value = parse(readFileSync(path, "utf8"))
    if (value === null || typeof value !== "object" || Array.isArray(value)) {
      addError(result, code, displayPath(root, path), "expected a YAML mapping")
      return null
    }
    return value
  } catch (error) {
    addError(result, code, displayPath(root, path), `invalid YAML: ${error.message}`)
    return null
  }
}

function readFrontmatter(root, path, result, kind) {
  const text = readFileSync(path, "utf8")
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/)
  if (!match) {
    addError(
      result,
      `${kind}-frontmatter-missing`,
      displayPath(root, path),
      "add a leading YAML frontmatter block delimited by ---",
    )
    return null
  }

  try {
    const value = parse(match[1])
    if (value === null || typeof value !== "object" || Array.isArray(value)) {
      addError(
        result,
        `${kind}-frontmatter-invalid`,
        displayPath(root, path),
        "frontmatter must be a YAML mapping",
      )
      return null
    }
    return value
  } catch (error) {
    addError(
      result,
      `${kind}-frontmatter-invalid`,
      displayPath(root, path),
      `invalid YAML frontmatter: ${error.message}`,
    )
    return null
  }
}

function walkFiles(directory, predicate) {
  if (!existsSync(directory)) return []

  const files = []
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name)
    if (entry.isDirectory()) files.push(...walkFiles(path, predicate))
    else if (entry.isFile() && predicate(path)) files.push(path)
  }
  return files.sort()
}

function isNonEmptyString(value) {
  return typeof value === "string" && value.trim().length > 0
}

function runtimeNameFromAgentPath(root, path) {
  return toPosix(relative(join(root, "agents"), path)).replace(/\.md$/, "")
}

function resolvesToFile(root, configuredPath) {
  if (!isNonEmptyString(configuredPath)) return false
  const absolute = resolve(root, configuredPath)
  const relativePath = relative(root, absolute)
  return (
    relativePath !== ".." &&
    !relativePath.startsWith(`..${sep}`) &&
    existsSync(absolute) &&
    statSync(absolute).isFile()
  )
}

function validateSkills(root, result) {
  const skillRoot = join(root, "skill")
  const skills = new Map()
  if (!existsSync(skillRoot)) return skills

  for (const entry of readdirSync(skillRoot, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue
    const directory = join(skillRoot, entry.name)
    const skillPath = join(directory, "SKILL.md")
    const manifestPath = join(directory, "manifest.yaml")

    if (!existsSync(skillPath)) {
      if (existsSync(manifestPath)) {
        addError(
          result,
          "skill-definition-missing",
          displayPath(root, directory),
          "manifest has no sibling SKILL.md",
        )
      }
      continue
    }

    const frontmatter = readFrontmatter(root, skillPath, result, "skill")
    if (frontmatter) {
      if (!isNonEmptyString(frontmatter.name)) {
        addError(result, "skill-name-missing", displayPath(root, skillPath), "frontmatter name is required")
      } else if (frontmatter.name !== entry.name) {
        addError(
          result,
          "skill-name-mismatch",
          displayPath(root, skillPath),
          `frontmatter name '${frontmatter.name}' must match directory '${entry.name}'`,
        )
      }
      if (!isNonEmptyString(frontmatter.description)) {
        addError(
          result,
          "skill-description-missing",
          displayPath(root, skillPath),
          "frontmatter description must be non-empty",
        )
      }
    }

    if (!existsSync(manifestPath)) {
      addError(
        result,
        "skill-manifest-missing",
        displayPath(root, directory),
        "repository-owned skill requires manifest.yaml",
      )
    } else {
      const manifest = readYaml(root, manifestPath, result, "skill-manifest-invalid")
      if (manifest && manifest.name !== entry.name) {
        addError(
          result,
          "skill-manifest-name-mismatch",
          displayPath(root, manifestPath),
          `manifest name '${manifest.name ?? "<missing>"}' must match directory '${entry.name}'`,
        )
      }
    }

    skills.set(entry.name, { path: skillPath, frontmatter })
  }
  return skills
}

function validateAgentPolicy(root, path, runtimeName, frontmatter, result) {
  const policy = MODEL_POLICY.get(runtimeName)
  if (!policy) return
  const shownPath = displayPath(root, path)

  if (frontmatter.model !== policy.model) {
    addError(
      result,
      "agent-model-policy-mismatch",
      shownPath,
      `${runtimeName} model must be '${policy.model}', found '${frontmatter.model ?? "<missing>"}'`,
    )
  }
  if (policy.variant && frontmatter.variant !== policy.variant) {
    addError(
      result,
      "agent-variant-policy-mismatch",
      shownPath,
      `${runtimeName} variant must be '${policy.variant}', found '${frontmatter.variant ?? "<missing>"}'`,
    )
  }
  if (frontmatter.steps !== policy.steps) {
    addError(
      result,
      "agent-steps-policy-mismatch",
      shownPath,
      `${runtimeName} steps must be ${policy.steps}, found '${frontmatter.steps ?? "<missing>"}'`,
    )
  }
  if (policy.leaf && frontmatter.permission?.task !== "deny") {
    addError(
      result,
      "agent-leaf-delegation-enabled",
      shownPath,
      `${runtimeName} must declare permission.task: deny`,
    )
  }
}

function validateAgents(root, result) {
  const agents = new Map()
  for (const path of walkFiles(join(root, "agents"), (candidate) => candidate.endsWith(".md"))) {
    const runtimeName = runtimeNameFromAgentPath(root, path)
    const frontmatter = readFrontmatter(root, path, result, "agent")
    agents.set(runtimeName, { path, frontmatter })
    if (!frontmatter) continue

    if (!isNonEmptyString(frontmatter.description)) {
      addError(
        result,
        "agent-description-missing",
        displayPath(root, path),
        "frontmatter description must be non-empty",
      )
    }
    if (!VALID_AGENT_MODES.has(frontmatter.mode)) {
      addError(
        result,
        "agent-mode-invalid",
        displayPath(root, path),
        `mode must be one of ${[...VALID_AGENT_MODES].join(", ")}`,
      )
    }
    if (Object.hasOwn(frontmatter, "tools")) {
      addWarning(
        result,
        "agent-deprecated-tools",
        displayPath(root, path),
        "deprecated 'tools' is accepted during migration; migrate it to permission in a follow-up",
      )
    }
    validateAgentPolicy(root, path, runtimeName, frontmatter, result)
  }

  if (agents.has("subagent/feature-iteration-subagent")) {
    addError(
      result,
      "agent-obsolete-feature-iteration",
      displayPath(root, agents.get("subagent/feature-iteration-subagent").path),
      "feature iteration belongs in the openspec-implementation skill and must not be a runtime agent",
    )
  }
  for (const runtimeName of OBSOLETE_PHASE_AGENTS) {
    if (!agents.has(runtimeName)) continue
    addError(
      result,
      "agent-obsolete-phase-owner",
      displayPath(root, agents.get(runtimeName).path),
      `${runtimeName} must be migrated to an OpenSpec phase skill; orchestrator is the only phase-owning primary agent`,
    )
  }
  return agents
}

function validateAgentCatalog(root, result, agents) {
  const path = join(root, "core/agent-catalog.yaml")
  if (!existsSync(path)) return
  const catalog = readYaml(root, path, result, "agent-catalog-invalid")
  if (!catalog) return
  if (!Array.isArray(catalog.agents)) {
    addError(result, "agent-catalog-invalid", displayPath(root, path), "agents must be an array")
    return
  }

  const ids = new Set()
  const runtimeNames = new Set()
  const catalogedPaths = new Set()
  const requiredFields = [
    "runtime_name",
    "path",
    "phase_scope",
    "specialization",
    "model",
    "steps",
    "delegation_scope",
    "expected_inputs",
    "expected_outputs",
  ]
  const arrayFields = new Set(["expected_inputs", "expected_outputs"])
  const numericFields = new Set(["steps"])

  for (const [index, entry] of catalog.agents.entries()) {
    const location = `${displayPath(root, path)}#agents[${index}]`
    if (!isNonEmptyString(entry?.id)) {
      addError(result, "agent-catalog-id-missing", location, "id is required")
    } else if (ids.has(entry.id)) {
      addError(result, "agent-catalog-duplicate-id", location, `duplicate agent id '${entry.id}'`)
    } else {
      ids.add(entry.id)
    }

    for (const field of requiredFields) {
      const value = entry?.[field]
      const valid = arrayFields.has(field)
        ? Array.isArray(value) && value.length > 0 && value.every(isNonEmptyString)
        : numericFields.has(field)
          ? Number.isInteger(value) && value > 0
          : isNonEmptyString(value)
      if (!valid) {
        addError(
          result,
          "agent-catalog-field-missing",
          location,
          `agent '${entry?.id ?? index}' requires a valid non-empty '${field}'`,
        )
      }
    }

    if (isNonEmptyString(entry?.runtime_name)) {
      if (runtimeNames.has(entry.runtime_name)) {
        addError(
          result,
          "agent-catalog-duplicate-runtime-name",
          location,
          `duplicate runtime_name '${entry.runtime_name}'`,
        )
      }
      runtimeNames.add(entry.runtime_name)
    }

    if (!resolvesToFile(root, entry?.path)) {
      addError(
        result,
        "agent-catalog-path-unresolved",
        location,
        `path '${entry?.path ?? "<missing>"}' does not resolve to a repository file`,
      )
      continue
    }

    const normalizedPath = toPosix(entry.path)
    catalogedPaths.add(normalizedPath)
    const expectedRuntimeName = normalizedPath.replace(/^agents\//, "").replace(/\.md$/, "")
    if (entry.runtime_name !== expectedRuntimeName) {
      addError(
        result,
        "agent-catalog-runtime-name-mismatch",
        location,
        `runtime_name must be '${expectedRuntimeName}' for '${entry.path}'`,
      )
    }

    const agent = agents.get(expectedRuntimeName)
    if (agent?.frontmatter) {
      if (entry.model !== agent.frontmatter.model) {
        addError(
          result,
          "agent-catalog-model-mismatch",
          location,
          `catalog model '${entry.model ?? "<missing>"}' differs from agent model '${agent.frontmatter.model ?? "<missing>"}'`,
        )
      }
      if (entry.steps !== agent.frontmatter.steps) {
        addError(
          result,
          "agent-catalog-steps-mismatch",
          location,
          `catalog steps '${entry.steps ?? "<missing>"}' differs from agent steps '${agent.frontmatter.steps ?? "<missing>"}'`,
        )
      }
      if (entry.variant !== agent.frontmatter.variant) {
        addError(
          result,
          "agent-catalog-variant-mismatch",
          location,
          `catalog variant '${entry.variant ?? "<missing>"}' differs from agent variant '${agent.frontmatter.variant ?? "<missing>"}'`,
        )
      }
    }
  }

  if ([...ids].filter((id) => id === "orchestrator").length !== 1) {
    addError(
      result,
      "agent-catalog-orchestrator-count",
      displayPath(root, path),
      "catalog must contain exactly one agent with id 'orchestrator'",
    )
  }

  for (const agent of agents.values()) {
    const relativePath = displayPath(root, agent.path)
    if (!catalogedPaths.has(relativePath)) {
      addError(
        result,
        "agent-uncataloged",
        relativePath,
        "runtime agent is missing from core/agent-catalog.yaml",
      )
    }
  }
}

function validatePhaseCatalog(root, result, skills) {
  const path = join(root, "core/phase-contract-catalog.yaml")
  if (!existsSync(path)) return
  const catalog = readYaml(root, path, result, "phase-catalog-invalid")
  if (!catalog) return
  if (!Array.isArray(catalog.phases)) {
    addError(result, "phase-catalog-invalid", displayPath(root, path), "phases must be an array")
    return
  }

  const phases = new Set()
  for (const [index, entry] of catalog.phases.entries()) {
    const location = `${displayPath(root, path)}#phases[${index}]`
    const phase = entry?.id ?? entry?.phase
    if (!VALID_PHASES.has(phase)) {
      addError(
        result,
        "phase-catalog-invalid-phase",
        location,
        `phase '${phase ?? "<missing>"}' must be one of ${[...VALID_PHASES].join(", ")}`,
      )
    } else if (phases.has(phase)) {
      addError(result, "phase-catalog-duplicate-phase", location, `duplicate phase '${phase}'`)
    } else {
      phases.add(phase)
    }

    const expectedSkill = PHASE_SKILLS.get(phase)
    if (expectedSkill && entry?.skill !== expectedSkill) {
      addError(
        result,
        "phase-catalog-skill-mismatch",
        location,
        `phase '${phase}' must map to skill '${expectedSkill}', found '${entry?.skill ?? "<missing>"}'`,
      )
    }

    const skill = skills.get(entry?.skill)
    const pathMatches = skill && displayPath(root, skill.path) === toPosix(entry?.path ?? "")
    if (!skill || !pathMatches || !resolvesToFile(root, entry?.path)) {
      addError(
        result,
        "phase-catalog-skill-unresolved",
        location,
        `skill '${entry?.skill ?? "<missing>"}' must resolve through path '${entry?.path ?? "<missing>"}'`,
      )
    }
    if (!Array.isArray(entry?.entry_criteria) || entry.entry_criteria.length === 0) {
      addError(result, "phase-catalog-entry-criteria-missing", location, "entry_criteria must be a non-empty array")
    }
    if (!Array.isArray(entry?.completion_criteria) || entry.completion_criteria.length === 0) {
      addError(
        result,
        "phase-catalog-completion-criteria-missing",
        location,
        "completion_criteria must be a non-empty array",
      )
    }
  }

  const missingPhases = [...VALID_PHASES].filter((phase) => !phases.has(phase))
  if (missingPhases.length > 0) {
    addError(
      result,
      "phase-catalog-incomplete",
      displayPath(root, path),
      `catalog is missing phases: ${missingPhases.join(", ")}`,
    )
  }
}

function validatePackReferences(root, result, value, location, key = "") {
  if (Array.isArray(value)) {
    if (key.endsWith("_paths")) {
      for (const referencedPath of value) {
        if (!resolvesToFile(root, referencedPath)) {
          addError(
            result,
            "pack-path-unresolved",
            location,
            `referenced path '${referencedPath}' does not resolve to a repository file`,
          )
        }
      }
    } else {
      for (const item of value) validatePackReferences(root, result, item, location)
    }
    return
  }
  if (value === null || typeof value !== "object") return
  for (const [childKey, childValue] of Object.entries(value)) {
    if (childKey.endsWith("_path") && !resolvesToFile(root, childValue)) {
      addError(
        result,
        "pack-path-unresolved",
        location,
        `referenced path '${childValue}' does not resolve to a repository file`,
      )
    } else {
      validatePackReferences(root, result, childValue, location, childKey)
    }
  }
}

function validatePacks(root, result, skills) {
  const packRoot = join(root, "packs")
  if (!existsSync(packRoot)) return
  for (const entry of readdirSync(packRoot, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue
    const path = join(packRoot, entry.name, "pack.yaml")
    if (!existsSync(path)) continue
    const pack = readYaml(root, path, result, "pack-invalid")
    if (!pack) continue
    const location = displayPath(root, path)

    if (pack.name !== entry.name) {
      addError(
        result,
        "pack-name-mismatch",
        location,
        `pack name '${pack.name ?? "<missing>"}' must match directory '${entry.name}'`,
      )
    }

    const required = pack.detection?.required
    if (entry.name === "generic") {
      if (required !== undefined) {
        addError(
          result,
          "pack-generic-auto-detection",
          location,
          "generic is confirmation-only and must not define detection.required",
        )
      }
    } else if (!Array.isArray(required) || required.length === 0) {
      addError(
        result,
        "pack-detection-required-missing",
        location,
        "non-generic pack requires a non-empty detection.required array",
      )
    } else {
      for (const [index, marker] of required.entries()) {
        const markerLocation = `${location}#detection.required[${index}]`
        const markerIsMapping = marker !== null && typeof marker === "object" && !Array.isArray(marker)
        const pathIsSafe =
          markerIsMapping &&
          isNonEmptyString(marker.path) &&
          !marker.path.startsWith("/") &&
          !marker.path.split(/[\\/]/).includes("..")
        const pathExistsMarker =
          markerIsMapping && marker.type === "path_exists" && pathIsSafe && !Object.hasOwn(marker, "value")
        const fileContainsMarker =
          markerIsMapping && marker.type === "file_contains" && pathIsSafe && isNonEmptyString(marker.value)
        if (!pathExistsMarker && !fileContainsMarker) {
          addError(
            result,
            "pack-detection-marker-invalid",
            markerLocation,
            "marker must be path_exists {type,path} or file_contains {type,path,value} with a safe relative path",
          )
        }
      }
    }

    for (const [overlay, selection] of Object.entries(pack.skill_overlays ?? {})) {
      for (const skillName of [...(selection?.include ?? []), ...(selection?.exclude ?? [])]) {
        if (!skills.has(skillName)) {
          addError(
            result,
            "pack-skill-unresolved",
            location,
            `skill overlay '${overlay}' references unknown skill '${skillName}'`,
          )
        }
      }
    }
    validatePackReferences(root, result, pack, location)
  }
}

function validateGitmodules(root, result) {
  const path = join(root, ".gitmodules")
  if (!existsSync(path)) return
  const lines = readFileSync(path, "utf8").split(/\r?\n/)
  let section = null
  for (const [index, line] of lines.entries()) {
    const sectionMatch = line.match(/^\s*\[submodule\s+"([^"]+)"\]\s*$/)
    if (sectionMatch) {
      section = sectionMatch[1]
      continue
    }
    const pathMatch = line.match(/^\s*path\s*=\s*(.+?)\s*$/)
    if (pathMatch && (pathMatch[1] === ".opencode" || section === ".opencode")) {
      addError(
        result,
        "gitmodules-self-submodule",
        `${displayPath(root, path)}:${index + 1}`,
        "remove the self-referential .opencode submodule; validate distribution with a disposable consumer fixture",
      )
    }
  }
}

function trackedFiles(root, override) {
  if (override) return override
  try {
    return execFileSync("git", ["-C", root, "ls-files", "-z"], { encoding: "utf8" })
      .split("\0")
      .filter(Boolean)
  } catch (error) {
    throw new Error(`cannot inspect tracked files with git ls-files: ${error.message}`)
  }
}

function validateTrackedFiles(root, result, override) {
  for (const path of trackedFiles(root, override)) {
    if (/(^|[:/])Zone\.Identifier$/.test(toPosix(path))) {
      addError(
        result,
        "tracked-zone-identifier",
        toPosix(path),
        "remove the tracked Zone.Identifier sidecar and add an ignore rule",
      )
    }
  }
}

export function validateRuntimeDefinitions(root, options = {}) {
  const absoluteRoot = resolve(root)
  const result = { errors: [], warnings: [] }
  const skills = validateSkills(absoluteRoot, result)
  const agents = validateAgents(absoluteRoot, result)
  validateAgentCatalog(absoluteRoot, result, agents)
  validatePhaseCatalog(absoluteRoot, result, skills)
  validatePacks(absoluteRoot, result, skills)
  validateGitmodules(absoluteRoot, result)
  validateTrackedFiles(absoluteRoot, result, options.trackedFiles)
  result.errors.sort(compareIssues)
  result.warnings.sort(compareIssues)
  return result
}

function compareIssues(left, right) {
  return left.path.localeCompare(right.path) || left.code.localeCompare(right.code) || left.message.localeCompare(right.message)
}

function issueCodes(issues) {
  return issues.map((issue) => issue.code).sort()
}

function arraysEqual(left, right) {
  return left.length === right.length && left.every((value, index) => value === right[index])
}

function runSelfTests() {
  let failed = 0
  let passed = 0
  for (const entry of readdirSync(FIXTURE_ROOT, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
    if (!entry.isDirectory()) continue
    const root = join(FIXTURE_ROOT, entry.name)
    const casePath = join(root, "case.yaml")
    if (!existsSync(casePath)) continue
    const fixtureResult = { errors: [], warnings: [] }
    const definition = readYaml(root, casePath, fixtureResult, "fixture-case-invalid")
    if (!definition) {
      console.error(`FAIL ${entry.name}: invalid case.yaml`)
      failed += 1
      continue
    }

    const result = validateRuntimeDefinitions(root, { trackedFiles: definition.tracked_files ?? [] })
    const expectedErrors = [...(definition.expected_errors ?? [])].sort()
    const expectedWarnings = [...(definition.expected_warnings ?? [])].sort()
    const actualErrors = issueCodes(result.errors)
    const actualWarnings = issueCodes(result.warnings)
    if (arraysEqual(expectedErrors, actualErrors) && arraysEqual(expectedWarnings, actualWarnings)) {
      console.log(`PASS ${entry.name}`)
      passed += 1
      continue
    }

    console.error(`FAIL ${entry.name}`)
    console.error(`  expected errors:   ${JSON.stringify(expectedErrors)}`)
    console.error(`  actual errors:     ${JSON.stringify(actualErrors)}`)
    console.error(`  expected warnings: ${JSON.stringify(expectedWarnings)}`)
    console.error(`  actual warnings:   ${JSON.stringify(actualWarnings)}`)
    for (const issue of [...result.errors, ...result.warnings]) {
      console.error(`  ${issue.severity.toUpperCase()} [${issue.code}] ${issue.path}: ${issue.message}`)
    }
    failed += 1
  }

  console.log(`Runtime definition fixtures: ${passed} passed, ${failed} failed`)
  if (failed > 0) process.exitCode = 1
}

function runRepositoryValidation() {
  let result
  try {
    result = validateRuntimeDefinitions(REPOSITORY_ROOT)
  } catch (error) {
    console.error(`ERROR [validator-runtime-error] ${error.message}`)
    process.exitCode = 1
    return
  }

  for (const issue of result.warnings) {
    console.warn(`WARNING [${issue.code}] ${issue.path}: ${issue.message}`)
  }
  for (const issue of result.errors) {
    console.error(`ERROR [${issue.code}] ${issue.path}: ${issue.message}`)
  }
  console.log(`Runtime definitions: ${result.errors.length} errors, ${result.warnings.length} warnings`)
  if (result.errors.length > 0) process.exitCode = 1
}

if (process.argv.includes("--self-test")) runSelfTests()
else runRepositoryValidation()
