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

README_FILE="${ROOT_DIR}/README.md"
CONTRIB_FILE="${ROOT_DIR}/CONTRIBUTING.md"
WORKFLOW_FILE="${ROOT_DIR}/core/workflow-contract.md"
ORCH_FILE="${ROOT_DIR}/agents/orchestrator.md"

require_file "$README_FILE"
require_file "$CONTRIB_FILE"
require_file "$WORKFLOW_FILE"
require_file "$ORCH_FILE"

require_contains "$README_FILE" '**Gitflow**'
require_contains "$README_FILE" 'each OpenSpec change should map to its own `feature/<change-name>` branch created from `develop`'
require_contains "$README_FILE" 'release branch is cut from `develop`'

require_contains "$CONTRIB_FILE" 'Use gitflow for branch lifecycle across all consumer projects.'
require_contains "$CONTRIB_FILE" '## Branching strategy (gitflow)'
require_contains "$CONTRIB_FILE" 'Create a dedicated `feature/<change-name>` branch from `develop` for each OpenSpec change.'
require_contains "$CONTRIB_FILE" 'After release merges to `main`, sync `main` back into `develop`.'

require_contains "$WORKFLOW_FILE" '## Branching Strategy Contract'
require_contains "$WORKFLOW_FILE" 'All repositories consuming this platform SHALL use gitflow as the default branching model.'
require_contains "$WORKFLOW_FILE" 'Each OpenSpec change SHALL be implemented on its own `feature/*` branch created from `develop`.'

require_contains "$ORCH_FILE" 'Treat each OpenSpec change as work that belongs on its own `feature/*` branch created from `develop`.'

echo "Gitflow branching contract validation passed"
