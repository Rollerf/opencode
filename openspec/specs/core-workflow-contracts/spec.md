# core-workflow-contracts Specification

## Purpose
TBD - created by archiving change agent-platform-evolution. Update Purpose after archive.
## Requirements
### Requirement: Unified OpenSpec lifecycle contract
The platform SHALL define one common lifecycle contract plus native phase-contract skills for planning, spec hardening, implementation, verification, and archive, with explicit entry and exit criteria loadable by the primary orchestrator.

#### Scenario: Phase transition criteria are available
- **WHEN** the orchestrator starts work on an OpenSpec change
- **THEN** it loads the common lifecycle skill and exactly one matching phase-contract skill
- **AND** the loaded phase contract provides required artifacts, permitted actions, and completion criteria before progression

#### Scenario: Phase contract is not an agent
- **WHEN** runtime definitions are validated
- **THEN** planning, spec hardening, implementation, verification, and archive contracts are discoverable as skills
- **AND** no separate primary agent is required for those contracts

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

