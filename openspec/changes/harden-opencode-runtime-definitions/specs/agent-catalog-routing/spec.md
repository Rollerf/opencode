## MODIFIED Requirements

### Requirement: Canonical agent taxonomy
The platform SHALL maintain a canonical catalog of actual runtime agents with unique IDs, slash-qualified runtime names, source paths, specialization, model assignment, step limit, delegation scope, expected inputs, and expected outputs. The catalog SHALL include the primary orchestrator and SHALL NOT represent phase-contract skills as agents.

#### Scenario: Catalog presents runtime metadata
- **WHEN** a maintainer or validator inspects the agent catalog
- **THEN** each agent entry resolves to an existing definition and includes its runtime name, model, steps, delegation scope, phase scope, specialization, expected inputs, and expected outputs

#### Scenario: Nested subagent runtime name is validated
- **WHEN** an agent file is stored at `agents/subagent/code-documentation-subagent.md`
- **THEN** its catalog runtime name is `subagent/code-documentation-subagent`

#### Scenario: Orchestrator is cataloged
- **WHEN** the catalog is validated
- **THEN** it contains exactly one primary orchestrator entry

### Requirement: Deterministic routing policy
Routing SHALL select exactly one workflow phase first, one stack pack second, zero or more specialization skills third, and optional bounded subagent delegation last. A specialized helper SHALL supplement rather than replace the selected phase contract.

#### Scenario: Composite implementation and documentation request
- **WHEN** a request implements an OpenSpec task and also updates documentation
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
The platform SHALL use `orchestrator.md` as the only phase-owning interactive agent and SHALL load the selected planning, spec-hardening, implementation, verification, or archive contract as a native skill in the same session.

#### Scenario: Orchestrator executes selected phase locally
- **WHEN** a user asks the orchestrator to perform work that maps to a known phase
- **THEN** the orchestrator loads exactly one matching phase-contract skill, executes permitted local actions, and reports phase, touched files, commands, blockers, and missing decisions

#### Scenario: Removed phase-agent name is requested
- **WHEN** a consumer uses a documented phase operation after migration
- **THEN** the runner selects the orchestrator plus the matching phase skill
- **AND** does not require a separate primary phase agent

#### Scenario: Subagents are used only when beneficial
- **WHEN** the orchestrator can complete the task with the selected phase and specialization skills
- **THEN** it does not delegate unless specialization, safe parallelism, context reduction, or a distinct deliverable provides a stated benefit

## ADDED Requirements

### Requirement: Phase contract catalog
The platform SHALL maintain a structured phase-contract catalog that maps each supported phase to one native skill and its entry and completion criteria.

#### Scenario: Runner resolves a phase
- **WHEN** the runner receives `--phase verification`
- **THEN** it resolves the verification phase skill from the phase-contract catalog
- **AND** includes that skill with the orchestrator

### Requirement: Non-overlapping specialist ownership
Specialist subagents SHALL have bounded responsibilities that do not duplicate phase ownership or create conflicting production-code and test ownership.

#### Scenario: TDD helper is delegated
- **WHEN** the orchestrator delegates test work to the TDD helper
- **THEN** the helper owns test planning and test edits
- **AND** production-code changes remain with the orchestrator unless explicitly included in the delegation

#### Scenario: Feature iteration changes behavior
- **WHEN** feature iteration changes observable behavior
- **THEN** valid tests may be added or updated under the TDD contract
- **AND** existing valid tests are not weakened or removed without explicit approval
