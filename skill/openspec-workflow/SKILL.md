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

## Resolve the Runner

Before phase operations, resolve the first executable runner from the consumer project root in this order:

1. `./opencode-runner.sh`
2. `./.opencode/opencode-runner.sh`
3. `$HOME/.config/opencode/opencode-runner.sh`

Invoke the resolved path while the working directory remains the consumer project root. Do not treat a missing `./opencode-runner.sh` as sufficient reason to bypass the runner. Use direct `openspec` commands only when no candidate exists or the resolved runner does not cover the operation, and report that reason explicitly.

## Choose the Phase

1. Planning phase: create or refine proposal/design/specs/tasks.
2. Implementation phase: execute tasks in code with TDD.
3. Verification phase: check completeness, correctness, and strict validation.
4. Archive phase: archive only when verification is clean.

Use completion criteria from [phase-checklists.md](references/phase-checklists.md).

## Planning Rules

Lifecycle order: `draft planning -> spec hardening -> task refinement -> block implementation`.

1. Check status before writing artifacts.
2. Build artifacts in sequence if missing: proposal -> specs -> design -> tasks.
3. Keep artifacts consistent with `openspec/config.yaml`.
4. Write all OpenSpec artifacts in English (`proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md`), regardless of the user's conversation language.
5. Define hard specs before implementation: resolve CRITICAL ambiguity, make requirements/scenarios deterministic, and map tasks to verification evidence.
6. Keep requirements testable and draft tasks concrete.
7. After hard-spec decision closure, apply `openspec-task-refinement` under planning and rewrite `tasks.md` into fixed executor-ready tasks and ordered blocks.
8. Normal blocks contain two to five cohesive tasks. Justify bootstrap, final-integration, or indivisible single-task blocks.
9. Set the Task Refinement Gate to `BLOCKED` and return to spec hardening when any implementation decision remains; set it to `READY` only after every task and block passes.
10. Use compact structured block handoff and result envelopes; do not duplicate unrelated artifact or repository context.

## Implementation Rules

1. Read active change artifacts before coding.
2. Confirm hard-spec readiness and a `READY` Task Refinement Gate before coding; if either fails, return to spec hardening followed by task refinement.
3. Reject any block that lacks fixed task fields, exact targets, deterministic order, exact commands, stop conditions, or decision-free completion criteria.
4. Execute ready blocks and their tasks in dependency order and keep changes small.
5. Follow RED -> GREEN -> REFACTOR for behavior changes; require `TDD: Not applicable — <reason>` for non-behavior tasks.
6. Stop instead of guessing when implementation reveals an unplanned product or technical choice.
7. Mark completed tasks in `tasks.md` only after evidence passes.
8. Run affected tests during execution, not only at the end.

## Verification and Archive Rules

1. Verify task completion and requirement/scenario coverage.
2. Run strict validation (`openspec validate "<change>" --strict`).
3. Report CRITICAL/WARNING/SUGGESTION findings with file references.
4. Archive only when CRITICAL issues are resolved.
