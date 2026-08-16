## MODIFIED Requirements

### Requirement: Deterministic routing policy
The orchestrator SHALL resolve exactly one stack pack before executing phase work. After pack resolution, routing SHALL select exactly one workflow phase first, apply the resolved stack second, add zero or more specialization skills third, and use bounded subagent delegation last. A specialized helper SHALL supplement rather than replace the selected phase contract. Task-refinement intent SHALL select the planning phase and apply `openspec-task-refinement` only after hard-spec readiness. Implementation of a normal executor-ready task block SHALL select the implementation phase and delegate the complete block to `subagent/refined-task-executor-subagent` with Luna/high as the cost-efficient default; direct Sol implementation requires an explicit operator override.

#### Scenario: Pack is unresolved before work starts
- **WHEN** the orchestrator cannot identify exactly one valid pack from explicit selection, confirmed project configuration, or project evidence
- **THEN** it performs only read-only discovery
- **AND** does not begin planning, implementation, verification, or archive work until the operator resolves the pack decision

#### Scenario: Task refinement is requested
- **WHEN** a user asks to refine, decompose, or make `tasks.md` executable without implementation-time decisions
- **THEN** routing selects the planning phase contract
- **AND** applies `openspec-task-refinement` after confirming hard-spec readiness

#### Scenario: Implementation is requested with unrefined tasks
- **WHEN** a user asks to implement a change whose task-refinement gate is absent or `BLOCKED`
- **THEN** routing blocks implementation
- **AND** selects planning plus task refinement as the required next step

#### Scenario: Implementation is requested with a refined normal block
- **WHEN** a user asks to implement a normal task block whose refinement gate is `READY`
- **THEN** routing selects the implementation phase contract under the Sol orchestrator
- **AND** delegates the complete block to `subagent/refined-task-executor-subagent` using Luna/high
- **AND** does not spend Sol implementation capacity on the eligible decision-free block

#### Scenario: Composite implementation and documentation request
- **WHEN** a request implements an executor-ready OpenSpec task and also updates documentation
- **THEN** routing selects the implementation phase contract
- **AND** documentation specialization is applied as an overlay or bounded helper only when it provides a distinct deliverable

#### Scenario: Ambiguous design request
- **WHEN** a request could mean OpenSpec design planning or a standalone design document
- **THEN** routing uses explicit artifact and change context to select the phase
- **AND** asks for clarification when that context cannot produce a deterministic choice

#### Scenario: Pulumi verification request
- **WHEN** a request verifies an existing Pulumi change
- **THEN** routing selects the verification phase before applying Pulumi specialization
- **AND** does not replace verification with an implementation-scoped helper

### Requirement: Single-entrypoint orchestration
The platform SHALL use `orchestrator.md` as the only phase-owning interactive agent and SHALL load the selected planning, spec-hardening, implementation, verification, or archive contract as a native skill in the same session. Task refinement SHALL execute through the orchestrator as a planning specialization and SHALL NOT require the operator to switch agents or phases manually.

#### Scenario: Orchestrator executes selected phase locally
- **WHEN** a user asks the orchestrator to perform work that maps to a known phase
- **THEN** the orchestrator loads exactly one matching phase-contract skill, executes permitted local actions, and reports phase, touched files, commands, blockers, and missing decisions

#### Scenario: Orchestrator refines tasks locally
- **WHEN** hard-spec readiness is established and task refinement is the next lifecycle step
- **THEN** the orchestrator keeps the planning phase contract active
- **AND** applies the task-refinement specialization directly in the same session

#### Scenario: Orchestrator delegates refined implementation
- **WHEN** one normal executor-ready block is next in dependency order
- **THEN** the orchestrator delegates that complete block to the Luna/high refined-task executor
- **AND** keeps final decisions, diff review, evidence review, and checkbox completion in the parent session

#### Scenario: Removed phase-agent name is requested
- **WHEN** a consumer uses a documented phase operation after migration
- **THEN** the runner selects the orchestrator plus the matching phase skill
- **AND** does not require a separate primary phase agent

#### Scenario: Subagents are used only when beneficial
- **WHEN** the orchestrator can complete the task with the selected phase and specialization skills
- **THEN** it does not delegate unless specialization, safe parallelism, context reduction, or a distinct deliverable provides a stated benefit

## ADDED Requirements

### Requirement: Refined-task executor ownership
The platform SHALL catalog `subagent/refined-task-executor-subagent` as a hidden leaf implementation subagent that owns tests and production edits only within one supplied executor-ready task block. It SHALL own the complete block across same-session continuations and SHALL NOT own planning, spec decisions, cross-block integration, final verification, or further delegation.

#### Scenario: Refined-task executor receives bounded ownership
- **WHEN** the Sol orchestrator delegates a normal executor-ready block
- **THEN** the Luna/high executor may modify only the block's declared targets
- **AND** returns `COMPLETED`, `PARTIAL`, or `BLOCKED` with structured progress and evidence
- **AND** cannot invoke another subagent

#### Scenario: Partial block resumes
- **WHEN** the executor returns `PARTIAL` because its step checkpoint is reached without a hard blocker
- **THEN** the orchestrator resumes the same child session
- **AND** sends only instruction or evidence deltas
- **AND** does not split remaining block tasks into a new delegation

#### Scenario: Mandatory specialist route owns the block
- **WHEN** an executor-ready block is explicitly routed to an existing mandatory specialist or the operator selects another executor
- **THEN** that explicit route takes precedence over the Luna/high default
- **AND** the orchestrator reports the override and rationale before implementation
