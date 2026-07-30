#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILL_DIR="${ROOT_DIR}/skill/seo-expert"
SKILL_FILE="${SKILL_DIR}/SKILL.md"
MANIFEST_FILE="${SKILL_DIR}/manifest.yaml"

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

require_file "$SKILL_FILE"
require_file "$MANIFEST_FILE"

require_contains "$SKILL_FILE" '---'
require_contains "$SKILL_FILE" 'name: seo-expert'
require_contains "$SKILL_FILE" 'description: Use ONLY when'
require_contains "$SKILL_FILE" 'Inspection-first workflow'
require_contains "$SKILL_FILE" 'Affected files'
require_contains "$SKILL_FILE" 'Validation evidence'
require_contains "$SKILL_FILE" 'black-hat'
require_contains "$SKILL_FILE" 'ranking guarantees'

require_contains "$MANIFEST_FILE" 'name: "seo-expert"'
require_contains "$MANIFEST_FILE" 'explicit_tag: "$seo-expert"'

require_contains "${ROOT_DIR}/agents/orchestrator.md" '$seo-expert'
require_contains "${ROOT_DIR}/agents/orchestrator.md" 'explicit SEO intent'
require_contains "${ROOT_DIR}/core/routing-policy.md" 'SEO requests'
require_contains "${ROOT_DIR}/core/routing-policy.md" 'Repository-local SEO fallback'
require_contains "${ROOT_DIR}/README.md" '$seo-expert'
require_contains "${ROOT_DIR}/CONTRIBUTING.md" 'seo-expert-contract.sh'

skill_listing="$(${ROOT_DIR}/opencode-runner.sh list skills)"
if ! grep -Eq '^seo-expert[[:space:]]' <<<"$skill_listing"; then
  fail "seo-expert is missing from opencode-runner.sh list skills"
fi

echo "SEO expert contract validation passed"
