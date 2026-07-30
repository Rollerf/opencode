---
name: openspec-planning
description: Use when creating or refining OpenSpec proposal, design, delta specs, or tasks before implementation begins.
---

# OpenSpec Planning Contract

Apply this phase contract after the stack pack has been resolved.

## Entry criteria

- One active change is identified.
- The request concerns `proposal.md`, `design.md`, `specs/**/spec.md`, or `tasks.md`.
- Existing artifacts are read before edits.

## Workflow

1. Build missing artifacts in order: proposal -> specs -> design -> tasks.
2. Write all OpenSpec artifact prose in English.
3. Keep requirements observable and scenarios deterministic.
4. Resolve CRITICAL ambiguity before implementation.
5. Include API, security, data, infrastructure, and stack-pack impact when applicable.
6. Add concrete, ordered tasks with exact local verification evidence.
7. Prefer `./opencode-runner.sh` for supported planning operations.

## Completion criteria

- Proposal, design, specs, and tasks are present or intentionally omitted with a documented reason.
- No unresolved CRITICAL ambiguity remains.
- Requirements, scenarios, tasks, and verification evidence are traceable.
- The response reports phase, touched files, commands, blockers, and missing decisions.
