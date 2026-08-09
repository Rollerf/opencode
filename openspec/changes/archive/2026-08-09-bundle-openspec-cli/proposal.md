# Change: Bundle the OpenSpec CLI with the Platform

## Why

Consumer projects can resolve the global runner but still report `openspec command not found` because the platform does not declare the OpenSpec CLI as a runtime dependency and the runner only searches `PATH`. NVM makes global npm installations version-specific, so a CLI installed for one Node version disappears when another Node version is active.

## What Changes

- Add exact runtime dependency `@fission-ai/openspec@1.1.1` to the platform package.
- Make the runner prefer the module-local `node_modules/.bin/openspec`, then an existing `PATH` command, then a project-local binary.
- Report the selected CLI path and version from `doctor`.
- Add validation proving module-local CLI resolution.
- Document `npm install` as required setup after pulling dependency changes.

## Capabilities

### Modified Capabilities

- `runtime-definition-integrity`: Adds deterministic OpenSpec CLI resolution for source, vendored, and global modules.
- `quality-evaluation-harness`: Adds dependency and doctor coverage for the bundled CLI.

## Impact

- Dependencies: `package.json` and `package-lock.json`.
- Runtime: `opencode-runner.sh`.
- Validation: runner and distribution contracts.
- Documentation: `README.md` and `CONTRIBUTING.md`.
