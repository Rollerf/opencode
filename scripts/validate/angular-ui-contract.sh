#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
PACK_FILE="${ROOT_DIR}/packs/angular/pack.yaml"

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

require_file "$PACK_FILE"

require_contains "$PACK_FILE" "  ui_ux_template_paths:"
require_contains "$PACK_FILE" "    - packs/angular/templates/playwright.config.ts"
require_contains "$PACK_FILE" "    - packs/angular/templates/tests/ui/home.spec.ts"
require_contains "$PACK_FILE" "skill_overlays:"
require_contains "$PACK_FILE" "  ui_frontend:"
require_contains "$PACK_FILE" "    include:"
require_contains "$PACK_FILE" "      - web-ui-ux"
require_contains "$PACK_FILE" "    exclude:"
require_contains "$PACK_FILE" "      - backend-design"

require_contains "$PACK_FILE" "  ui_smoke: \"npx playwright test --config=playwright.config.ts\""
require_contains "$PACK_FILE" "ui_ux_commands:"
require_contains "$PACK_FILE" "  dev_server: \"npm start -- --host 0.0.0.0 --port 4200\""
require_contains "$PACK_FILE" "  snapshots: \"npx playwright test tests/ui --config=playwright.config.ts\""
require_contains "$PACK_FILE" "  snapshots_update: \"npx playwright test tests/ui --config=playwright.config.ts --update-snapshots\""
require_contains "$PACK_FILE" "  headed_review: \"npx playwright test tests/ui --config=playwright.config.ts --headed\""

require_file "${ROOT_DIR}/packs/angular/templates/playwright.config.ts"
require_file "${ROOT_DIR}/packs/angular/templates/tests/ui/home.spec.ts"

echo "Angular UI contract validation passed"
