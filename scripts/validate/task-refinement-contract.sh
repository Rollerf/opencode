#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Missing required file: ${1#${ROOT_DIR}/}"
}

require_contains() {
  local file="$1"
  local text="$2"
  grep -Fq -- "$text" "$file" || fail "Missing required text in ${file#${ROOT_DIR}/}: $text"
}

TEMPLATE="${ROOT_DIR}/core/templates/tasks.md"
PLANNING="${ROOT_DIR}/skill/openspec-planning/SKILL.md"
HARDENING="${ROOT_DIR}/skill/openspec-spec-hardening/SKILL.md"
REFINEMENT="${ROOT_DIR}/skill/openspec-task-refinement/SKILL.md"
WORKFLOW="${ROOT_DIR}/skill/openspec-workflow/SKILL.md"
CHECKLISTS="${ROOT_DIR}/skill/openspec-workflow/references/phase-checklists.md"
ORCHESTRATOR="${ROOT_DIR}/agents/orchestrator.md"
ROUTING="${ROOT_DIR}/core/routing-policy.md"
CORE_WORKFLOW="${ROOT_DIR}/core/workflow-contract.md"
PHASE_CATALOG="${ROOT_DIR}/core/phase-contract-catalog.yaml"
IMPLEMENTATION="${ROOT_DIR}/skill/openspec-implementation/SKILL.md"

for file in "$TEMPLATE" "$PLANNING" "$HARDENING" "$REFINEMENT" "$WORKFLOW" "$CHECKLISTS" \
  "$ORCHESTRATOR" "$ROUTING" "$CORE_WORKFLOW" "$PHASE_CATALOG" "$IMPLEMENTATION"; do
  require_file "$file"
done

for marker in \
  "Task Refinement Gate" \
  "Status: <READY|BLOCKED>" \
  "Execution Blocks" \
  "Block ID" \
  "Ordered tasks" \
  "Executor" \
  "Requirements" \
  "Dependencies" \
  "Execution block" \
  "Targets" \
  "RED" \
  "GREEN" \
  "REFACTOR" \
  "Evidence" \
  "Completion"; do
  require_contains "$TEMPLATE" "$marker"
done

require_contains "$TEMPLATE" "TDD: Not applicable — <reason>"
require_contains "$PLANNING" "Draft tasks"
require_contains "$PLANNING" "task refinement"
require_contains "$HARDENING" "decision closure"
require_contains "$HARDENING" "does not make draft tasks executor-ready"
require_contains "$REFINEMENT" "two to five cohesive tasks"
require_contains "$REFINEMENT" "Task Refinement Gate"
require_contains "$REFINEMENT" "Compact block communication"
require_contains "$WORKFLOW" "draft planning -> spec hardening -> task refinement -> block implementation"
require_contains "$WORKFLOW" "READY"
require_contains "$CHECKLISTS" "Task refinement"
require_contains "$CHECKLISTS" "two to five"
require_contains "$ORCHESTRATOR" 'Task-refinement intent -> `$openspec-planning` plus `$openspec-task-refinement`'
require_contains "$ORCHESTRATOR" 'delegate the complete block to `subagent/refined-task-executor-subagent`'
require_contains "$ORCHESTRATOR" 'resume the same child session'
require_contains "$ORCHESTRATOR" 'does not silently implement the block with Sol'
require_contains "$ROUTING" 'Task refinement intent'
require_contains "$ROUTING" 'Task Refinement Gate is `READY`'
require_contains "$ROUTING" 'openai/gpt-5.6-luna'
require_contains "$ROUTING" 'variant `high`'
require_contains "$ROUTING" 'explicit operator override'
require_contains "$CORE_WORKFLOW" 'Effective executor'
require_contains "$CORE_WORKFLOW" 'Task Refinement Gate'
require_contains "$IMPLEMENTATION" 'one complete executor-ready block'
require_contains "$IMPLEMENTATION" '`PARTIAL`'
require_contains "$IMPLEMENTATION" 'planning artifacts change'
require_contains "$IMPLEMENTATION" 'Stop on every newly discovered decision gap'
[[ "$(grep -Ec '^  - id:' "$PHASE_CATALOG")" -eq 5 ]] || fail "Phase catalog must keep exactly five phase IDs"
if grep -Eq '^  - id: task-refinement$' "$PHASE_CATALOG"; then
  fail "Task refinement must not become a top-level phase"
fi

echo "Task refinement contract passed"
