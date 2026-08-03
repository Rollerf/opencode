# Quality Evaluation Harness Delta

## MODIFIED Requirements

### Requirement: Runner integration validation
The validation suite SHALL exercise runner behavior from the platform source layout, the consumer `.opencode` layout, and a global-module layout invoked from an external consumer working directory.

#### Scenario: Consumer change is bundled
- **WHEN** the fixture invokes `.opencode/opencode-runner.sh bundle --change fixture-change`
- **THEN** the bundle references the consumer root and consumer-owned change path
- **AND** module-owned agents, skills, and packs are included from `.opencode`

#### Scenario: Global consumer change is bundled
- **WHEN** the fixture invokes a platform runner outside the consumer tree from the consumer working directory
- **THEN** the bundle references the external consumer root and consumer-owned change path
- **AND** module-owned agents, skills, and packs are included from the platform checkout

#### Scenario: Pack content is checked
- **WHEN** a bundle is generated with `--pack angular`
- **THEN** validation confirms that Angular constraints and verification commands are present

#### Scenario: Unique pack inference is checked
- **WHEN** a fixture matches exactly one non-generic pack's required markers
- **THEN** validation confirms that the orchestrator selects that pack and reports its evidence

#### Scenario: Ambiguous pack inference is checked
- **WHEN** a fixture matches multiple non-generic packs
- **THEN** validation confirms that phase work is blocked pending operator confirmation

#### Scenario: Unsupported stack inference is checked
- **WHEN** a fixture matches no non-generic pack
- **THEN** validation confirms that `generic` is not silently selected
- **AND** the result requests explicit generic confirmation or a new pack definition

#### Scenario: Default reference behavior is checked
- **WHEN** a bundle is generated without `--references`
- **THEN** validation confirms skill reference bodies are absent
- **AND** size diagnostics are present
