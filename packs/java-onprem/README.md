# java-onprem Pack

This pack is for local development in Java projects deployed on-premise.

## Architecture

- Supported backend architecture styles: `layered` and `onion`.
- Resolve the active style from the project OpenSpec artifacts (`design.md`, `specs`, `tasks.md`) for the current change.
- Treat OpenSpec as the source of truth for project-specific context.

## TDD Flow

1. RED: add failing tests and run `./mvnw -Dtest=*Test test`.
2. GREEN: implement minimal code and rerun `./mvnw -Dtest=*Test test`.
3. REFACTOR: refactor and run `./mvnw test`.

## Baseline Checks

- `./mvnw test`
- `./mvnw -DskipTests package`
- `./mvnw -q checkstyle:check`
