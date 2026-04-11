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

require_dir() {
  [[ -d "$1" ]] || fail "Missing required directory: $1"
}

require_contains() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    fail "Missing required text in ${file#${ROOT_DIR}/}: $text"
  fi
}

require_dir "${ROOT_DIR}/third_party/n8n_skills"
require_dir "${ROOT_DIR}/third_party/n8n_skills/skills/n8n-mcp-tools-expert"
require_file "${ROOT_DIR}/third_party/n8n_skills/skills/n8n-mcp-tools-expert/SKILL.md"

require_file "${ROOT_DIR}/skill/n8n-gateway/manifest.yaml"
require_file "${ROOT_DIR}/skill/n8n-gateway/SKILL.md"
require_file "${ROOT_DIR}/skill/n8n-mcp-tools-expert/manifest.yaml"
require_file "${ROOT_DIR}/skill/n8n-mcp-tools-expert/SKILL.md"

require_contains "${ROOT_DIR}/skill/n8n-gateway/SKILL.md" "n8n-mcp-tools-expert"
require_contains "${ROOT_DIR}/skill/n8n-mcp-tools-expert/SKILL.md" "third_party/n8n_skills/skills/n8n-mcp-tools-expert/SKILL.md"

echo "n8n skills contract validation passed"
