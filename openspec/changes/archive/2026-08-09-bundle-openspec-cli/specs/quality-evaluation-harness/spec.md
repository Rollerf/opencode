# Quality Evaluation Harness Delta

## ADDED Requirements

### Requirement: Bundled OpenSpec CLI contract coverage
The validation suite SHALL verify the exact OpenSpec dependency and module-local runner selection.

#### Scenario: Runner doctor executes after npm install
- **WHEN** the runner contract invokes doctor
- **THEN** doctor reports `${MODULE_DIR}/node_modules/.bin/openspec`
- **AND** reports OpenSpec version `1.1.1`

#### Scenario: Dependency metadata drifts
- **WHEN** `package.json` does not declare exact runtime dependency `@fission-ai/openspec` version `1.1.1`
- **THEN** the distribution contract fails with an actionable message
