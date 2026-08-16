# core-workflow-contracts Specification

## Purpose
TBD - created by archiving change agent-platform-evolution. Update Purpose after archive.
## Requirements
### Requirement: Unified OpenSpec lifecycle contract
The platform SHALL define one common lifecycle contract plus native phase-contract skills for planning, spec hardening, implementation, verification, and archive, with explicit entry and exit criteria loadable by the primary Sol orchestrator. The planning lifecycle SHALL include a mandatory task-refinement sub-phase after spec hardening and before implementation, implemented as a specialization that does not add a top-level phase or phase-owning agent. To reduce expected implementation cost, normal executor-ready task blocks SHALL be delegated to the designated lower-cost Luna/high refined-task executor by default while Sol retains orchestration and final review.

#### Scenario: Phase transition criteria are available
- **WHEN** the orchestrator starts work on an OpenSpec change
- **THEN** it loads the common lifecycle skill and exactly one matching phase-contract skill
- **AND** the loaded phase contract provides required artifacts, permitted actions, and completion criteria before progression
- **AND** implementation entry requires both hard-spec readiness and a `READY` task-refinement gate

#### Scenario: Task refinement follows spec hardening
- **WHEN** a change reaches hard-spec readiness
- **THEN** the orchestrator remains within the planning lifecycle and applies the task-refinement specialization
- **AND** implementation does not begin until every incomplete implementation task and execution block is executor-ready

#### Scenario: Refined block enters implementation
- **WHEN** a normal task block passes task refinement and implementation begins
- **THEN** the Sol orchestrator keeps the implementation phase contract active
- **AND** delegates one cohesive block to the Luna/high refined-task executor
- **AND** retains final evidence review and task-completion authority

#### Scenario: Phase contract is not an agent
- **WHEN** runtime definitions are validated
- **THEN** planning, spec hardening, implementation, verification, and archive contracts are discoverable as phase-contract skills
- **AND** task refinement is discoverable as a planning specialization skill
- **AND** no separate primary agent is required for any of those contracts

### Requirement: Structured execution evidence
All non-trivial agent responses SHALL include phase, touched files, executed commands, blockers, and missing decisions.

#### Scenario: Evidence is emitted in each phase
- **WHEN** an agent completes a planning, implementation, verification, or archive action
- **THEN** the response includes the mandatory structured evidence fields

### Requirement: Mandatory TDD workflow
The platform SHALL require RED -> GREEN -> REFACTOR for all behavior-changing implementation tasks across all technologies.

#### Scenario: Behavior change starts with failing test
- **WHEN** an implementation task changes system behavior
- **THEN** the task begins by adding or updating a test that fails before production code changes

#### Scenario: Completion includes TDD evidence
- **WHEN** the implementation task is completed
- **THEN** evidence shows the failing test (RED), passing test after minimal code change (GREEN), and final cleanup with tests still passing (REFACTOR)

### Requirement: Phase contract migration compatibility
The platform SHALL document the migration from removed phase-agent entrypoints to orchestrator-plus-phase-skill execution and SHALL keep phase CLI operations functional.

#### Scenario: Existing phase command is executed
- **WHEN** a user runs `opencode-runner.sh phase implementation --change example-change`
- **THEN** the command applies the implementation phase contract through the orchestrator
- **AND** existing phase command syntax remains valid

### Requirement: Deterministic consumer runner discovery
The orchestrator SHALL resolve the platform runner across source, vendored, and global layouts before using direct OpenSpec fallback.

#### Scenario: Consumer project has no root runner
- **WHEN** `./opencode-runner.sh` is absent
- **THEN** the orchestrator checks `./.opencode/opencode-runner.sh` and `$HOME/.config/opencode/opencode-runner.sh` in order
- **AND** it does not report the runner unavailable when either candidate is executable

#### Scenario: No runner covers the operation
- **WHEN** no runner candidate exists or the resolved runner does not support the required operation
- **THEN** the orchestrator may use direct `openspec` commands
- **AND** it reports the fallback reason explicitly

