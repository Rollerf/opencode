# Design: Bundle the OpenSpec CLI with the Platform

## Context

The runner executes `openspec` as a bare command. The active environment currently has no such command in `PATH`, despite earlier sessions having OpenSpec installed under another Node version. The global platform checkout already owns runtime npm dependencies and runs `npm install`, making it the stable location for the CLI.

## Goals

- Make OpenSpec validation available to every project using the platform checkout.
- Avoid dependence on NVM-specific global npm state.
- Pin the CLI version already used by platform validation.
- Preserve an explicitly installed CLI as fallback when module dependencies are absent.

## Non-Goals

- Upgrading OpenSpec beyond version 1.1.1.
- Installing npm dependencies automatically during `git pull`.
- Removing direct OpenSpec fallback when both runner and CLI are genuinely unavailable.

## Decisions

### Runtime dependency

`@fission-ai/openspec` SHALL be an exact production dependency at version `1.1.1`. It is a runtime tool used by the runner, not only a development dependency.

### CLI resolution order

Before any command dispatch, the runner SHALL configure the first executable CLI from:

1. `${MODULE_DIR}/node_modules/.bin/openspec`
2. Existing `openspec` on `PATH`
3. `${PROJECT_ROOT}/node_modules/.bin/openspec`

The module-local binary has priority so global and vendored consumers use the platform-tested version. The selected binary directory is prepended to `PATH`, preserving existing phase command construction and dry-run output.

### Diagnostics

`doctor` SHALL fail with an actionable `npm install` message when no candidate exists. When found, it SHALL report the selected executable path and version.

### Contract coverage

The runner contract SHALL assert that doctor selects `${MODULE_DIR}/node_modules/.bin/openspec` and reports version `1.1.1`. The distribution contract SHALL assert the exact dependency declaration.

## Risks and Mitigations

- **Risk:** Package installation increases dependency size. **Mitigation:** Use one pinned runtime package and existing npm lifecycle.
- **Risk:** CLI upgrades alter archive/spec behavior. **Mitigation:** Pin 1.1.1 and upgrade through a separate verified change.
- **Risk:** Consumer forgets `npm install`. **Mitigation:** Doctor emits an actionable message and documentation requires install after dependency changes.

## Rollout

1. Add failing dependency and doctor assertions.
2. Add the dependency and runner resolution.
3. Run npm install, full contracts, evaluations, and strict OpenSpec validation.
4. Archive and release through Gitflow.
5. Pull the released main into `~/.config/opencode` and run npm install.

## Rollback

Revert dependency, lockfile, runner resolution, and contract changes. Consumers return to a PATH-managed OpenSpec installation.

## Open Questions

None.
