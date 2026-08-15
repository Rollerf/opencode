#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
PACK_FILE="${ROOT_DIR}/packs/astro/pack.yaml"
README_FILE="${ROOT_DIR}/packs/astro/README.md"
PLAYWRIGHT_TEMPLATE="${ROOT_DIR}/packs/astro/templates/playwright.config.ts"
LLMS_TEMPLATE="${ROOT_DIR}/packs/astro/templates/public/llms.txt"
PRIVACY_TEST_TEMPLATE="${ROOT_DIR}/packs/astro/templates/tests/privacy/consent.spec.ts"
ACCESSIBILITY_TEST_TEMPLATE="${ROOT_DIR}/packs/astro/templates/tests/accessibility/accessibility.spec.ts"
COOKIE_CHECKLIST="${ROOT_DIR}/packs/astro/templates/cookie-policy-checklist.md"
ACCESSIBILITY_CHECKLIST="${ROOT_DIR}/packs/astro/templates/accessibility-checklist.md"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

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
  if ! grep -Fq -- "$text" "$file"; then
    fail "Missing required text in ${file#${ROOT_DIR}/}: $text"
  fi
}

require_not_contains() {
  local file="$1"
  local text="$2"
  if grep -Fq -- "$text" "$file"; then
    fail "Unexpected text in ${file#${ROOT_DIR}/}: $text"
  fi
}

require_output_contains() {
  local output="$1"
  local text="$2"
  [[ "$output" == *"$text"* ]] || fail "Expected resolver output to contain: $text"
}

resolve_fixture() {
  node "${ROOT_DIR}/scripts/resolve-pack.mjs" \
    --module-dir "$ROOT_DIR" \
    --project-root "$1" \
    --field json 2>&1
}

require_file "$PACK_FILE"
require_file "$README_FILE"
require_file "$PLAYWRIGHT_TEMPLATE"
require_file "$LLMS_TEMPLATE"
require_file "$PRIVACY_TEST_TEMPLATE"
require_file "$ACCESSIBILITY_TEST_TEMPLATE"
require_file "$COOKIE_CHECKLIST"
require_file "$ACCESSIBILITY_CHECKLIST"

for text in \
  'name: astro' \
  'path: astro.config.mjs' \
  'value: '"'\"astro\"'" \
  'visibility: public' \
  'seo_required: true' \
  'ai_discoverability_required: true' \
  'accessibility_target: "WCAG 2.2 AA"' \
  'european_accessibility_reference: "EN 301 549"' \
  'openapi_client_required: true' \
  'analytics_provider: google-analytics' \
  'analytics_default_consent: denied' \
  '      - seo-expert' \
  '      - web-ui-ux' \
  '      - backend-design' \
  '  api_contract: "npm run api:check"' \
  '  seo: "npm run audit:lighthouse"' \
  '  accessibility: "npm run audit:a11y"' \
  '  generate: "npm run api:generate"' \
  '  check: "npm run api:check"' \
  '  preview: "npm run preview -- --host 0.0.0.0 --port 4321"' \
  '  lighthouse: "AUDIT_URL=http://127.0.0.1:4321 npm run audit:lighthouse"' \
  '  ai_discovery: "curl --fail --silent --show-error http://127.0.0.1:4321/llms.txt"' \
  '  privacy: "npx playwright test tests/privacy --config=playwright.config.ts"' \
  '  accessibility: "npx playwright test tests/accessibility --config=playwright.config.ts"' \
  'local_only: true' \
  '    - deploy' \
  '    - release' \
  '    - production-change'; do
  require_contains "$PACK_FILE" "$text"
done

for path in \
  'packs/astro/templates/playwright.config.ts' \
  'packs/astro/templates/public/llms.txt' \
  'packs/astro/templates/tests/privacy/consent.spec.ts' \
  'packs/astro/templates/tests/accessibility/accessibility.spec.ts' \
  'packs/astro/templates/cookie-policy-checklist.md' \
  'packs/astro/templates/accessibility-checklist.md'; do
  require_contains "$PACK_FILE" "$path"
done

