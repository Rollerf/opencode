## Why

The repository already has `web-ui-ux` guidance for frontend quality, but browser-driven execution guidance still lives outside the current skill system under `.claude/skills/playwright-cli/`. That means frontend work can benefit from Playwright only informally, without a reusable skill that the current platform can load and compose with `web-ui-ux`.

We need to migrate the Playwright CLI guidance into the repository skill system so consumer projects can use it consistently. The migrated skill should complement `web-ui-ux` by providing browser automation, tracing, snapshots, and Playwright test workflows for frontend development.

## What Changes

- Add a first-class `playwright-cli` skill under `skill/` using the existing repository manifest format.
- Migrate the current `.claude/skills/playwright-cli` references into the repository skill layout.
- Document and validate how `playwright-cli` composes with `web-ui-ux` for frontend/UI work.
- Remove the duplicated `.claude` copy once the repository-native skill is in place.

## Capabilities

### New Capabilities
- `playwright-cli-skill`: reusable Playwright browser automation skill for frontend development, debugging, and evidence capture.

### Modified Capabilities
- `web-ui-ux-guidance`: compose with Playwright CLI for browser verification and UI evidence workflows.

## Impact

- Adds a new reusable skill under `skill/`.
- Updates docs and validation coverage for frontend/browser skill composition.
- Removes duplicated skill content from `.claude/skills/` after migration.
