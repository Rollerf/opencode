---
name: openspec-task-refinement
description: Use after hard-spec readiness to rewrite draft tasks into decision-free executor-ready implementation blocks.
---

# OpenSpec Task-Refinement Specialization

Apply this planning specialization after the stack pack has been resolved and hard-spec readiness has been established. It supplements `openspec-planning`; it is not a phase contract.

## Entry criteria

- One active change has complete `proposal.md`, `design.md`, `specs/**/spec.md`, and draft `tasks.md` artifacts.
- Strict OpenSpec validation passes.
- Spec hardening found no unresolved CRITICAL product, architecture, compatibility, security, data, infrastructure, operational, file-location, or test-strategy decision.

## Workflow

1. Read all change artifacts and inspect only the repository context needed to identify exact targets, symbols, dependencies, and local commands.
2. Treat existing tasks as drafts. Rewrite `tasks.md`; do not create another planning artifact or top-level phase.
3. Evaluate every incomplete implementation task against the task checklist below.
4. Group ready tasks into ordered execution blocks using the block checklist below.
5. Put context shared by multiple tasks once at block level.
6. Define one minimal structured handoff and result envelope for each block.
7. Run strict OpenSpec validation and the repository task-refinement validator.
8. Set the Task Refinement Gate to `READY` only when every task and block passes and decision gaps are `None`.

## Executor-ready task checklist

Each incomplete task must define:

- Stable task ID and one bounded, verifiable outcome.
- Requirement and scenario references.
- Explicit dependencies by task ID.
- Execution-block ID and exact executor runtime, model, and variant.
- Exact target file paths and symbols, including exact paths for new files.
- Ordered implementation steps without optional branches or unresolved alternatives.
- Exact RED, GREEN, and REFACTOR steps for behavior changes.
- `TDD: Not applicable — <reason>` for documentation, metadata, or other non-behavior work.
- Exact local commands, expected results, required evidence, and objective completion conditions.

Reject tasks containing unresolved placeholders or choices such as `TBD`, `choose`, `as appropriate`, `if needed`, or `either/or`.

## Executor-ready block checklist

Each block must define:

- Block ID and ordered task IDs.
- Executor runtime, model, and variant.
- Shared requirement and scenario references.
- Satisfied external dependencies.
- Allowed targets and forbidden scope.
- Exact commands, stop conditions, and block completion criteria.

A normal block contains two to five cohesive tasks sharing requirement context, target area, stack constraints, and verification commands. Bootstrap, final-integration, or indivisible work may use a single-task block only when `tasks.md` records the exact reason. Split broad blocks across independent target areas, specialist routes, or rollback boundaries.

## Decision-gap handling

The refiner may identify decisions but must not make them. When any task requires an unresolved product or technical choice:

1. Set the Task Refinement Gate to `BLOCKED`.
2. Record the decision category and affected requirements or scenarios.
3. Return the change to spec hardening for operator resolution.
4. Rerun task refinement after affected planning artifacts change.

Any implementation-affecting change to proposal, design, specs, or task scope invalidates a prior `READY` result.

## Compact block communication

The handoff contains only `change`, `block_id`, ordered `task_ids`, bounded `goal`, referenced requirements and scenarios, `dependencies_satisfied`, allowed and forbidden `targets`, ordered `steps`, exact `commands`, `stop_conditions`, applicable `pack_constraints`, and `expected_evidence`.

The result contains only `status` (`COMPLETED`, `PARTIAL`, or `BLOCKED`), `block_id`, completed and remaining task IDs, touched files, RED/GREEN/REFACTOR and block-check evidence, decision gaps, verification failures, and scope deviations.

## Completion criteria

- `tasks.md` contains a Task Refinement Gate with `Status: READY`, the strict validation command, and `Decision gaps: None`; otherwise status is `BLOCKED`.
- Every incomplete task and execution block satisfies its fixed checklist.
- Normal blocks contain two to five cohesive tasks; every single-task exception is justified.
- No implementation-time decision or silent executor fallback remains.
- Strict OpenSpec and focused task-refinement validation pass.
- The response reports phase, effective executor, touched files, commands, blockers, and missing decisions.
