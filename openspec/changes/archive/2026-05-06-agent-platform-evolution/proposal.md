## Why

This repository is becoming the shared automation layer across projects with different stacks (Go on AWS, Java on-premise, Angular, and others). A structured evolution is needed now so agents and skills behave consistently, remain safe, and deliver measurable productivity gains in daily development.

## What Changes

- Define a platform-level operating contract for OpenCode/OpenSpec phases, evidence, and completion criteria.
- Enforce mandatory TDD (RED -> GREEN -> REFACTOR) for behavior changes across all technologies.
- Introduce stack capability packs so each stack can add specific rules without fragmenting the core workflow.
- Standardize an agent catalog and routing matrix based on work type (planning, implementation, verification, archive, docs, refactor, infra, tests).
- Add an evaluation harness with golden tasks, metrics, and regression gates for prompt/skill quality.
- Establish governance for local-development-only operation, security boundaries, and explicit handoff to external operators for non-local lifecycle stages.

## Capabilities

### New Capabilities
- `core-workflow-contracts`: Enforce a common OpenSpec artifact lifecycle, mandatory TDD flow, and output contract across all agents.
- `stack-capability-packs`: Define reusable stack packs (Go/AWS, Java/on-prem, Angular, generic) that extend core behavior.
- `agent-catalog-routing`: Define a canonical agent taxonomy and deterministic routing policy by request type and phase.
- `quality-evaluation-harness`: Add repeatable evaluation scenarios, scoring, and release gates for agent and skill updates.
- `governance-safety-controls`: Define operational guardrails for local-only autonomy, security, auditability, and handoff boundaries.

### Modified Capabilities
- None.

## Impact

- Affects repository structure under `.opencode/agents`, `.opencode/skill`, and `openspec/changes` workflows.
- Introduces a new baseline for acceptance criteria in planning, implementation, and verification phases.
- Makes TDD evidence a mandatory acceptance criterion independent of stack.
- Adds evaluation and governance processes focused on local development workflows and clean operator handoff points.
- Improves reuse of agents/skills across heterogeneous projects while reducing per-project prompt drift.
