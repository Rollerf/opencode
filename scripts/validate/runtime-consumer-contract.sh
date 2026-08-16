#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
CONSUMER="${TMP_DIR}/consumer"
trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_contains() {
  local text="$1"
  local expected="$2"
  [[ "$text" == *"$expected"* ]] || fail "Expected OpenCode debug output to contain: $expected"
}

mkdir -p "$CONSUMER"
ln -s "$ROOT_DIR" "${CONSUMER}/.opencode"
cp "${ROOT_DIR}/core/templates/opencode.consumer.json" "${CONSUMER}/opencode.json"

skills_output="$(cd "$CONSUMER" && opencode debug skill)"
for skill in \
  backend-design \
  codegraph \
  n8n-gateway \
  n8n-mcp-tools-expert \
  node-defi-arbitrage \
  openspec-archive \
  openspec-implementation \
  openspec-planning \
  openspec-spec-hardening \
  openspec-task-refinement \
  openspec-verification \
  openspec-workflow \
  playwright-cli \
  rtk \
  seo-expert \
  web-ui-ux; do
  require_contains "$skills_output" "$skill"
done

agent_output="$(cd "$CONSUMER" && opencode debug agent orchestrator)"
require_contains "$agent_output" '"providerID": "openai"'
require_contains "$agent_output" '"modelID": "gpt-5.6-sol"'
require_contains "$agent_output" 'workflow orchestrator'

executor_output="$(cd "$CONSUMER" && opencode debug agent subagent/refined-task-executor-subagent)"
require_contains "$executor_output" '"providerID": "openai"'
require_contains "$executor_output" '"modelID": "gpt-5.6-luna"'
require_contains "$executor_output" '"variant": "high"'

config_output="$(cd "$CONSUMER" && opencode debug config)"
require_contains "$config_output" '"default_agent": "orchestrator"'

echo "Runtime consumer discovery contract passed"
