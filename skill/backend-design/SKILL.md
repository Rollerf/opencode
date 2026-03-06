---
name: backend-design
description: Architecture and coding guardrails for this backend (Go Lambda handlers + Pulumi infra).
---

# Backend Design Guardrails

Apply these constraints when editing backend code.

## Architecture

1. Keep `Handler -> UseCase -> Storage` boundaries.
2. Handlers map HTTP input/output only; business logic belongs in usecases.
3. Keep shared logic in `lambda-handlers/internal/` packages.

## API Semantics

1. Preserve error shape as RFC 7807 (`application/problem+json`).
2. Keep API contract aligned with `apis/apiManagment.yml`.
3. Highlight auth/security implications for endpoint changes.

## Data and Infra

1. Use migrations in `migrations/` for schema changes.
2. Keep Pulumi changes explicit under `infra/`.
3. Avoid hard-coded secrets or environment-specific values.

## Quality Gates

1. Run `cd lambda-handlers && go test ./...`.
2. Run `cd lambda-handlers && ./build-lambdas.sh`.
3. If infra changes are included, run `cd infra && npm run build-and-zip:lambda`.
