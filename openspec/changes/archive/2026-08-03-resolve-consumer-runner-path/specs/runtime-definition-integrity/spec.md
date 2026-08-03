# Runtime Definition Integrity Delta

## MODIFIED Requirements

### Requirement: Module and consumer path separation
The runner SHALL resolve platform definitions from `MODULE_DIR` and consumer-owned OpenSpec artifacts and project operations from `PROJECT_ROOT` across source, vendored `.opencode`, and global module layouts.

#### Scenario: Runner executes from a consumer module
- **WHEN** `<consumer>/.opencode/opencode-runner.sh` is invoked with `--change example-change`
- **THEN** agents, skills, and packs are loaded from `<consumer>/.opencode`
- **AND** the change is loaded from `<consumer>/openspec/changes/example-change`

#### Scenario: Runner executes from the platform source repository
- **WHEN** `opencode-runner.sh` is invoked from the platform source checkout or one of its descendants
- **THEN** both `MODULE_DIR` and `PROJECT_ROOT` resolve to the source checkout

#### Scenario: Global runner executes from a consumer project
- **WHEN** a runner whose module directory is outside the consumer working tree is invoked from that consumer project
- **THEN** `MODULE_DIR` resolves to the runner's platform checkout
- **AND** `PROJECT_ROOT` resolves to the physical consumer working directory
- **AND** consumer-owned OpenSpec artifacts are read from that project root
