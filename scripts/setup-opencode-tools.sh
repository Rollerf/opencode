#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ "$(basename "$MODULE_DIR")" == ".opencode" ]]; then
  PROJECT_ROOT="$(cd "${MODULE_DIR}/.." && pwd)"
else
  PROJECT_ROOT="$MODULE_DIR"
fi

if [[ "$MODULE_DIR" == "$PROJECT_ROOT" ]]; then
  MODULE_LABEL="."
else
  MODULE_LABEL="${MODULE_DIR#${PROJECT_ROOT}/}"
fi

cd "$PROJECT_ROOT"

STRICT=0
INIT_CODEGRAPH=0
CONFIGURE_GLOBAL=0

usage() {
  cat <<'USAGE'
Usage: scripts/setup-opencode-tools.sh [--strict] [--init-codegraph] [--configure-global]

From a consumer project that installs this repository as .opencode:
  bash .opencode/scripts/setup-opencode-tools.sh
  bash .opencode/scripts/setup-opencode-tools.sh --init-codegraph
  bash .opencode/scripts/setup-opencode-tools.sh --configure-global

Checks optional OpenCode tools supplied by the .opencode submodule:
  - Caveman local skills under .opencode/.agents/skills
  - CodeGraph CLI/MCP integration and optional project index
  - RTK CLI/OpenCode integration

Options:
  --strict            Exit non-zero when required CLIs/configuration are missing.
  --init-codegraph    If codegraph is installed, create/update the local .codegraph index.
  --configure-global  If installed, wire CodeGraph/RTK into global OpenCode config.

Notes:
  --configure-global changes files outside this repository. Use it only as an operator step.
  --init-codegraph runs in the consumer project root, not inside the .opencode submodule.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict) STRICT=1 ;;
    --init-codegraph) INIT_CODEGRAPH=1 ;;
    --configure-global) CONFIGURE_GLOBAL=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

missing=0

ok() { printf 'OK: %s\n' "$1"; }
warn() { printf 'WARN: %s\n' "$1"; }
miss() { printf 'MISSING: %s\n' "$1"; missing=1; }

check_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    ok "$path"
  else
    miss "$path"
  fi
}

check_module_file() {
  local rel_path="$1"
  if [[ -f "${MODULE_DIR}/${rel_path}" ]]; then
    ok "${MODULE_LABEL}/${rel_path}"
  else
    miss "${MODULE_LABEL}/${rel_path}"
  fi
}

echo "== OpenCode module =="
ok "module: ${MODULE_DIR}"
ok "project: ${PROJECT_ROOT}"

echo

echo "== Caveman skills =="
check_module_file ".agents/skills/caveman/SKILL.md"
check_module_file ".agents/skills/caveman-help/SKILL.md"
check_module_file ".agents/skills/caveman-review/SKILL.md"
check_module_file ".agents/skills/caveman-commit/SKILL.md"
check_module_file ".agents/skills/caveman-compress/SKILL.md"
check_module_file ".agents/skills/caveman-stats/SKILL.md"
check_module_file ".agents/skills/cavecrew/SKILL.md"

echo
echo "== CodeGraph =="
check_module_file "skill/codegraph/SKILL.md"
check_module_file "skill/codegraph/manifest.yaml"
if command -v codegraph >/dev/null 2>&1; then
  ok "$(codegraph --version 2>&1 | tr '\n' ' ')"
  if [[ "$CONFIGURE_GLOBAL" -eq 1 ]]; then
    codegraph install --target=opencode --location=global
    ok "CodeGraph installed into global OpenCode config"
  else
    warn "Global OpenCode MCP wiring not changed; use --configure-global as an operator step if needed"
  fi
  if [[ "$INIT_CODEGRAPH" -eq 1 ]]; then
    (cd "$PROJECT_ROOT" && codegraph init -i)
    ok "Project CodeGraph index initialized/updated"
  elif [[ -d "${PROJECT_ROOT}/.codegraph" ]]; then
    ok ".codegraph index exists"
  else
    warn "No .codegraph index; run: ${MODULE_LABEL}/scripts/setup-opencode-tools.sh --init-codegraph"
  fi
else
  miss "codegraph CLI not found. Install with: npm i -g @colbymchenry/codegraph"
  warn "Then run: codegraph install --target=opencode --location=global"
  warn "Then run: scripts/setup-opencode-tools.sh --init-codegraph"
fi

echo
echo "== RTK =="
check_module_file "skill/rtk/SKILL.md"
check_module_file "skill/rtk/manifest.yaml"
if command -v rtk >/dev/null 2>&1; then
  ok "$(rtk --version 2>&1 | tr '\n' ' ')"
  if [[ "$CONFIGURE_GLOBAL" -eq 1 ]]; then
    rtk init -g --opencode
    ok "RTK wired into global OpenCode config"
  else
    warn "Global OpenCode RTK hook not changed; use --configure-global as an operator step if needed"
  fi
  if rtk init --show >/dev/null 2>&1; then
    ok "rtk init --show works"
  else
    warn "rtk init --show did not confirm integration"
  fi
else
  miss "rtk CLI not found. Install with Homebrew: brew install rtk"
  warn "Or Linux/macOS installer: curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh"
  warn "Then run: rtk init -g --opencode"
fi

echo
if [[ "$missing" -eq 0 ]]; then
  ok "OpenCode optional tool files and installed CLIs look ready"
else
  warn "Some optional tools need operator setup outside this repository"
fi

if [[ "$STRICT" -eq 1 && "$missing" -ne 0 ]]; then
  exit 1
fi
