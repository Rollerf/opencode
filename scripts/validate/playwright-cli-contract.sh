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

require_missing_dir() {
  [[ ! -d "$1" ]] || fail "Unexpected directory still present: $1"
}

require_contains() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    fail "Missing required text in ${file#${ROOT_DIR}/}: $text"
  fi
}

require_dir "${ROOT_DIR}/skill/playwright-cli"
require_dir "${ROOT_DIR}/skill/playwright-cli/references"
require_file "${ROOT_DIR}/skill/playwright-cli/manifest.yaml"
require_file "${ROOT_DIR}/skill/playwright-cli/SKILL.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/playwright-tests.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/request-mocking.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/running-code.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/session-management.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/storage-state.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/test-generation.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/tracing.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/video-recording.md"
require_file "${ROOT_DIR}/skill/playwright-cli/references/element-attributes.md"

require_contains "${ROOT_DIR}/skill/playwright-cli/manifest.yaml" 'explicit_tag: "$playwright-cli"'
require_contains "${ROOT_DIR}/skill/web-ui-ux/SKILL.md" '$playwright-cli'
require_contains "${ROOT_DIR}/README.md" '$playwright-cli'
require_contains "${ROOT_DIR}/packs/angular/README.md" '$playwright-cli'

require_missing_dir "${ROOT_DIR}/.claude/skills/playwright-cli"

echo "Playwright CLI contract validation passed"
