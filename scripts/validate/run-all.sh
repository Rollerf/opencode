#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

"${ROOT_DIR}/scripts/validate/contracts.sh"
"${ROOT_DIR}/scripts/validate/gitflow-branching-contract.sh"
"${ROOT_DIR}/scripts/validate/tdd-contract.sh"
"${ROOT_DIR}/scripts/validate/angular-ui-contract.sh"
"${ROOT_DIR}/scripts/validate/web-ui-ux-contract.sh"
"${ROOT_DIR}/scripts/validate/n8n-skills-contract.sh"

echo "All validation contracts passed"
