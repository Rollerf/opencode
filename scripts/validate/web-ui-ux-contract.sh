#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
PACK_FILE="${ROOT_DIR}/packs/angular/pack.yaml"
RUNNER_FILE="${ROOT_DIR}/opencode-runner.sh"

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

require_not_contains() {
  local file="$1"
  local text="$2"
  if grep -Fq "$text" "$file"; then
    fail "Unexpected text in ${file#${ROOT_DIR}/}: $text"
  fi
}

require_file "${ROOT_DIR}/skill/web-ui-ux/manifest.yaml"
require_file "${ROOT_DIR}/skill/web-ui-ux/SKILL.md"
require_file "$PACK_FILE"
require_file "$RUNNER_FILE"

require_contains "${ROOT_DIR}/skill/web-ui-ux/manifest.yaml" 'explicit_tag: "$web-ui-ux"'
require_contains "$PACK_FILE" 'skill_overlays:'
require_contains "$PACK_FILE" 'ui_frontend:'
require_contains "$PACK_FILE" '      - web-ui-ux'
require_contains "$PACK_FILE" '      - backend-design'

require_contains "${ROOT_DIR}/agents/implementer.md" '$web-ui-ux'
require_contains "${ROOT_DIR}/agents/implementer.md" 'Do not apply `$backend-design` to frontend-only work'
require_contains "${ROOT_DIR}/agents/orchestrator.md" '$web-ui-ux'
require_contains "${ROOT_DIR}/agents/orchestrator.md" 'Do not route frontend-only work through `$backend-design`'
require_contains "${ROOT_DIR}/core/routing-policy.md" 'Angular frontend/UI requests'

bundle_frontend="$(mktemp)"
bundle_fullstack="$(mktemp)"
bundle_backend="$(mktemp)"
trap 'rm -f "$bundle_frontend" "$bundle_fullstack" "$bundle_backend"' EXIT

"${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation --pack angular --user-prompt "Implement Angular frontend UI with responsive design" --out "$bundle_frontend" >/dev/null
require_contains "$bundle_frontend" 'Skill: web-ui-ux'
require_not_contains "$bundle_frontend" 'Skill: backend-design'

"${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation --pack angular --user-prompt "Implement Angular frontend UI and update backend API handlers" --out "$bundle_fullstack" >/dev/null
require_contains "$bundle_fullstack" 'Skill: web-ui-ux'
require_contains "$bundle_fullstack" 'Skill: backend-design'

"${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation --pack go-aws --user-prompt "Implement backend API endpoint" --out "$bundle_backend" >/dev/null
require_contains "$bundle_backend" 'Skill: backend-design'

echo "Web UI UX contract validation passed"
