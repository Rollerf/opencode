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
6. Create Draft tasks with concrete outcomes, traceability, dependencies, and local verification evidence; draft planning does not by itself make tasks executor-ready.
7. After spec-hardening decision closure, apply `openspec-task-refinement` in the planning phase to rewrite draft tasks into ordered executor-ready blocks.
8. Prefer the runner resolved by `$openspec-workflow` for supported planning operations; do not require it to exist at `./opencode-runner.sh`.

## Completion criteria

- Proposal, design, specs, and tasks are present or intentionally omitted with a documented reason.
- No unresolved CRITICAL ambiguity remains.
- Requirements, scenarios, Draft tasks, and verification evidence are traceable.
- When task refinement is in scope, every incomplete task belongs to a valid block and the Task Refinement Gate is `READY`; otherwise blockers return to spec hardening.
- The response reports phase, touched files, commands, blockers, and missing decisions.
