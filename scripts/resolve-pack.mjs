#!/usr/bin/env node

import fs from "node:fs/promises"
import path from "node:path"
import process from "node:process"
import { fileURLToPath } from "node:url"
import { parse } from "yaml"

class PackResolutionError extends Error {
  constructor(message, details = []) {
    super(message)
    this.details = details
  }
}

function parseArgs(argv) {
  const options = { field: "human" }
  for (let index = 0; index < argv.length; index += 1) {
    const option = argv[index]
    if (["--module-dir", "--project-root", "--pack", "--field"].includes(option)) {
      const value = argv[index + 1]
      if (!value) throw new PackResolutionError(`${option} requires a value`)
      const key = option.slice(2).replace(/-([a-z])/g, (_, letter) => letter.toUpperCase())
      options[key] = value
      index += 1
      continue
    }
    if (option === "-h" || option === "--help") {
      options.help = true
      continue
    }
    throw new PackResolutionError(`Unknown option: ${option}`)
  }
  return options
}

function markerLabel(marker) {
  if (marker.type === "path_exists") return `path_exists ${marker.path}`
  return `file_contains ${marker.path} contains ${JSON.stringify(marker.value)}`
}

function safeProjectPath(projectRoot, markerPath, definitionPath) {
  if (typeof markerPath !== "string" || markerPath.length === 0 || path.isAbsolute(markerPath)) {
    throw new PackResolutionError(`Invalid detection path in ${definitionPath}: ${String(markerPath)}`)
  }
  const resolved = path.resolve(projectRoot, markerPath)
  const relative = path.relative(projectRoot, resolved)
  if (relative === ".." || relative.startsWith(`..${path.sep}`)) {
    throw new PackResolutionError(`Detection path escapes project root in ${definitionPath}: ${markerPath}`)
  }
  return resolved
}

async function pathExists(candidate) {
  try {
    await fs.access(candidate)
    return true
  } catch (error) {
    if (error.code === "ENOENT" || error.code === "ENOTDIR") return false
    throw error
  }
}

async function evaluatePack(pack, projectRoot) {
  const evidence = []
  const missing = []
  for (const marker of pack.detection.required) {
    const candidate = safeProjectPath(projectRoot, marker.path, pack.definitionPath)
    let matched = false
    if (marker.type === "path_exists") {
      matched = await pathExists(candidate)
    } else {
      try {
        const content = await fs.readFile(candidate, "utf8")
        matched = content.includes(marker.value)
      } catch (error) {
        if (error.code !== "ENOENT" && error.code !== "EISDIR" && error.code !== "ENOTDIR") throw error
      }
    }
    const label = markerLabel(marker)
    if (matched) evidence.push(label)
    else missing.push(label)
  }
  return { matched: missing.length === 0, evidence, missing }
}

function validateDefinition(pack, directoryName, definitionPath) {
  if (!pack || typeof pack !== "object" || Array.isArray(pack)) {
    throw new PackResolutionError(`Pack definition must be a mapping: ${definitionPath}`)
  }
  if (pack.name !== directoryName) {
    throw new PackResolutionError(`Pack name ${JSON.stringify(pack.name)} does not match directory ${directoryName}: ${definitionPath}`)
  }
  if (pack.name === "generic") {
    if (pack.detection !== undefined) {
      throw new PackResolutionError(`Generic pack must be confirmation-only and omit detection: ${definitionPath}`)
    }
    return
  }
  const markers = pack.detection?.required
  if (!Array.isArray(markers) || markers.length === 0) {
    throw new PackResolutionError(`Non-generic pack requires detection.required markers: ${definitionPath}`)
  }
  for (const [index, marker] of markers.entries()) {
    if (!marker || typeof marker !== "object" || Array.isArray(marker)) {
      throw new PackResolutionError(`Invalid detection.required[${index}] in ${definitionPath}`)
    }
    if (!['path_exists', 'file_contains'].includes(marker.type)) {
      throw new PackResolutionError(`Unsupported detection marker ${JSON.stringify(marker.type)} in ${definitionPath}`)
    }
    safeProjectPath("/validation-root", marker.path, definitionPath)
    if (marker.type === "file_contains" && (typeof marker.value !== "string" || marker.value.length === 0)) {
      throw new PackResolutionError(`file_contains marker requires a literal value in ${definitionPath}`)
    }
  }
}

async function loadPackDefinitions(moduleDir) {
  const packsDir = path.join(moduleDir, "packs")
  let entries
  try {
    entries = await fs.readdir(packsDir, { withFileTypes: true })
  } catch (error) {
    throw new PackResolutionError(`Cannot read pack directory ${packsDir}: ${error.message}`)
  }

  const packs = new Map()
  for (const entry of entries.filter((candidate) => candidate.isDirectory()).sort((a, b) => a.name.localeCompare(b.name))) {
    const definitionPath = path.join(packsDir, entry.name, "pack.yaml")
    if (!(await pathExists(definitionPath))) continue
    let pack
    try {
      pack = parse(await fs.readFile(definitionPath, "utf8"))
    } catch (error) {
      throw new PackResolutionError(`Cannot parse ${definitionPath}: ${error.message}`)
    }
    validateDefinition(pack, entry.name, definitionPath)
    packs.set(pack.name, { ...pack, definitionPath })
  }
  if (packs.size === 0) throw new PackResolutionError(`No pack definitions found under ${packsDir}`)
  return packs
}

