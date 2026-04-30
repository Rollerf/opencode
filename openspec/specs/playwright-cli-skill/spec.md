# playwright-cli-skill Specification

## Purpose
Define the repository-native Playwright CLI skill and its composition path with `web-ui-ux` for frontend browser evidence workflows.
## Requirements
### Requirement: Repository-native Playwright CLI skill
The platform SHALL expose a repository-native `playwright-cli` skill under `skill/` for browser automation and Playwright-oriented frontend workflows.

#### Scenario: Skill catalog includes Playwright CLI
- **WHEN** a user lists available repository skills
- **THEN** `playwright-cli` appears as an available skill with manifest metadata and a repository-native invocation tag

### Requirement: Web UI UX composition with Playwright
The platform SHALL document that `web-ui-ux` can compose with `playwright-cli` when frontend work requires browser evidence, tracing, snapshots, or Playwright test debugging.

#### Scenario: Frontend workflow uses visual guidance plus browser tooling
- **WHEN** a user performs frontend/UI work that requires browser verification or Playwright debugging
- **THEN** the shared guidance describes using `$web-ui-ux` together with `$playwright-cli`

### Requirement: Repository skill source of truth
The platform SHALL keep the repository-native `skill/playwright-cli/` copy as the source of truth and SHALL remove the duplicated `.claude/skills/playwright-cli/` copy after migration.

#### Scenario: Migrated skill storage is canonical
- **WHEN** the migration is complete
- **THEN** the Playwright CLI skill content exists under `skill/playwright-cli/` and the duplicate `.claude/skills/playwright-cli/` directory no longer exists
