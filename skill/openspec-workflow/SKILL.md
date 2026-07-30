---
name: openspec-workflow
description: Use for end-to-end OpenSpec changes, including proposal, design, specs, tasks, implementation, readiness validation, spec synchronization, and archive.
---

# OpenSpec Workflow

Use this skill as the operational playbook for changes under `openspec/changes/`.

## Select the Active Change

1. Prefer an explicit change name from the user.
2. If missing, list available changes and pick one before editing artifacts.
3. Confirm the selected change in output to avoid cross-change edits.

Use command templates from [commands.md](references/commands.md).

## Choose the Phase

1. Planning phase: create or refine proposal/design/specs/tasks.
2. Implementation phase: execute tasks in code with TDD.
3. Verification phase: check completeness, correctness, and strict validation.
4. Archive phase: archive only when verification is clean.

Use completion criteria from [phase-checklists.md](references/phase-checklists.md).

## Planning Rules

1. Check status before writing artifacts.
2. Build artifacts in sequence if missing: proposal -> specs -> design -> tasks.
3. Keep artifacts consistent with `openspec/config.yaml`.
4. Write all OpenSpec artifacts in English (`proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md`), regardless of the user's conversation language.
5. Define hard specs before implementation: resolve CRITICAL ambiguity, make requirements/scenarios deterministic, and map tasks to verification evidence.
6. Keep requirements testable and tasks concrete.

## Implementation Rules

1. Read active change artifacts before coding.
2. Confirm hard-spec readiness before coding; if CRITICAL ambiguity remains, return to planning/spec hardening.
3. Execute tasks in order and keep changes small.
4. Follow RED -> GREEN -> REFACTOR for behavior changes.
5. Mark completed tasks in `tasks.md`.
6. Run affected tests during execution, not only at the end.

## Verification and Archive Rules

1. Verify task completion and requirement/scenario coverage.
2. Run strict validation (`openspec validate "<change>" --strict`).
3. Report CRITICAL/WARNING/SUGGESTION findings with file references.
4. Archive only when CRITICAL issues are resolved.
