#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

node "${ROOT_DIR}/scripts/validate/runtime-definitions.mjs" --self-test
node "${ROOT_DIR}/scripts/validate/runtime-definitions.mjs"
"${ROOT_DIR}/scripts/validate/runtime-runner-contract.sh"
"${ROOT_DIR}/scripts/validate/runtime-consumer-contract.sh"
"${ROOT_DIR}/scripts/validate/contracts.sh"
"${ROOT_DIR}/scripts/validate/gitflow-branching-contract.sh"
"${ROOT_DIR}/scripts/validate/tdd-contract.sh"
"${ROOT_DIR}/scripts/validate/angular-ui-contract.sh"
"${ROOT_DIR}/scripts/validate/web-ui-ux-contract.sh"
"${ROOT_DIR}/scripts/validate/playwright-cli-contract.sh"
"${ROOT_DIR}/scripts/validate/n8n-skills-contract.sh"
"${ROOT_DIR}/scripts/validate/seo-expert-contract.sh"

echo "All validation contracts passed"
