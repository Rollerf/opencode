# stack-capability-packs Specification

## Purpose
TBD - created by archiving change agent-platform-evolution. Update Purpose after archive.
## Requirements
### Requirement: Core-plus-pack composition model
The platform SHALL support a composition model where a mandatory core workflow is extended by optional stack capability packs, and packs MAY add skill overlays that refine guidance for matching task intent without overriding mandatory lifecycle requirements.

#### Scenario: Stack pack extends core rules
- **WHEN** a project activates a stack pack
- **THEN** the pack adds stack-specific guidance without overriding mandatory core lifecycle requirements

#### Scenario: Angular pack composes shared web UI guidance
- **WHEN** Angular UI implementation work is executed under the Angular pack
- **THEN** the pack can apply shared `web-ui-ux` guidance together with Angular-specific commands and constraints

#### Scenario: Angular pack avoids backend-only skill overlays for UI work
- **WHEN** Angular UI/frontend implementation work is executed without explicit backend scope
- **THEN** the pack overlay excludes backend-only skills such as `backend-design`

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
Each stack pack SHALL define concrete TDD execution guidance, including how to run fast failing tests, full passing suites, and refactor-safety checks for the stack toolchain, and web-oriented packs SHALL keep shared UI guidance separate from framework-specific test commands.

#### Scenario: Agent follows stack TDD guidance
- **WHEN** an agent executes a behavior-changing task under an active stack pack
- **THEN** the agent uses the pack-defined RED/GREEN/REFACTOR commands and records outputs as execution evidence

