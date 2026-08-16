#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

RATE_CARD="${ROOT_DIR}/core/model-api-prices.json"
CALCULATOR="${ROOT_DIR}/scripts/evals/calculate-api-cost.mjs"

[[ -f "$RATE_CARD" ]] || { echo "Error: Missing rate card: $RATE_CARD" >&2; exit 1; }
[[ -f "$CALCULATOR" ]] || { echo "Error: Missing calculator: $CALCULATOR" >&2; exit 1; }

cat >"$TMP_DIR/usage.json" <<'JSON'
{
  "profile": "standard-short-context",
  "executions": [
    {"id":"sol-fixture","model":"openai/gpt-5.6-sol","input_tokens":1000000,"cached_input_tokens":200000,"output_tokens":100000},
    {"id":"terra-fixture","model":"openai/gpt-5.6-terra","input_tokens":1000000,"cached_input_tokens":200000,"output_tokens":100000},
    {"id":"luna-fixture","model":"openai/gpt-5.6-luna","input_tokens":1000000,"cached_input_tokens":200000,"output_tokens":100000},
    {"id":"unsupported-profile","model":"openai/gpt-5.6-luna","profile":"long-context","input_tokens":10,"cached_input_tokens":0,"output_tokens":10},
    {"id":"missing-telemetry","model":"openai/gpt-5.6-luna","input_tokens":10}
  ]
}
JSON

node "$CALCULATOR" "$TMP_DIR/usage.json" >"$TMP_DIR/result.json"
node - "$TMP_DIR/result.json" <<'NODE'
const result = JSON.parse(require("node:fs").readFileSync(process.argv[2], "utf8"))
const byId = Object.fromEntries(result.executions.map((entry) => [entry.id, entry]))
const expected = { "sol-fixture": 7.1, "terra-fixture": 2.84, "luna-fixture": 0.284 }
for (const [id, cost] of Object.entries(expected)) {
  if (byId[id]?.status !== "calculated" || Math.abs(byId[id].api_equivalent_cost_usd - cost) > 1e-12) {
    throw new Error(`${id} expected ${cost}, got ${JSON.stringify(byId[id])}`)
  }
}
for (const id of ["unsupported-profile", "missing-telemetry"]) {
  if (byId[id]?.status !== "unknown" || "api_equivalent_cost_usd" in byId[id]) {
    throw new Error(`${id} must report unknown without invented cost`)
  }
}
if (Math.abs(result.total.api_equivalent_cost_usd - 10.224) > 1e-12) {
  throw new Error(`total expected 10.224, got ${JSON.stringify(result.total)}`)
}
NODE

cat >"$TMP_DIR/invalid.json" <<'JSON'
{"profile":"standard-short-context","executions":[{"id":"negative","model":"openai/gpt-5.6-luna","input_tokens":-1,"cached_input_tokens":0,"output_tokens":0}]}
JSON
if node "$CALCULATOR" "$TMP_DIR/invalid.json" >/dev/null 2>&1; then
  echo "Error: Negative token counts must fail" >&2
  exit 1
fi

echo "Model cost contract passed (formula fixtures: Sol 7.10, Terra 2.84, Luna 0.284; not a workload comparison)"
