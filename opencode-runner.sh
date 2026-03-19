#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -d "${SCRIPT_DIR}/openspec" ]]; then
  ROOT_DIR="${SCRIPT_DIR}"
else
  ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
fi
if [[ -d "${ROOT_DIR}/agents" && -d "${ROOT_DIR}/skill" ]]; then
  OPENCODE_DIR="${ROOT_DIR}"
  AGENTS_DIR="${ROOT_DIR}/agents"
  SKILLS_DIR="${ROOT_DIR}/skill"
else
  OPENCODE_DIR="${ROOT_DIR}/.opencode"
  AGENTS_DIR="${OPENCODE_DIR}/agents"
  SKILLS_DIR="${OPENCODE_DIR}/skill"
fi

fail() {
  echo "Error: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

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

phase_default_agent() {
  local phase="$1"
  case "$phase" in
    planning) echo "planner" ;;
    implementation) echo "implementer" ;;
    verification) echo "verifier" ;;
    archive) echo "archiver" ;;
    *) echo "orchestrator" ;;
  esac
}

phase_default_skills() {
  local phase="$1"
  case "$phase" in
    planning|implementation|verification) echo "openspec-workflow,backend-design" ;;
    archive) echo "openspec-workflow" ;;
    *) echo "openspec-workflow,backend-design" ;;
  esac
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
  local active="${ROOT_DIR}/openspec/changes/${change}"
  local archived="${ROOT_DIR}/openspec/changes/archive/${change}"

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

include_file_as_fenced_md() {
  local label="$1"
  local file="$2"
  {
    printf '### %s\n\n' "$label"
    printf '```md\n'
    cat "$file"
    printf '\n```\n\n'
  }
}

run_or_print() {
  local dry_run="$1"
  shift
  printf '+'
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf '\n'
  if [[ "$dry_run" == "false" ]]; then
    "$@"
  fi
}

doctor_cmd() {
  [[ -d "$AGENTS_DIR" ]] || fail "Missing agents directory: ${AGENTS_DIR#${ROOT_DIR}/}"
  [[ -d "$SKILLS_DIR" ]] || fail "Missing skill directory: ${SKILLS_DIR#${ROOT_DIR}/}"

  require_cmd openspec
  echo "ok: runner structure (${OPENCODE_DIR#${ROOT_DIR}/})"
  echo "ok: openspec command found ($(openspec --version 2>/dev/null || echo unknown))"

  if openspec status --json >/dev/null 2>&1; then
    echo "ok: openspec status available"
  else
    echo "warn: openspec has no active changes yet (this is fine)"
  fi
}

list_agents_cmd() {
  find "$AGENTS_DIR" -type f -name '*.md' | sort | sed "s#^${ROOT_DIR}/##"
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
  local skills_csv=""
  local user_prompt=""
  local out_file=""
  local include_refs="true"

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
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "Unknown option for bundle: $1"
        ;;
    esac
  done

  if [[ -z "$agent" ]]; then
    if [[ -n "$phase" ]]; then
      agent="$(phase_default_agent "$phase")"
    else
      agent="orchestrator"
    fi
  fi

  if [[ -z "$skills_csv" ]]; then
    if [[ -n "$phase" ]]; then
      skills_csv="$(phase_default_skills "$phase")"
    else
      skills_csv="openspec-workflow,backend-design"
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
    printf -- '- Generated: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf -- '- Repo: `%s`\n' "$ROOT_DIR"
    if [[ -n "$phase" ]]; then
      printf -- '- Phase: `%s`\n' "$phase"
    fi
    if [[ -n "$change" ]]; then
      printf -- '- Change: `%s`\n' "$change"
    fi
    printf '\n'
  } > "$out_file"

  include_file_as_fenced_md "Agent: $(basename "$agent_file")" "$agent_file" >> "$out_file"

  local -a skills=()
  IFS=',' read -r -a skills <<<"$skills_csv"
  local raw skill_dir skill_name skill_file
  for raw in "${skills[@]}"; do
    [[ -n "$raw" ]] || continue
    skill_dir="$(resolve_skill_dir "$raw")"
    skill_name="$(basename "$skill_dir")"
    skill_file="${skill_dir}/SKILL.md"
    [[ -f "$skill_file" ]] || fail "Missing SKILL.md for skill: ${skill_name}"

    include_file_as_fenced_md "Skill: ${skill_name}" "$skill_file" >> "$out_file"

    if [[ "$include_refs" == "true" && -d "${skill_dir}/references" ]]; then
      while IFS= read -r ref_file; do
        include_file_as_fenced_md "Skill Reference: ${skill_name}/$(basename "$ref_file")" "$ref_file" >> "$out_file"
      done < <(find "${skill_dir}/references" -type f -name '*.md' | sort)
    fi
  done

  if [[ -n "$change" ]]; then
    local change_dir
    change_dir="$(resolve_change_dir "$change")" || fail "OpenSpec change not found: ${change}"

    {
      printf '## OpenSpec Artifacts\n\n'
      printf -- '- Path: `%s`\n\n' "${change_dir#${ROOT_DIR}/}"
    } >> "$out_file"

    local artifact_file
    for artifact_file in proposal.md design.md tasks.md; do
      if [[ -f "${change_dir}/${artifact_file}" ]]; then
        include_file_as_fenced_md "Change Artifact: ${artifact_file}" "${change_dir}/${artifact_file}" >> "$out_file"
      fi
    done

    if [[ -d "${change_dir}/specs" ]]; then
      while IFS= read -r spec_file; do
        include_file_as_fenced_md "Change Spec: ${spec_file#${change_dir}/}" "$spec_file" >> "$out_file"
      done < <(find "${change_dir}/specs" -type f -name 'spec.md' | sort)
    fi
  fi

  if [[ -n "$user_prompt" ]]; then
    {
      printf '## User Prompt\n\n'
      printf '```text\n%s\n```\n' "$user_prompt"
    } >> "$out_file"
  fi

  echo "$out_file"
}

phase_cmd() {
  local phase="$1"
  shift || true

  local change=""
  local dry_run="false"

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

  case "$phase" in
    planning)
      run_or_print "$dry_run" openspec status --change "$change"
      run_or_print "$dry_run" openspec status --change "$change" --json
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
    *)
      fail "Unknown phase: ${phase}. Expected planning|implementation|verification|archive"
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
  ./opencode-runner.sh phase <planning|implementation|verification|archive> --change <name> [--dry-run]

Bundle options:
  --phase <phase>              planning|implementation|verification|archive
  --change <name>              OpenSpec change name to include artifacts
  --agent <name|path>          Agent file or name (default: phase default or orchestrator)
  --skills <csv>               Comma-separated skills (default from phase)
  --user-prompt "<text>"       Optional user prompt section
  --out <file>                 Output bundle file
  --no-references              Skip skill references/*.md

Examples:
  ./opencode-runner.sh doctor
  ./opencode-runner.sh list agents
  ./opencode-runner.sh bundle --phase planning --change my-change --user-prompt "Draft proposal"
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
