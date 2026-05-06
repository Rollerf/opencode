## ADDED Requirements

### Requirement: Unified OpenSpec lifecycle contract
The platform SHALL define a single lifecycle contract for change execution that includes planning, implementation, verification, and archive phases with explicit entry and exit criteria.

#### Scenario: Phase transition criteria are available
- **WHEN** a contributor starts work on a change
- **THEN** the system provides the required artifacts and completion criteria for the current phase before allowing progression

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
