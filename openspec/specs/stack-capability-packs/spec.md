# stack-capability-packs Specification

## Purpose
TBD - created by archiving change agent-platform-evolution. Update Purpose after archive.
## Requirements
### Requirement: Core-plus-pack composition model
The platform SHALL compose the common workflow, one phase-contract skill, one resolved and validated stack pack, and applicable specialization skills. The selected pack's constraints, commands, and safety metadata SHALL be present in generated runtime context without overriding mandatory core lifecycle requirements.

#### Scenario: Stack pack extends runtime context
- **WHEN** a project activates the `angular` pack
- **THEN** the generated context includes the Angular pack's constraints, verification commands, TDD commands, and prohibited actions
- **AND** mandatory core workflow requirements remain in force

#### Scenario: Unknown pack is requested
- **WHEN** bundle generation receives a pack name without a corresponding `packs/<name>/pack.yaml`
- **THEN** generation fails with an actionable unknown-pack error

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

### Requirement: Structured pack detection metadata
Every non-generic stack pack SHALL define `detection.required` markers that the orchestrator can evaluate against the consumer project. Supported markers SHALL be `path_exists` with `type` and `path`, and `file_contains` with `type`, `path`, and literal `value`. A non-generic pack matches only when every required marker matches. The `generic` pack SHALL be confirmation-only and SHALL NOT define an automatic match.

#### Scenario: Angular project matches one pack
- **WHEN** every required Angular marker matches the consumer project and no other non-generic pack fully matches
- **THEN** the orchestrator infers `angular`
- **AND** reports the matching marker evidence before starting phase work

#### Scenario: Pack metadata is incomplete
- **WHEN** a non-generic pack lacks `detection.required` or uses an unsupported marker type
- **THEN** structured validation fails with the pack path and invalid marker

### Requirement: Pre-work pack resolution
Before planning, implementation, verification, or archive work begins, the orchestrator SHALL resolve one pack using this precedence: explicit operator or CLI selection, compatible confirmed project configuration, then structured project-evidence inference.

#### Scenario: Explicit pack is supplied
- **WHEN** the operator or runner supplies `--pack angular` and that pack exists
- **THEN** `angular` is selected without heuristic inference
- **AND** its detection evidence may still be reported for transparency

#### Scenario: Exactly one pack is inferred
- **WHEN** no explicit or confirmed pack is available and exactly one non-generic pack matches all required markers
- **THEN** the orchestrator selects that pack and reports the evidence
- **AND** phase work may begin

#### Scenario: Multiple packs match
- **WHEN** more than one non-generic pack matches the project evidence
- **THEN** the orchestrator lists each candidate and its matching markers
- **AND** asks the operator to confirm one before phase work begins

#### Scenario: No pack matches
- **WHEN** no non-generic pack matches the project evidence
- **THEN** the orchestrator reports the inspected evidence and does not silently select `generic`
- **AND** asks the operator either to explicitly confirm `generic` or request definition of a new pack before phase work begins

#### Scenario: Confirmed pack conflicts with current evidence
- **WHEN** `.opencode-project.yaml` names a pack whose required markers no longer match the project
- **THEN** the orchestrator reports the mismatch and asks for confirmation or correction before phase work begins

### Requirement: Consumer-owned pack confirmation
The platform SHALL provide `core/templates/opencode-project.yaml` for recording an operator-confirmed `default_pack` and optional `allowed_packs` without embedding project stack choices in agent definitions.

#### Scenario: Operator approves persistence
- **WHEN** the operator confirms an inferred or explicit pack and requests persistence
- **THEN** the consumer records the choice in `.opencode-project.yaml`
- **AND** future sessions validate that choice against current detection evidence

### Requirement: Stack-neutral shared subagents
Retained shared subagents SHALL avoid stack-specific paths, commands, error formats, and architecture assumptions unless those details are supplied by the active pack or a loaded specialization skill.

#### Scenario: TDD helper runs under a non-Go stack
- **WHEN** the TDD helper is used with the `angular`, `java-onprem`, or `generic` pack
- **THEN** it derives test commands from that pack or project documentation
- **AND** does not assume `lambda-handlers`, Go tests, or Lambda packaging

#### Scenario: Documentation helper runs without Go/AWS
- **WHEN** the documentation helper is used in a non-Go/AWS project
- **THEN** it does not require RFC 7807, API Gateway, Pulumi, or `apis/apiManagment.yml`

#### Scenario: Go/AWS specialization is active
- **WHEN** the `go-aws` pack and `$backend-design` are selected
- **THEN** Go, Lambda, RFC 7807, and Pulumi guidance is supplied through those stack-specific definitions

