#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
PACKS_DIR="${ROOT_DIR}/packs"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

require_cmd python3

python3 - "$PACKS_DIR" <<'PY'
import sys
from pathlib import Path

packs_dir = Path(sys.argv[1])
if not packs_dir.exists():
    print(f"Error: missing packs directory: {packs_dir}", file=sys.stderr)
    sys.exit(1)

required_packs = ["go-aws", "java-onprem", "angular", "generic"]
required_keys = ["red", "green", "refactor"]

errors = []

for pack in required_packs:
    path = packs_dir / pack / "pack.yaml"
    if not path.exists():
        errors.append(f"missing pack file: {path}")
        continue

    data = path.read_text(encoding="utf-8")
    if "local_only: true" not in data:
        errors.append(f"{path}: local_only must be true")
    if "tdd_commands:" not in data:
        errors.append(f"{path}: missing tdd_commands section")
    for key in required_keys:
        if f"  {key}:" not in data:
            errors.append(f"{path}: missing tdd command key '{key}'")

if errors:
    print("TDD contract validation failed:", file=sys.stderr)
    for err in errors:
        print(f"- {err}", file=sys.stderr)
    sys.exit(1)

print("TDD contract validation passed")
PY
