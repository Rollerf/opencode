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

INSTRUCTION_FILE="${ROOT_DIR}/instructions/caveman-default.md"
PLUGIN_FILE="${ROOT_DIR}/plugins/rtk.ts"
TEMPLATE_FILE="${ROOT_DIR}/core/templates/opencode.global.json"
ORCHESTRATOR_FILE="${ROOT_DIR}/agents/orchestrator.md"
RUNNER_FILE="${ROOT_DIR}/scripts/validate/run-all.sh"

require_file "$INSTRUCTION_FILE"
require_file "$PLUGIN_FILE"
require_file "$TEMPLATE_FILE"
require_file "$ORCHESTRATOR_FILE"
require_file "$RUNNER_FILE"

require_contains "$INSTRUCTION_FILE" 'load `$caveman` and apply full mode'
require_contains "$INSTRUCTION_FILE" '`stop caveman` or `normal mode`'
require_contains "$INSTRUCTION_FILE" 'OpenSpec artifacts'
require_contains "$INSTRUCTION_FILE" 'If the skill is unavailable'

require_contains "$PLUGIN_FILE" 'import type { Plugin } from "@opencode-ai/plugin"'
require_contains "$PLUGIN_FILE" 'export const RtkOpenCodePlugin'
require_contains "$PLUGIN_FILE" '"tool.execute.before"'
require_contains "$PLUGIN_FILE" 'rtk rewrite ${command}'
require_contains "$PLUGIN_FILE" 'tool !== "bash" && tool !== "shell"'
require_contains "$PLUGIN_FILE" 'return {}'

require_contains "$ORCHESTRATOR_FILE" 'apply `$caveman` full mode by default'
require_contains "$ORCHESTRATOR_FILE" '`stop caveman`'
require_contains "$ORCHESTRATOR_FILE" '`normal mode`'
require_contains "$RUNNER_FILE" 'token-savings-defaults-contract.sh'

node - "$TEMPLATE_FILE" <<'NODE'
const { readFileSync } = require("node:fs")

const path = process.argv[2]
const config = JSON.parse(readFileSync(path, "utf8"))
const expectedInstruction = "instructions/caveman-default.md"
const expectedSkillPaths = ["skill", ".agents/skills"]

if (!config.instructions?.includes(expectedInstruction)) {
  throw new Error(`global template must include ${expectedInstruction}`)
}
for (const skillPath of expectedSkillPaths) {
  if (!config.skills?.paths?.includes(skillPath)) {
    throw new Error(`global template must include skill path ${skillPath}`)
  }
}
if (JSON.stringify(config).includes("/home/") || config.provider || config.mcp) {
  throw new Error("global template contains machine-specific settings")
}
NODE

echo "Token-saving defaults contract validation passed"
