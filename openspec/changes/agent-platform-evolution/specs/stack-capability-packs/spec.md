## ADDED Requirements

### Requirement: Core-plus-pack composition model
The platform SHALL support a composition model where a mandatory core workflow is extended by optional stack capability packs.

#### Scenario: Stack pack extends core rules
- **WHEN** a project activates a stack pack
- **THEN** the pack adds stack-specific guidance without overriding mandatory core lifecycle requirements

### Requirement: Multi-stack pack catalog
The platform SHALL provide first-class pack definitions for `go-aws`, `java-onprem`, `angular`, and `generic` contexts.

#### Scenario: Project selects matching pack
- **WHEN** a project configuration declares its technology context
- **THEN** the corresponding pack is selected and its constraints are applied during planning and implementation

### Requirement: Pack-level verification commands
Each stack pack SHALL define baseline verification commands for build, test, and lint workflows.

#### Scenario: Agent executes pack verification
- **WHEN** implementation tasks are marked complete for a project
- **THEN** the agent runs the pack-defined verification commands and reports outcomes as evidence

### Requirement: Pack-level TDD guidance
Each stack pack SHALL define concrete TDD execution guidance, including how to run fast failing tests, full passing suites, and refactor-safety checks for the stack toolchain.

#### Scenario: Agent follows stack TDD guidance
- **WHEN** an agent executes a behavior-changing task under an active stack pack
- **THEN** the agent uses the pack-defined RED/GREEN/REFACTOR commands and records outputs as execution evidence