async function loadProjectConfiguration(projectRoot, packs) {
  const configPath = path.join(projectRoot, ".opencode-project.yaml")
  if (!(await pathExists(configPath))) return { configPath, config: null }
  let config
  try {
    config = parse(await fs.readFile(configPath, "utf8"))
  } catch (error) {
    throw new PackResolutionError(`Cannot parse ${configPath}: ${error.message}`)
  }
  if (!config || typeof config !== "object" || Array.isArray(config)) {
    throw new PackResolutionError(`Project pack configuration must be a mapping: ${configPath}`)
  }
  if (config.default_pack !== undefined && typeof config.default_pack !== "string") {
    throw new PackResolutionError(`default_pack must be a pack name in ${configPath}`)
  }
  if (config.allowed_packs !== undefined && (!Array.isArray(config.allowed_packs) || config.allowed_packs.some((name) => typeof name !== "string"))) {
    throw new PackResolutionError(`allowed_packs must be a list of pack names in ${configPath}`)
  }
  for (const name of config.allowed_packs ?? []) {
    if (!packs.has(name)) throw new PackResolutionError(`Unknown allowed pack ${name} in ${configPath}`)
  }
  return { configPath, config }
}

export async function resolvePack({ moduleDir, projectRoot, explicitPack }) {
  const resolvedModuleDir = path.resolve(moduleDir)
  const resolvedProjectRoot = path.resolve(projectRoot)
  const packs = await loadPackDefinitions(resolvedModuleDir)

  if (explicitPack) {
    if (!packs.has(explicitPack)) {
      throw new PackResolutionError(`Unknown pack: ${explicitPack}`, [
        `Available packs: ${[...packs.keys()].join(", ")}`,
      ])
    }
    return { pack: explicitPack, source: "explicit --pack", evidence: [] }
  }

  const { configPath, config } = await loadProjectConfiguration(resolvedProjectRoot, packs)
  const allowedPacks = config?.allowed_packs ? new Set(config.allowed_packs) : null
  if (config?.default_pack) {
    const confirmed = config.default_pack
    const pack = packs.get(confirmed)
    if (!pack) throw new PackResolutionError(`Unknown confirmed pack ${confirmed} in ${configPath}`)
    if (allowedPacks && !allowedPacks.has(confirmed)) {
      throw new PackResolutionError(`Confirmed pack ${confirmed} is not listed in allowed_packs: ${configPath}`)
    }
    if (confirmed === "generic") {
      return { pack: confirmed, source: "confirmed project configuration", evidence: [] }
    }
    const result = await evaluatePack(pack, resolvedProjectRoot)
    if (!result.matched) {
      throw new PackResolutionError(`Confirmed pack ${confirmed} is stale or incompatible with current project evidence.`, [
        ...result.missing.map((marker) => `Missing: ${marker}`),
        `Correct ${configPath} or confirm a pack explicitly with --pack.`,
      ])
    }
    return { pack: confirmed, source: "confirmed project configuration", evidence: result.evidence }
  }

  const evaluations = []
  for (const pack of packs.values()) {
    if (pack.name === "generic" || (allowedPacks && !allowedPacks.has(pack.name))) continue
    evaluations.push({ pack, result: await evaluatePack(pack, resolvedProjectRoot) })
  }
  const matches = evaluations.filter(({ result }) => result.matched)
  if (matches.length === 1) {
    return { pack: matches[0].pack.name, source: "project evidence", evidence: matches[0].result.evidence }
  }
  if (matches.length > 1) {
    throw new PackResolutionError("Multiple stack packs match the current project. Phase work is blocked; confirm one with --pack.",
      matches.flatMap(({ pack, result }) => [
        `Candidate ${pack.name}:`,
        ...result.evidence.map((marker) => `  Matched: ${marker}`),
      ]))
  }
  throw new PackResolutionError("No stack pack matches the current project. Phase work is blocked.", [
    ...evaluations.flatMap(({ pack, result }) => [
      `Inspected ${pack.name}:`,
      ...result.missing.map((marker) => `  Missing: ${marker}`),
    ]),
    "Ask the operator to explicitly confirm generic with --pack generic or request a new pack definition.",
  ])
}

function printSelection(result, field) {
  const report = [
    `Pack selected: ${result.pack} (${result.source})`,
    ...result.evidence.map((marker) => `Evidence: ${marker}`),
  ].join("\n")
  if (field === "pack") {
    process.stdout.write(`${result.pack}\n`)
    process.stderr.write(`${report}\n`)
    return
  }
  if (field === "json") {
    process.stdout.write(`${JSON.stringify(result)}\n`)
    return
  }
  if (field !== "human") throw new PackResolutionError(`Unknown --field value: ${field}`)
  process.stdout.write(`${report}\n`)
}

async function main() {
  try {
    const options = parseArgs(process.argv.slice(2))
    if (options.help) {
      process.stdout.write("Usage: resolve-pack.mjs --module-dir <path> --project-root <path> [--pack <name>] [--field human|json|pack]\n")
      return
    }
    if (!options.moduleDir) throw new PackResolutionError("--module-dir is required")
    if (!options.projectRoot) throw new PackResolutionError("--project-root is required")
    printSelection(await resolvePack({
      moduleDir: options.moduleDir,
      projectRoot: options.projectRoot,
      explicitPack: options.pack,
    }), options.field)
  } catch (error) {
    const resolutionError = error instanceof PackResolutionError ? error : new PackResolutionError(error.message)
    process.stderr.write(`Error: ${resolutionError.message}\n`)
    for (const detail of resolutionError.details) process.stderr.write(`${detail}\n`)
    process.exitCode = 2
  }
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  await main()
}
