# Change: Version Global Token-Saving Defaults

## Why

The workstation currently enables Caveman and RTK through ignored machine-local files under `~/.config/opencode`. Those files work on one machine but cannot be delivered by pulling this repository. Portable runtime defaults must be versioned so the global checkout and consumer projects receive policy and plugin updates through the normal `main` distribution channel.

## What Changes

- Add a repository-owned global instruction that enables Caveman full mode by default while preserving clarity and normal prose for protected artifacts and safety-critical communication.
- Add the RTK OpenCode plugin as a repository-owned plugin with graceful fallback when the `rtk` binary is unavailable.
- Add a portable global configuration template that references the versioned instruction with repository-relative paths.
- Update the orchestrator policy so Caveman is the default token-saving communication mode rather than an opt-in mode.
- Add deterministic validation for the instruction, template, plugin, and orchestrator policy.
- Document pull-based installation and the boundary between versioned defaults and machine-owned configuration.

## Capabilities

### New Capabilities

- `global-token-saving-defaults`: Defines portable Caveman and RTK defaults for global and consumer OpenCode installations.

### Modified Capabilities

- `agent-catalog-routing`: Changes the orchestrator communication policy from user-triggered Caveman activation to Caveman full mode by default with explicit opt-out.
- `quality-evaluation-harness`: Adds contract coverage for versioned token-saving runtime assets.

## Impact

- Affected runtime files: `agents/orchestrator.md`, `instructions/caveman-default.md`, `plugins/rtk.ts`, and `core/templates/opencode.global.json`.
- Affected validation: `scripts/validate/run-all.sh` and a new token-saving defaults contract.
- Affected documentation: `README.md` and `CONTRIBUTING.md`.
- Existing machine-owned `opencode.json` files remain untracked and retain local provider, MCP, permission, and reference settings.
- OpenCode must be restarted after config-time files are pulled.
