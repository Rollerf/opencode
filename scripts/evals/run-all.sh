#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
THRESHOLDS_FILE="${ROOT_DIR}/evals/config/global-thresholds.json"
METRICS_FILE="${1:-${ROOT_DIR}/evals/sample-metrics.json}"
GOLDEN_TASKS_DIR="${ROOT_DIR}/evals/golden-tasks"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

require_cmd python3

[[ -f "$THRESHOLDS_FILE" ]] || fail "Missing thresholds file: $THRESHOLDS_FILE"
[[ -f "$METRICS_FILE" ]] || fail "Missing metrics file: $METRICS_FILE"
[[ -d "$GOLDEN_TASKS_DIR" ]] || fail "Missing golden tasks directory: $GOLDEN_TASKS_DIR"

if ! compgen -G "${GOLDEN_TASKS_DIR}/**/*.yaml" >/dev/null; then
  # Fallback for shells without globstar.
  task_count="$(find "$GOLDEN_TASKS_DIR" -type f -name '*.yaml' | wc -l | tr -d ' ')"
  [[ "$task_count" -gt 0 ]] || fail "No golden task definitions found"
fi

python3 - "$THRESHOLDS_FILE" "$METRICS_FILE" <<'PY'
import json
import sys

thresholds_path = sys.argv[1]
metrics_path = sys.argv[2]

with open(thresholds_path, "r", encoding="utf-8") as f:
    thresholds = json.load(f)

with open(metrics_path, "r", encoding="utf-8") as f:
    metrics = json.load(f)

checks = [
    ("first_pass_correctness", ">=", thresholds["first_pass_correctness_min"]),
    ("regressions", "<=", thresholds["regressions_max"]),
    ("tdd_red_first_rate", ">=", thresholds["tdd_red_first_rate_min"]),
    ("tdd_green_pass_rate", ">=", thresholds["tdd_green_pass_rate_min"]),
    ("tdd_refactor_safety_rate", ">=", thresholds["tdd_refactor_safety_rate_min"]),
    ("critical_scenario_coverage", ">=", thresholds["critical_scenario_coverage_min"]),
    ("total_scenario_coverage", ">=", thresholds["total_scenario_coverage_min"]),
    ("strict_validation_pass_rate", ">=", thresholds["strict_validation_pass_rate_min"]),
    ("high_critical_security_findings", "<=", thresholds["high_critical_security_findings_max"]),
]

failed = []

for metric_name, op, threshold in checks:
    if metric_name not in metrics:
        failed.append((metric_name, op, threshold, "missing"))
        continue
    value = metrics[metric_name]
    ok = value >= threshold if op == ">=" else value <= threshold
    status = "PASS" if ok else "FAIL"
    print(f"{status}: {metric_name} {op} {threshold} (actual={value})")
    if not ok:
        failed.append((metric_name, op, threshold, value))

if failed:
    print("\nPromotion gate: BLOCKED")
    sys.exit(1)

print("\nPromotion gate: PASS")
PY
