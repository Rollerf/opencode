# Change: Resolve the Runner from Consumer Projects

## Why

Projects that consume the platform through `~/.config/opencode` report `./opencode-runner.sh absent, so direct openspec validation used`. The orchestrator assumes the runner exists in the consumer working directory, while the runner itself assumes any non-`.opencode` installation is also the project root. A globally installed runner therefore cannot be discovered correctly and would target the platform checkout instead of the consumer even when invoked by absolute path.

## What Changes

- Define deterministic runner discovery across source, vendored `.opencode`, and global `~/.config/opencode` layouts.
- Make the runner use the invocation working directory as `PROJECT_ROOT` when the module is outside that working tree.
- Keep source-checkout and vendored-module behavior unchanged.
- Update orchestrator and OpenSpec skill guidance so absence of `./opencode-runner.sh` alone does not trigger direct-command fallback.
- Add a consumer fixture that invokes the platform runner from a separate project directory.
- Document global runner invocation.

## Capabilities

### Modified Capabilities

- `runtime-definition-integrity`: Extends module and consumer path separation to global module installations.
- `core-workflow-contracts`: Defines deterministic runner discovery before direct OpenSpec fallback.
- `quality-evaluation-harness`: Requires global-runner consumer integration coverage.

## Impact

- Runtime: `opencode-runner.sh` project-root resolution.
- Policy: `agents/orchestrator.md`, `skill/openspec-workflow/SKILL.md`, and `skill/openspec-planning/SKILL.md`.
- Validation: `scripts/validate/runtime-runner-contract.sh` and workflow contracts.
- Documentation: `README.md` and `CONTRIBUTING.md`.
