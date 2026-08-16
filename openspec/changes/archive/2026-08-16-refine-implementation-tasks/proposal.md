## Why

Hard-spec review currently resolves requirement ambiguity and asks for traceable tasks, but it does not provide a dedicated gate that proves each task can be executed without making product, architecture, compatibility, security, or test-strategy decisions during implementation. This leaves implementation quality dependent on the reasoning capability of the executing model and makes bounded work harder to delegate safely to lower-capability models such as Luna.

Decision-free implementation currently consumes the Sol orchestrator even when the designated lower-cost Luna executor can follow a sufficiently refined block. Sol output costs `$30.00` per million standard short-context API tokens while Luna output costs `$1.20`, so verbose Sol implementation work is especially expensive. This change makes the cheaper execution path the default while retaining Sol for work that requires stronger reasoning and final accountability.

## Goals

- Add a mandatory task-refinement sub-phase after spec hardening and before implementation.
- Define an objective executor-ready task contract that removes implementation-time decision making.
- Group refined tasks into cohesive execution blocks and execute each normal block through Luna with high reasoning effort by default while Sol retains orchestration, refinement, escalation, and final review.
- Reduce expected implementation cost by reserving Sol for decision-heavy workflow ownership and routing normal decision-free blocks to Luna/high.
- Define a subscription-independent API-equivalent cost metric that weights input, cached input, and especially output tokens using a versioned standard API price profile.
- Make missing decisions return to spec hardening instead of being guessed by the task refiner or implementer.
- Preserve one orchestrator entrypoint and exactly one primary phase contract per session.

## Non-goals

- Change the OpenSpec artifact schema or add a fifth planning artifact.
- Replace the Sol orchestrator, delegate final decisions to Luna, or add another phase-owning primary agent.
- Guarantee that every task can be completed by every model regardless of context-window, tool, or stack limitations.
- Benchmark or compare end-to-end Sol and Luna workloads; this change only defines API-equivalent accounting for observed executions, while comparative experimentation belongs to a separate project or OpenSpec change.
- Replace strict OpenSpec validation, TDD, implementation verification, or operator decisions.

## What Changes

- Introduce an `openspec-task-refinement` skill as a planning specialization used after hard-spec readiness is established.
- Introduce a leaf `subagent/refined-task-executor-subagent` configured with `model: openai/gpt-5.6-luna` and `variant: high`.
- Define a deterministic executor-ready rubric for `tasks.md`, including bounded scope, exact files or discovery boundaries, dependencies, requirement/scenario traceability, test-first steps, exact local commands, expected evidence, and completion conditions.
- Require the task refiner to group related tasks into bounded execution blocks with explicit internal order, shared context, block verification, and stop conditions.
- Require every refined block to name its executor; normal implementation blocks default to the Luna/high executor, while operator overrides and mandatory specialist routes remain explicit and auditable.
- Define a minimal structured handoff from Sol to Luna and a compact structured result from Luna to Sol so unrelated context and narrative summaries are not retransmitted for every block.
- Require the task-refinement step to stop and return findings to spec hardening when any task still requires a product, architecture, security, compatibility, data, infrastructure, or test-strategy decision.
- Require implementation entry checks to reject unrefined or decision-bearing tasks.
- Require the Sol orchestrator to delegate one ready block at a time, resume the same child session when a step checkpoint interrupts execution, verify returned evidence, and send failures back through refinement instead of silently taking implementation ownership.
- Enforce cost-efficient model allocation as a routing invariant: normal ready blocks use Luna/high, and any Sol implementation or specialist override is explicit and auditable.
- Add a versioned standard short-context API rate card for Sol, Terra, and Luna plus a deterministic `api_equivalent_cost_usd` formula that does not depend on Plus, Pro, Business, or Enterprise subscription allowances.
- Minimize expensive Sol output by requiring compact orchestration, delta-only continuation, direct diff inspection, and no prose duplication of Luna results.
- Expand task templates, routing guidance, lifecycle documentation, runtime validation, and evaluation coverage for the new sub-phase.

## Capabilities

### New Capabilities

- `implementation-task-refinement`: Defines the post-hard-spec task-refinement workflow and the executor-ready task contract.

### Modified Capabilities

- `core-workflow-contracts`: Adds mandatory task refinement between spec hardening and implementation while preserving the existing primary phase model.
- `agent-catalog-routing`: Routes task-refinement intent through planning and enforces cost-efficient Luna/high delegation for eligible normal implementation blocks.
- `runtime-definition-integrity`: Requires the new repository-owned refinement skill and its bundle context to remain discoverable and valid in source and consumer layouts.

## Scope Boundaries

The change affects local workflow contracts, agents, skills, task templates, routing, runner/bundle behavior where needed, validators, evaluations, and documentation. It does not perform implementation work from a refined task list and does not automate non-local lifecycle actions.

## Open Decisions

No critical product decision remains. The design must preserve the existing five runner phases by modeling task refinement as a planning sub-phase and specialization rather than introducing a new top-level phase. Luna/high is the default refined-block executor; Sol implementation requires an explicit operator override or an already-defined mandatory specialist route. A block contains two to five cohesive tasks by default; bootstrap, final integration, or indivisible work may use an explicitly justified single-task block.

## Impact

- New skill: `skill/openspec-task-refinement/`.
- New bounded implementation agent: `agents/subagent/refined-task-executor-subagent.md` plus catalog and model-policy registration.
- Updated contracts and routing: `agents/orchestrator.md`, `skill/openspec-*`, `core/`, and `openspec/config.yaml`.
- Updated task authoring surface: `core/templates/tasks.md` and planning guidance.
- New normalized API rate card and calculator: `core/model-api-prices.json` and `scripts/evals/calculate-api-cost.mjs`.
- Updated validation and evaluation coverage under `scripts/validate/` and `evals/`.
- Updated operator documentation in `README.md`.
- No external API, production infrastructure, credential, deployment, or data-model impact.
