---
name: openspec-archive
description: Use when closing and archiving a fully verified OpenSpec change and synchronizing its delta specs.
---

# OpenSpec Archive Contract

Apply this phase contract after the stack pack has been resolved.

## Entry criteria

- The change is complete and strictly valid.
- All tasks are checked and verification has no unresolved CRITICAL findings.
- Non-local follow-ups are captured for an operator.

## Workflow

1. Confirm artifacts, tasks, verification evidence, and spec synchronization impact.
2. Run strict validation before mutation.
3. Prefer the runner path resolved by `$openspec-workflow` when it covers the archive operation; otherwise use `openspec archive` explicitly and report why the runner was unavailable or insufficient.
4. Synchronize delta specs and preserve traceability.
5. Never archive an incomplete or critically ambiguous change.

## Completion criteria

- The change is moved under `openspec/changes/archive/`.
- Main specs contain the intended synchronized requirements.
- Validation remains clean after archive.
- The response reports archive path, spec sync, commands, touched files, blockers, and follow-ups.
