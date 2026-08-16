#!/usr/bin/env node

import { readFileSync } from "node:fs"
import { dirname, resolve } from "node:path"
import { fileURLToPath } from "node:url"

const SCRIPT_DIR = dirname(fileURLToPath(import.meta.url))
const DEFAULT_RATE_CARD = resolve(SCRIPT_DIR, "../../core/model-api-prices.json")

function fail(message) {
  process.stderr.write(`Error: ${message}\n`)
  process.exit(1)
}

function readJson(path, label) {
  try {
    return JSON.parse(readFileSync(path, "utf8"))
  } catch (error) {
    fail(`Cannot read ${label} '${path}': ${error.message}`)
  }
}

function isTokenCount(value) {
  return Number.isSafeInteger(value) && value >= 0
}

function rounded(value) {
  return Number(value.toFixed(12))
}

const usagePath = process.argv[2]
const rateCardPath = process.argv[3] ?? DEFAULT_RATE_CARD
if (!usagePath || process.argv.length > 4) {
  fail("Usage: calculate-api-cost.mjs <usage.json> [rate-card.json]")
}

const usage = readJson(resolve(usagePath), "usage file")
const rateCard = readJson(resolve(rateCardPath), "rate card")

if (!usage || typeof usage !== "object" || Array.isArray(usage) || !Array.isArray(usage.executions)) {
  fail("Usage file must be an object with an executions array")
}
if (
  !rateCard ||
  typeof rateCard !== "object" ||
  Array.isArray(rateCard) ||
  !Number.isSafeInteger(rateCard.schema_version) ||
  typeof rateCard.profile !== "string" ||
  rateCard.currency !== "USD" ||
  rateCard.unit !== 1_000_000 ||
  !rateCard.models ||
  typeof rateCard.models !== "object"
) {
  fail("Rate card has an invalid schema, profile, currency, unit, or models mapping")
}

let calculatedCount = 0
let totalCost = 0

const executions = usage.executions.map((execution, index) => {
  if (!execution || typeof execution !== "object" || Array.isArray(execution)) {
    fail(`Execution ${index} must be an object`)
  }

  const id = typeof execution.id === "string" && execution.id.length > 0 ? execution.id : `execution-${index + 1}`
  const model = execution.model
  const profile = execution.profile ?? usage.profile
  const base = { id, model, profile }
  const telemetryFields = ["input_tokens", "cached_input_tokens", "output_tokens"]
  const presentTelemetry = telemetryFields.filter((field) => Object.hasOwn(execution, field))

  if (presentTelemetry.length < telemetryFields.length) {
    return { ...base, status: "unknown", reason: "missing-token-telemetry" }
  }
  for (const field of telemetryFields) {
    if (!isTokenCount(execution[field])) {
      fail(`Execution '${id}' has malformed ${field}; expected a non-negative safe integer`)
    }
  }

  if (profile !== rateCard.profile) {
    return { ...base, status: "unknown", reason: "unsupported-pricing-profile" }
  }
  const rates = rateCard.models[model]
  if (!rates) {
    return { ...base, status: "unknown", reason: "unsupported-model" }
  }

  const uncachedInputTokens = Math.max(execution.input_tokens - execution.cached_input_tokens, 0)
  const cost = rounded(
    (
      uncachedInputTokens * rates.input_usd_per_million +
      execution.cached_input_tokens * rates.cached_input_usd_per_million +
      execution.output_tokens * rates.output_usd_per_million
    ) / rateCard.unit,
  )
  calculatedCount += 1
  totalCost += cost

  return {
    ...base,
    status: "calculated",
    rate_card_version: rateCard.schema_version,
    api_equivalent_cost_usd: cost,
  }
})

const total = calculatedCount > 0
  ? {
      status: "calculated",
      calculated_executions: calculatedCount,
      api_equivalent_cost_usd: rounded(totalCost),
    }
  : { status: "unknown", calculated_executions: 0 }

process.stdout.write(`${JSON.stringify({
  profile: rateCard.profile,
  currency: rateCard.currency,
  unit: rateCard.unit,
  rate_card_version: rateCard.schema_version,
  executions,
  total,
}, null, 2)}\n`)
