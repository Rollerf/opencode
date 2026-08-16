#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$SCRIPT_DIR"
if [[ "$(basename "$MODULE_DIR")" == ".opencode" ]]; then
  PROJECT_ROOT="$(cd -- "${MODULE_DIR}/.." && pwd)"
else
  MODULE_DIR_PHYSICAL="$(cd -- "$MODULE_DIR" && pwd -P)"
  INVOCATION_DIR="$(pwd -P)"
  if [[ "$INVOCATION_DIR" == "$MODULE_DIR_PHYSICAL" || "$INVOCATION_DIR" == "$MODULE_DIR_PHYSICAL/"* ]]; then
    PROJECT_ROOT="$MODULE_DIR"
  else
    PROJECT_ROOT="$INVOCATION_DIR"
  fi
fi
OPENCODE_DIR="$MODULE_DIR"
AGENTS_DIR="${MODULE_DIR}/agents"
SKILLS_DIR="${MODULE_DIR}/skill"
PACKS_DIR="${MODULE_DIR}/packs"

fail() {
  echo "Error: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

resolve_openspec_cli() {
  local module_cli="${MODULE_DIR}/node_modules/.bin/openspec"
  local project_cli="${PROJECT_ROOT}/node_modules/.bin/openspec"
  local path_cli

  if [[ -x "$module_cli" ]]; then
    printf '%s' "$module_cli"
    return 0
  fi

  path_cli="$(command -v openspec 2>/dev/null || true)"
  if [[ -n "$path_cli" ]]; then
    printf '%s' "$path_cli"
    return 0
  fi

  if [[ -x "$project_cli" ]]; then
    printf '%s' "$project_cli"
    return 0
  fi

  return 1
}

require_openspec_cli() {
  [[ -n "$OPENSPEC_BIN" ]] ||
    fail "OpenSpec CLI unavailable; run npm install --prefix ${MODULE_DIR} to install @fission-ai/openspec@1.1.1"
}

OPENSPEC_BIN="$(resolve_openspec_cli || true)"
if [[ -n "$OPENSPEC_BIN" ]]; then
  export PATH="$(dirname "$OPENSPEC_BIN"):${PATH}"
fi

strip_quotes() {
  local value="$1"
  value="${value%\"}"
  value="${value#\"}"
  printf '%s' "$value"
}

manifest_value() {
  local file="$1"
  local key="$2"
  local line
  line="$(sed -n "s/^${key}:[[:space:]]*//p" "$file" | head -n1)"
  strip_quotes "$line"
}

phase_contract_skill() {
  local phase="$1"
  case "$phase" in
    planning) echo "openspec-planning" ;;
    spec-hardening) echo "openspec-spec-hardening" ;;
    implementation) echo "openspec-implementation" ;;
    verification) echo "openspec-verification" ;;
    archive) echo "openspec-archive" ;;
    *) fail "Unknown phase: ${phase}. Expected planning|spec-hardening|implementation|verification|archive" ;;
  esac
}

text_matches() {
  local text="$1"
  local pattern="$2"
  [[ -n "$text" ]] || return 1
  printf '%s' "$text" | grep -Eiq "$pattern"
}

is_frontend_intent() {
  local text="$1"
  text_matches "$text" 'front-?end|\bui\b|\bux\b|responsive|layout|component|design system|design-system|visual|screen|page|css|style'
}

is_backend_intent() {
  local text="$1"
  text_matches "$text" 'backend|\bapi\b|handler|usecase|use-case|storage|pulumi|infra|infrastructure|lambda|migration|database|schema|endpoint'
}

is_task_refinement_intent() {
  local text="$1"
  text_matches "$text" 'task[ -]?refinement|refin(e|ing)[[:space:]]+(the[[:space:]]+)?tasks|decompose[[:space:]]+(the[[:space:]]+)?tasks|executor[ -]?ready|decision[ -]?free[[:space:]]+tasks|without[[:space:]]+implementation[[:space:]]+decisions|refina(r)?[[:space:]]+(las[[:space:]]+)?tareas|descomponer[[:space:]]+(las[[:space:]]+)?tareas|tareas[[:space:]]+(ejecutables|sin[[:space:]]+decisiones)'
}

append_skill() {
  local skills_csv="$1"
  local skill="$2"
  if [[ -z "$skills_csv" ]]; then
    printf '%s' "$skill"
  elif [[ ",${skills_csv}," == *",${skill},"* ]]; then
    printf '%s' "$skills_csv"
  else
    printf '%s,%s' "$skills_csv" "$skill"
  fi
}

