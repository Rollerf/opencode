---
name: openspec-implementation
description: Use when executing tasks from an implementation-ready OpenSpec change with TDD and stack-pack verification.
---

# OpenSpec Implementation Contract

Apply this phase contract after the stack pack has been resolved.

## Entry criteria

- One active change has complete proposal, design, specs, and tasks.
- Strict validation passes and no CRITICAL ambiguity remains.
- `tasks.md` has a valid `READY` Task Refinement Gate and every incomplete task belongs to one complete executor-ready block.
- The branch belongs to the active change and starts from `develop`.

## Workflow

1. Read all change artifacts before editing implementation files.
2. Recheck readiness at entry. If planning artifacts change after refinement, reset the gate to `BLOCKED` and return to task refinement before editing.
3. Reject unrefined, decision-bearing, overly broad, or externally blocked tasks and blocks.
4. Report the effective executor, model, variant, and override rationale before edits. Delegate each eligible normal block to `subagent/refined-task-executor-subagent` using Luna/high by default.
5. Send one complete executor-ready block with only its compact handoff, relevant artifact excerpts, focused source context, and resolved pack constraints.
6. Execute block tasks in dependency order using small, reversible changes. For behavior changes, follow RED -> GREEN -> REFACTOR and record command evidence.
7. On `PARTIAL` without a hard blocker, resume the same child session using its task/session identifier and send only the instruction or evidence delta.
8. Stop on every newly discovered decision gap and return to spec hardening followed by task refinement. Do not guess or silently implement with Sol.
9. For non-decision execution failures, refine the block instructions and resume or re-delegate to Luna/high without weakening verification.
10. Direct Sol implementation requires an explicit operator override. Mandatory specialist routes remain valid when their existing contract applies; report either override rationale before edits.
11. Use the resolved pack's architecture constraints and verification commands.
12. Keep implementation, tests, docs, and tasks consistent.
13. Inspect returned files and diffs directly; do not ask the executor to reproduce them in prose.
14. Mark tasks complete only after returned evidence and parent review pass.
15. Do not execute non-local deployment, release, production, or credential actions.

## Completion criteria

- Every completed task has corresponding implementation and evidence.
- RED, GREEN, and REFACTOR evidence exists for behavior changes.
- Affected and pack-defined checks pass.
- The response reports touched files, commands, compatibility notes, blockers, and remaining tasks.
