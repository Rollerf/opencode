# Phase Checklists

## Planning

- Active change selected explicitly.
- `proposal`, `specs`, `design`, and `tasks` are present or intentionally skipped with reason.
- All OpenSpec artifact prose is in English.
- Hard-spec readiness is defined: no unresolved CRITICAL ambiguity, deterministic requirements/scenarios, traceable tasks, and explicit verification evidence.
- API/security/data model impacts are documented.
- Draft tasks include concrete verification commands.
- Spec hardening owns decision closure; post-hard-spec Task refinement owns executor-ready decomposition.
- Every incomplete task has fixed traceability, dependency, executor, target, TDD or non-behavior, command, evidence, and completion fields.
- Normal execution blocks contain two to five cohesive tasks; single-task exceptions are justified.
- Task Refinement Gate is `READY` with no decision gaps before implementation.

## Implementation

- Task Refinement Gate confirmed `READY` and invalidated when planning artifacts changed.
- Executor-ready blocks and tasks executed in dependency order.
- Hard-spec readiness confirmed before code edits.
- Tests follow RED -> GREEN -> REFACTOR for behavior changes; non-behavior tasks state why TDD is not applicable.
- Executors stop on unplanned decisions, undeclared targets, security conflicts, or non-local actions.
- `tasks.md` updated to reflect progress.
- Exact block checks and stack-pack validation commands run.

## Verification

- Task completion reviewed against implementation.
- Hard-spec criteria reviewed for unresolved ambiguity or weak acceptance criteria.
- Requirement/scenario coverage reviewed.
- `openspec validate "<name>" --strict` executed.
- Findings reported by severity with remediation.

## Archive

- No unresolved CRITICAL verification findings.
- Delta specs sync decision recorded.
- Change archived and result path reported.
