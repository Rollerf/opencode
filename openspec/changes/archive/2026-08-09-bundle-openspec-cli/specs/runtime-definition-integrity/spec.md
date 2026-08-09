# Runtime Definition Integrity Delta

## ADDED Requirements

### Requirement: Deterministic OpenSpec CLI resolution
The platform SHALL provide and resolve an OpenSpec CLI for runner operations without requiring a global npm installation.

#### Scenario: Module dependencies are installed
- **WHEN** `${MODULE_DIR}/node_modules/.bin/openspec` is executable
- **THEN** the runner selects that binary before any global or project-local candidate
- **AND** all runner OpenSpec operations use the platform-tested CLI version

#### Scenario: Module-local CLI is absent
- **WHEN** the module-local candidate is absent
- **THEN** the runner checks an existing `openspec` command on `PATH`
- **AND** then checks `${PROJECT_ROOT}/node_modules/.bin/openspec`

#### Scenario: No CLI candidate exists
- **WHEN** no executable OpenSpec CLI candidate is available
- **THEN** runner doctor and phase operations fail with a non-zero status
- **AND** the error instructs the operator to run `npm install` in the platform module

### Requirement: Pinned OpenSpec runtime dependency
The platform SHALL declare `@fission-ai/openspec` version `1.1.1` as an exact runtime dependency.

#### Scenario: Platform dependencies are installed
- **WHEN** an operator runs `npm install` in the platform checkout
- **THEN** `node_modules/.bin/openspec` is installed
- **AND** `openspec --version` reports `1.1.1`