phase_default_skills() {
  local phase="$1"
  local pack="${2:-}"
  local user_prompt="${3:-}"
  local skills_csv="openspec-workflow"
  local frontend_intent="false"
  local backend_intent="false"

  skills_csv="$(append_skill "$skills_csv" "$(phase_contract_skill "$phase")")"

  if [[ "$phase" == "planning" ]] && is_task_refinement_intent "$user_prompt"; then
    skills_csv="$(append_skill "$skills_csv" "openspec-task-refinement")"
  fi

  [[ "$phase" != "archive" ]] || {
    echo "$skills_csv"
    return
  }

  if is_frontend_intent "$user_prompt"; then
    frontend_intent="true"
    skills_csv="$(append_skill "$skills_csv" "web-ui-ux")"
  fi

  if is_backend_intent "$user_prompt"; then
    backend_intent="true"
  fi

  case "$pack" in
    go-aws)
      skills_csv="$(append_skill "$skills_csv" "backend-design")"
      ;;
    angular)
      if [[ "$backend_intent" == "true" ]]; then
        skills_csv="$(append_skill "$skills_csv" "backend-design")"
      fi
      ;;
    astro)
      skills_csv="$(append_skill "$skills_csv" "seo-expert")"
      if [[ "$backend_intent" == "true" ]]; then
        skills_csv="$(append_skill "$skills_csv" "backend-design")"
      fi
      ;;
    java-onprem|generic)
      ;;
    "")
      if [[ "$frontend_intent" != "true" ]]; then
        case "$phase" in
          planning|implementation|verification)
            skills_csv="$(append_skill "$skills_csv" "backend-design")"
            ;;
        esac
      elif [[ "$backend_intent" == "true" ]]; then
        skills_csv="$(append_skill "$skills_csv" "backend-design")"
      fi
      ;;
    *)
      if [[ "$backend_intent" == "true" ]]; then
        skills_csv="$(append_skill "$skills_csv" "backend-design")"
      fi
      ;;
  esac

  echo "$skills_csv"
}

resolve_agent_file() {
  local value="$1"
  if [[ -f "$value" ]]; then
    printf '%s\n' "$value"
    return
  fi
  if [[ -f "${AGENTS_DIR}/${value}" ]]; then
    printf '%s\n' "${AGENTS_DIR}/${value}"
    return
  fi
  if [[ -f "${AGENTS_DIR}/${value}.md" ]]; then
    printf '%s\n' "${AGENTS_DIR}/${value}.md"
    return
  fi
  fail "Agent not found: ${value}"
}

resolve_skill_dir() {
  local raw="$1"
  local skill="${raw#\$}"
  local dir="${SKILLS_DIR}/${skill}"
  [[ -d "$dir" ]] || fail "Skill not found: ${raw}"
  printf '%s\n' "$dir"
}

resolve_change_dir() {
  local change="$1"
  local active="${PROJECT_ROOT}/openspec/changes/${change}"
  local archived="${PROJECT_ROOT}/openspec/changes/archive/${change}"

  if [[ -d "$active" ]]; then
    printf '%s\n' "$active"
    return 0
  fi
  if [[ -d "$archived" ]]; then
    printf '%s\n' "$archived"
    return 0
  fi
  return 1
}

