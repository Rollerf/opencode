## MODIFIED Requirements

### Requirement: Core-plus-pack composition model
The platform SHALL compose the common workflow, one phase-contract skill, one validated stack pack, and applicable specialization skills. The selected pack's constraints, commands, and safety metadata SHALL be present in generated runtime context without overriding mandatory core lifecycle requirements.

#### Scenario: Stack pack extends runtime context
- **WHEN** a project activates the `angular` pack
- **THEN** the generated context includes the Angular pack's constraints, verification commands, TDD commands, and prohibited actions
- **AND** mandatory core workflow requirements remain in force

#### Scenario: Unknown pack is requested
- **WHEN** bundle generation receives a pack name without a corresponding `packs/<name>/pack.yaml`
- **THEN** generation fails with an actionable unknown-pack error

## ADDED Requirements

### Requirement: Stack-neutral shared subagents
Shared subagents SHALL avoid stack-specific paths, commands, error formats, and architecture assumptions unless those details are supplied by the active pack or a loaded specialization skill.

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
