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
require_file "${ROOT_DIR}/core/templates/proposal.md"
require_file "${ROOT_DIR}/core/templates/design.md"
require_file "${ROOT_DIR}/core/templates/spec.md"
require_file "${ROOT_DIR}/core/templates/tasks.md"

ORCHESTRATOR="${ROOT_DIR}/agents/orchestrator.md"
require_file "$ORCHESTRATOR"
require_contains "$ORCHESTRATOR" "Always state current phase"
require_contains "$ORCHESTRATOR" "Always list touched files and commands executed"
require_contains "$ORCHESTRATOR" "RED -> GREEN -> REFACTOR"

echo "Contract validation passed"