markdown_fence_for_text() {
  local text="$1"
  local rest="$text"
  local max_run=2
  local run
  while [[ "$rest" =~ (\`+) ]]; do
    run="${BASH_REMATCH[1]}"
    (( ${#run} > max_run )) && max_run=${#run}
    rest="${rest#*"$run"}"
  done
  local fence=""
  printf -v fence '%*s' "$((max_run + 1))" ''
  printf '%s' "${fence// /\`}"
}

include_text_as_fenced_md() {
  local label="$1"
  local language="$2"
  local text="$3"
  local fence
  fence="$(markdown_fence_for_text "$text")"
  {
    printf '### %s\n\n' "$label"
    printf '%s%s\n' "$fence" "$language"
    printf '%s\n' "$text"
    printf '%s\n\n' "$fence"
  }
}

include_file_as_fenced_md() {
  local label="$1"
  local file="$2"
  local content
  content="$(<"$file")"
  include_text_as_fenced_md "$label" "md" "$content"
}

resolve_pack_selection() {
  local explicit_pack="${1:-}"
  local resolver="${MODULE_DIR}/scripts/resolve-pack.mjs"
  [[ -f "$resolver" ]] || fail "Missing pack resolver: $resolver"
  require_cmd node
  local -a args=(node "$resolver" --module-dir "$MODULE_DIR" --project-root "$PROJECT_ROOT" --field pack)
  if [[ -n "$explicit_pack" ]]; then
    args+=(--pack "$explicit_pack")
  fi
  "${args[@]}"
}

run_or_print() {
  local dry_run="$1"
  shift
  printf '+ (cd %q &&' "$PROJECT_ROOT"
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf ')\n'
  if [[ "$dry_run" == "false" ]]; then
    (cd "$PROJECT_ROOT" && "$@")
  fi
}

doctor_cmd() {
  [[ -d "$AGENTS_DIR" ]] || fail "Missing agents directory: $AGENTS_DIR"
  [[ -d "$SKILLS_DIR" ]] || fail "Missing skill directory: $SKILLS_DIR"
  [[ -d "$PACKS_DIR" ]] || fail "Missing packs directory: $PACKS_DIR"

  require_openspec_cli
  require_cmd node
  node "${MODULE_DIR}/scripts/resolve-pack.mjs" --help >/dev/null || fail "Pack resolver dependencies are unavailable; run npm install --prefix ${MODULE_DIR}"
  echo "ok: module directory ($MODULE_DIR)"
  echo "ok: project root ($PROJECT_ROOT)"
  echo "ok: openspec command found: $OPENSPEC_BIN ($(openspec --version 2>/dev/null || echo unknown))"

  if (cd "$PROJECT_ROOT" && openspec status --json >/dev/null 2>&1); then
    echo "ok: openspec status available"
  else
    echo "warn: openspec has no active changes yet (this is fine)"
  fi
}

list_agents_cmd() {
  find "$AGENTS_DIR" -type f -name '*.md' | sort | sed "s#^${MODULE_DIR}/##"
}

list_skills_cmd() {
  local dir
  for dir in "$SKILLS_DIR"/*; do
    [[ -d "$dir" ]] || continue
    local manifest="${dir}/manifest.yaml"
    local name
    local display_name
    local description
    name="$(basename "$dir")"
    if [[ -f "$manifest" ]]; then
      display_name="$(manifest_value "$manifest" "display_name")"
      description="$(manifest_value "$manifest" "description")"
      printf '%s\t%s\t%s\n' "$name" "$display_name" "$description"
    else
      printf '%s\t%s\t%s\n' "$name" "$name" "No manifest.yaml"
    fi
  done
}

bundle_cmd() {
  local phase=""
  local change=""
  local agent=""
  local pack=""
  local skills_csv=""
  local user_prompt=""
  local out_file=""
  local include_refs="false"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --phase)
        [[ $# -gt 1 ]] || fail "--phase requires a value"
        phase="$2"
        shift 2
        ;;
      --change)
        [[ $# -gt 1 ]] || fail "--change requires a value"
        change="$2"
        shift 2
        ;;
      --agent)
        [[ $# -gt 1 ]] || fail "--agent requires a value"
        agent="$2"
        shift 2
        ;;
      --pack)
        [[ $# -gt 1 ]] || fail "--pack requires a value"
        pack="$2"
        shift 2
        ;;
      --skills)
        [[ $# -gt 1 ]] || fail "--skills requires a value"
        skills_csv="$2"
        shift 2
        ;;
      --user-prompt)
        [[ $# -gt 1 ]] || fail "--user-prompt requires a value"
        user_prompt="$2"
        shift 2
        ;;
      --out)
        [[ $# -gt 1 ]] || fail "--out requires a value"
        out_file="$2"
        shift 2
        ;;
      --no-references)
        include_refs="false"
        shift
        ;;
      --references)
        include_refs="true"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "Unknown option for bundle: $1"
        ;;
    esac
  done

  [[ -z "$phase" ]] || phase_contract_skill "$phase" >/dev/null

  pack="$(resolve_pack_selection "$pack")" || exit $?

  if [[ -z "$agent" ]]; then
    agent="orchestrator"
  fi

  if [[ -z "$skills_csv" ]]; then
    if [[ -n "$phase" ]]; then
      skills_csv="$(phase_default_skills "$phase" "$pack" "$user_prompt")"
    else
      skills_csv="$(phase_default_skills "implementation" "$pack" "$user_prompt")"
    fi
  fi

  local agent_file
  local ts
  agent_file="$(resolve_agent_file "$agent")"
  ts="$(date -u +%Y%m%d-%H%M%S)"

  if [[ -z "$out_file" ]]; then
    out_file="${OPENCODE_DIR}/session-bundle-${ts}.md"
  fi
  mkdir -p "$(dirname "$out_file")"

  {
    printf '# OpenCode Session Bundle\n\n'
    if [[ -n "$user_prompt" ]]; then
      printf '## User Goal\n\n'
      include_text_as_fenced_md "Operator Request" "text" "$user_prompt"
    fi
    printf '## Generated Context\n\n'
    printf -- '- Generated: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf -- '- Module directory: `%s`\n' "$MODULE_DIR"
    printf -- '- Project root: `%s`\n' "$PROJECT_ROOT"
    if [[ -n "$phase" ]]; then
      printf -- '- Phase: `%s`\n' "$phase"
    fi
    printf -- '- Pack: `%s`\n' "$pack"
    if [[ -n "$change" ]]; then
      printf -- '- Change: `%s`\n' "$change"
    fi
    printf '\n'
  } > "$out_file"

  include_file_as_fenced_md "Agent: $(basename "$agent_file")" "$agent_file" >> "$out_file"

  local -a skills=()
  IFS=',' read -r -a skills <<<"$skills_csv"
  local raw skill_dir skill_name skill_file
  local references_listed="false"
  for raw in "${skills[@]}"; do
    [[ -n "$raw" ]] || continue
    skill_dir="$(resolve_skill_dir "$raw")"
    skill_name="$(basename "$skill_dir")"
    skill_file="${skill_dir}/SKILL.md"
    [[ -f "$skill_file" ]] || fail "Missing SKILL.md for skill: ${skill_name}"

    include_file_as_fenced_md "Skill: ${skill_name}" "$skill_file" >> "$out_file"

    if [[ -d "${skill_dir}/references" ]]; then
      if [[ "$include_refs" == "true" ]]; then
        while IFS= read -r ref_file; do
          include_file_as_fenced_md "Skill Reference: ${skill_name}/${ref_file#${skill_dir}/references/}" "$ref_file" >> "$out_file"
        done < <(find "${skill_dir}/references" -type f -name '*.md' | sort)
      else
        if [[ "$references_listed" == "false" ]]; then
          printf '## Available Skill References\n\n' >> "$out_file"
          references_listed="true"
        fi
        while IFS= read -r ref_file; do
          printf -- '- `%s/%s` (include with `--references`)\n' "$skill_name" "${ref_file#${skill_dir}/references/}" >> "$out_file"
        done < <(find "${skill_dir}/references" -type f -name '*.md' | sort)
        printf '\n' >> "$out_file"
      fi
    fi
  done

  local pack_file="${PACKS_DIR}/${pack}/pack.yaml"
  [[ -f "$pack_file" ]] || fail "Unknown pack after resolution: $pack"
  include_file_as_fenced_md "Pack Contract: ${pack}/pack.yaml" "$pack_file" >> "$out_file"

  if [[ -n "$change" ]]; then
    local change_dir
    change_dir="$(resolve_change_dir "$change")" || fail "OpenSpec change not found: ${change}"

    {
      printf '## OpenSpec Artifacts\n\n'
      printf -- '- Path: `%s`\n\n' "${change_dir#${PROJECT_ROOT}/}"
    } >> "$out_file"

    local artifact_file
    local -a artifacts=()
    case "${phase:-planning}" in
      planning) artifacts=(proposal.md design.md tasks.md) ;;
      implementation|verification) artifacts=(design.md tasks.md) ;;
      archive) artifacts=(proposal.md tasks.md) ;;
      spec-hardening) artifacts=(proposal.md design.md tasks.md) ;;
    esac
    for artifact_file in "${artifacts[@]}"; do
      if [[ -f "${change_dir}/${artifact_file}" ]]; then
        include_file_as_fenced_md "Change Artifact: ${artifact_file}" "${change_dir}/${artifact_file}" >> "$out_file"
      fi
    done

    if [[ -d "${change_dir}/specs" ]]; then
      while IFS= read -r spec_file; do
        include_file_as_fenced_md "Change Spec: ${spec_file#${change_dir}/}" "$spec_file" >> "$out_file"
      done < <(find "${change_dir}/specs" -type f -name 'spec.md' | sort)
    fi
    if [[ "$phase" == "archive" && -d "${change_dir}/evidence" ]]; then
      while IFS= read -r evidence_file; do
        include_file_as_fenced_md "Change Evidence: ${evidence_file#${change_dir}/}" "$evidence_file" >> "$out_file"
      done < <(find "${change_dir}/evidence" -type f -name '*.md' | sort)
    fi
  fi

  echo "$out_file"
  local lines bytes approximate_tokens
  lines="$(wc -l < "$out_file")"
  bytes="$(wc -c < "$out_file")"
  approximate_tokens=$(( (bytes + 3) / 4 ))
  printf 'Bundle lines: %s\n' "$lines" >&2
  printf 'Bundle bytes: %s\n' "$bytes" >&2
  printf 'Approximate tokens: %s (byte-count/4 estimate)\n' "$approximate_tokens" >&2
}

phase_cmd() {
  local phase="$1"
  shift || true

  local change=""
  local dry_run="false"
  local pack=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --change)
        [[ $# -gt 1 ]] || fail "--change requires a value"
        change="$2"
        shift 2
        ;;
      --dry-run)
        dry_run="true"
        shift
        ;;
      --pack)
        [[ $# -gt 1 ]] || fail "--pack requires a value"
        pack="$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "Unknown option for phase: $1"
        ;;
    esac
  done

  [[ -n "$change" ]] || fail "--change is required for phase command"
  require_openspec_cli

  local phase_skill
  phase_skill="$(phase_contract_skill "$phase")"
  pack="$(resolve_pack_selection "$pack")" || exit $?
  printf 'Agent: orchestrator\n'
  printf 'Phase skill: %s\n' "$phase_skill"
  printf 'Pack: %s\n' "$pack"

  case "$phase" in
    planning)
      run_or_print "$dry_run" openspec status --change "$change"
      run_or_print "$dry_run" openspec status --change "$change" --json
      ;;
    spec-hardening)
      run_or_print "$dry_run" openspec status --change "$change" --json
      run_or_print "$dry_run" openspec instructions apply --change "$change" --json
      ;;
    implementation)
      run_or_print "$dry_run" openspec status --change "$change" --json
      run_or_print "$dry_run" openspec instructions apply --change "$change" --json
      ;;
    verification)
      run_or_print "$dry_run" openspec status --change "$change" --json
      run_or_print "$dry_run" openspec validate "$change" --strict
      ;;
    archive)
      run_or_print "$dry_run" openspec status --change "$change" --json
      run_or_print "$dry_run" openspec archive "$change"
      ;;
  esac
}

usage() {
  cat <<'EOF'
OpenCode helper runner for this repository.

Usage:
  ./opencode-runner.sh doctor
  ./opencode-runner.sh list agents
  ./opencode-runner.sh list skills
  ./opencode-runner.sh bundle [options]
  ./opencode-runner.sh phase <planning|spec-hardening|implementation|verification|archive> --change <name> [--pack <name>] [--dry-run]

Bundle options:
  --phase <phase>              planning|spec-hardening|implementation|verification|archive
  --change <name>              OpenSpec change name to include artifacts
  --agent <name|path>          Agent file or name (default: orchestrator)
  --pack <name>                Explicit pack selection; otherwise config/evidence resolves it
  --skills <csv>               Comma-separated skills (default from phase)
  --user-prompt "<text>"       Optional user prompt section
  --out <file>                 Output bundle file
  --references                 Include skill references/*.md (opt-in)
  --no-references              Compatibility alias that keeps references omitted

Examples:
  ./opencode-runner.sh doctor
  ./opencode-runner.sh list agents
  ./opencode-runner.sh bundle --phase planning --change my-change --user-prompt "Draft proposal"
  ./opencode-runner.sh bundle --phase implementation --pack angular --user-prompt "Polish the Angular dashboard UI"
  ./opencode-runner.sh phase verification --change my-change --dry-run
EOF
}

main() {
  local cmd="${1:-}"
  case "$cmd" in
    doctor)
      shift
      doctor_cmd "$@"
      ;;
    list)
      shift
      local sub="${1:-}"
      case "$sub" in
        agents)
          list_agents_cmd
          ;;
        skills)
          list_skills_cmd
          ;;
        *)
          fail "Usage: .opencode/opencode-runner.sh list agents|skills"
          ;;
      esac
      ;;
    bundle)
      shift
      bundle_cmd "$@"
      ;;
    phase)
      shift
      local phase="${1:-}"
      [[ -n "$phase" ]] || fail "Usage: .opencode/opencode-runner.sh phase <phase> --change <name> [--dry-run]"
      shift || true
      phase_cmd "$phase" "$@"
      ;;
    -h|--help|"")
      usage
      ;;
    *)
      fail "Unknown command: ${cmd}"
      ;;
  esac
}

main "$@"
