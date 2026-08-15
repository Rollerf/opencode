# go-aws-monorepo Pack

This pack supports repositories containing a Go AWS Lambda module under `lambda-handlers/` and TypeScript Pulumi infrastructure under `infra/`.

## Detection

Selection requires all of the following evidence:

- `lambda-handlers/go.mod` exists and references the AWS SDK for Go.
- `infra/Pulumi.yaml` exists.
- `infra/package.json` references `@pulumi/aws`.

## TDD Flow

1. RED: add or update a Go test and run `go -C lambda-handlers test ./...`, expecting the targeted test to fail.
2. GREEN: apply the smallest behavior change and rerun `go -C lambda-handlers test ./...`.
3. REFACTOR: clean up the implementation, then run the Go tests and `go -C lambda-handlers vet ./...`.

Infrastructure changes require an additional project-specific check. This repository does not currently install the TypeScript compiler, so the pack does not claim TypeScript compilation as an available baseline command.

## Baseline Checks

- `go -C lambda-handlers test ./...`
- `go -C lambda-handlers build ./...`
- `go -C lambda-handlers vet ./...`

## Security and Compliance

| Control | Command/Check | Expected Result |
|---|---|---|
| Secret scan | `gitleaks detect --source .` | No secrets detected |
| Dependency/license review | `go -C lambda-handlers list -m all` and `npm --prefix infra audit` | Dependencies reviewed and licenses allowed |
| Vulnerability scan | Run `govulncheck ./...` from `lambda-handlers/` | No unresolved High/Critical findings |
| Prohibited commands policy | Review `pack.yaml` | Deploy, infrastructure apply, and production release remain operator-owned |
