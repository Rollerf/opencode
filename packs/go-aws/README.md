# go-aws Pack

This pack is for local development in Go projects that target AWS.

## TDD Flow

1. RED: add or update a test and run `go test ./...` expecting failure.
2. GREEN: apply minimal code changes and run `go test ./...` expecting pass.
3. REFACTOR: cleanup and rerun `go test ./...` and `go vet ./...`.

## Baseline Checks

- `go test ./...`
- `go build ./...`
- `go vet ./...`
