# Core Workflow Contracts Delta

## ADDED Requirements

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
