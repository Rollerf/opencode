#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Missing required file: $1"
}

require_contains() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    fail "Missing required text in ${file#${ROOT_DIR}/}: $text"
  fi
}

require_file "${ROOT_DIR}/core/workflow-contract.md"
require_file "${ROOT_DIR}/core/routing-policy.md"
require_file "${ROOT_DIR}/core/agent-catalog.yaml"
require_file "${ROOT_DIR}/core/phase-contract-catalog.yaml"
require_file "${ROOT_DIR}/core/templates/proposal.md"
require_file "${ROOT_DIR}/core/templates/design.md"
require_file "${ROOT_DIR}/core/templates/spec.md"
require_file "${ROOT_DIR}/core/templates/tasks.md"

ORCHESTRATOR="${ROOT_DIR}/agents/orchestrator.md"
require_file "$ORCHESTRATOR"
require_contains "$ORCHESTRATOR" "Always state current phase"
require_contains "$ORCHESTRATOR" "Always list touched files and commands executed"
require_contains "$ORCHESTRATOR" "RED -> GREEN -> REFACTOR"
require_contains "$ORCHESTRATOR" "Single-entrypoint execution mode"
require_contains "$ORCHESTRATOR" "routing selects the phase contract"
require_contains "$ORCHESTRATOR" './.opencode/opencode-runner.sh'
require_contains "$ORCHESTRATOR" '$HOME/.config/opencode/opencode-runner.sh'
require_contains "$ORCHESTRATOR" 'absence of the first candidate alone does not make the runner unavailable'
require_contains "${ROOT_DIR}/core/routing-policy.md" "Single-entrypoint orchestration"
require_contains "${ROOT_DIR}/skill/openspec-workflow/SKILL.md" 'Do not treat a missing `./opencode-runner.sh` as sufficient reason to bypass the runner'
require_contains "${ROOT_DIR}/skill/openspec-planning/SKILL.md" "OpenSpec Planning Contract"
require_contains "${ROOT_DIR}/skill/openspec-implementation/SKILL.md" "OpenSpec Implementation Contract"
require_contains "${ROOT_DIR}/skill/openspec-verification/SKILL.md" "OpenSpec Verification Contract"
require_contains "${ROOT_DIR}/skill/openspec-archive/SKILL.md" "OpenSpec Archive Contract"

openspec_dependency="$(node -p "require('${ROOT_DIR}/package.json').dependencies?.['@fission-ai/openspec'] || ''")"
[[ "$openspec_dependency" == "1.1.1" ]] ||
  fail "package.json must declare exact runtime dependency @fission-ai/openspec@1.1.1"

echo "Contract validation passed"
