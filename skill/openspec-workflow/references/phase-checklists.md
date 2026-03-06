# Phase Checklists

## Planning

- Active change selected explicitly.
- `proposal`, `specs`, `design`, and `tasks` are present or intentionally skipped with reason.
- API/security/data model impacts are documented.
- Tasks include concrete verification commands.

## Implementation

- Tasks executed in order.
- Tests added/updated before or with behavior changes.
- `tasks.md` updated to reflect progress.
- Baseline checks run (`go test ./...`, lambda build).

## Verification

- Task completion reviewed against implementation.
- Requirement/scenario coverage reviewed.
- `openspec validate "<name>" --strict` executed.
- Findings reported by severity with remediation.

## Archive

- No unresolved CRITICAL verification findings.
- Delta specs sync decision recorded.
- Change archived and result path reported.
