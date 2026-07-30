---
name: openspec-implementation
description: Use when executing tasks from an implementation-ready OpenSpec change with TDD and stack-pack verification.
---

# OpenSpec Implementation Contract

Apply this phase contract after the stack pack has been resolved.

## Entry criteria

- One active change has complete proposal, design, specs, and tasks.
- Strict validation passes and no CRITICAL ambiguity remains.
- The branch belongs to the active change and starts from `develop`.

## Workflow

1. Read all change artifacts before editing implementation files.
2. Execute tasks in dependency order using small, reversible changes.
3. For behavior changes, follow RED -> GREEN -> REFACTOR and record command evidence.
4. Use the resolved pack's architecture constraints and verification commands.
5. Keep implementation, tests, docs, and tasks consistent.
6. For feature iteration, analyze current behavior, implement bounded improvements directly in the orchestrator, update valid tests when behavior changes, and never weaken tests without explicit approval.
7. Delegate only bounded specialist work with a distinct deliverable.
8. Mark tasks complete only after their verification evidence passes.
9. Do not execute non-local deployment, release, production, or credential actions.

## Completion criteria

- Every completed task has corresponding implementation and evidence.
- RED, GREEN, and REFACTOR evidence exists for behavior changes.
- Affected and pack-defined checks pass.
- The response reports touched files, commands, compatibility notes, blockers, and remaining tasks.