for text in \
  'WCAG 2.2 Level AA' \
  'EN 301 549' \
  'Real Decreto 193/2023' \
  'Ley 11/2023' \
  'semantic HTML' \
  'ARIA' \
  'manual keyboard' \
  'screen reader' \
  '320 CSS pixels' \
  'maps and plans' \
  'npm run api:generate' \
  'npm run api:check' \
  'generated code' \
  'RFC 7807' \
  'default-denied' \
  'Google Analytics' \
  'Accept, reject, and configure' \
  'cookie inventory' \
  'data minimization' \
  'llms.txt' \
  'evolving discovery convention' \
  'does not grant crawler access' \
  'published content' \
  'last-known-good' \
  'S3' \
  'Lambda'; do
  require_contains "$README_FILE" "$text"
done

require_contains "$LLMS_TEMPLATE" '# <Site Name>'
require_contains "$LLMS_TEMPLATE" '> <Factual summary of the public site>'
require_contains "$LLMS_TEMPLATE" '## Key pages'
require_contains "$LLMS_TEMPLATE" 'https://www.example.com/'

for text in \
  'Accept all' \
  'Reject all' \
  'Configure' \
  'Revoke consent' \
  'googletagmanager.com' \
  'google-analytics.com'; do
  require_contains "$PRIVACY_TEST_TEMPLATE" "$text"
done

for text in \
  'Keyboard' \
  'Screen reader' \
  'Zoom and reflow' \
  'Forms and validation' \
  'Multimedia' \
  'Maps and plans' \
  'Automated checks alone do not demonstrate WCAG conformity'; do
  require_contains "$ACCESSIBILITY_CHECKLIST" "$text"
done

for text in \
  'Provider' \
  'Purpose' \
  'Duration' \
  'Recipients or transfers' \
  'Withdrawal method' \
  'Policy version'; do
  require_contains "$COOKIE_CHECKLIST" "$text"
done

complete="${TMP_DIR}/complete"
mkdir -p "$complete"
printf '%s\n' '// Astro config fixture' >"${complete}/astro.config.mjs"
printf '%s\n' '{"dependencies":{"astro":"latest"}}' >"${complete}/package.json"
complete_output="$(resolve_fixture "$complete")"
require_output_contains "$complete_output" '"pack":"astro"'
require_output_contains "$complete_output" 'path_exists astro.config.mjs'
require_output_contains "$complete_output" 'file_contains package.json contains \"\\\"astro\\\"\"'

missing_config="${TMP_DIR}/missing-config"
mkdir -p "$missing_config"
printf '%s\n' '{"dependencies":{"astro":"latest"}}' >"${missing_config}/package.json"
set +e
missing_config_output="$(resolve_fixture "$missing_config")"
missing_config_status=$?
set -e
[[ $missing_config_status -eq 2 ]] || fail "Missing-config fixture should fail pack resolution"
require_output_contains "$missing_config_output" 'Missing: path_exists astro.config.mjs'

missing_dependency="${TMP_DIR}/missing-dependency"
mkdir -p "$missing_dependency"
printf '%s\n' '// Astro config fixture' >"${missing_dependency}/astro.config.mjs"
printf '%s\n' '{"dependencies":{}}' >"${missing_dependency}/package.json"
set +e
missing_dependency_output="$(resolve_fixture "$missing_dependency")"
missing_dependency_status=$?
set -e
[[ $missing_dependency_status -eq 2 ]] || fail "Missing-dependency fixture should fail pack resolution"
require_output_contains "$missing_dependency_output" 'Missing: file_contains package.json contains "\"astro\""'

public_bundle="${TMP_DIR}/public-bundle.md"
frontend_bundle="${TMP_DIR}/frontend-bundle.md"
fullstack_bundle="${TMP_DIR}/fullstack-bundle.md"

"${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation --pack astro --user-prompt "Update Astro metadata" --out "$public_bundle" >/dev/null
require_contains "$public_bundle" 'Skill: seo-expert'
require_not_contains "$public_bundle" 'Skill: backend-design'

"${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation --pack astro --user-prompt "Implement Astro frontend component and responsive UI" --out "$frontend_bundle" >/dev/null
require_contains "$frontend_bundle" 'Skill: seo-expert'
require_contains "$frontend_bundle" 'Skill: web-ui-ux'
require_not_contains "$frontend_bundle" 'Skill: backend-design'

"${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation --pack astro --user-prompt "Implement Astro frontend component and update Go Lambda backend API" --out "$fullstack_bundle" >/dev/null
require_contains "$fullstack_bundle" 'Skill: seo-expert'
require_contains "$fullstack_bundle" 'Skill: web-ui-ux'
require_contains "$fullstack_bundle" 'Skill: backend-design'

echo "Astro pack contract validation passed"
