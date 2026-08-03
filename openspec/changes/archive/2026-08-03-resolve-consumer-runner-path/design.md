# Design: Resolve the Runner from Consumer Projects

## Context

The platform supports three layouts:

1. Source checkout: module and project are the same repository.
2. Vendored module: `<consumer>/.opencode` contains the platform and its parent is the project.
3. Global module: `~/.config/opencode` contains the platform while the current working directory is an unrelated consumer project.

The current runner handles only the first two layouts. The orchestrator also names only `./opencode-runner.sh`, causing a false absence report in global consumers.

## Goals

- Discover a usable runner before falling back to direct OpenSpec commands.
- Preserve module-owned agents, skills, and packs.
- Target consumer-owned OpenSpec artifacts from global installations.
- Avoid machine-specific absolute paths in versioned policy.
- Cover the global layout with a deterministic fixture.

## Non-Goals

- Installing a runner binary on `PATH`.
- Replacing direct `openspec` commands when runner coverage is genuinely insufficient.
- Changing pack detection semantics.
- Changing source or `.opencode` consumer behavior.

## Decisions

### Runner discovery order

The orchestrator SHALL resolve the first executable runner from:

1. `./opencode-runner.sh`
2. `./.opencode/opencode-runner.sh`
3. `$HOME/.config/opencode/opencode-runner.sh`

Direct `openspec` fallback is allowed only when no candidate exists or the resolved runner does not cover the required operation.

### Project-root inference

`MODULE_DIR` remains the physical directory containing `opencode-runner.sh`.

- If `MODULE_DIR` is named `.opencode`, `PROJECT_ROOT` is its parent.
- If the invocation working directory is `MODULE_DIR` or a descendant, `PROJECT_ROOT` is `MODULE_DIR`.
- Otherwise, `PROJECT_ROOT` is the physical invocation working directory.

This makes an absolute global runner invocation operate on the consumer while preserving source-checkout behavior from repository subdirectories.

### Integration fixture

The runner contract SHALL create a standalone consumer project outside `MODULE_DIR`, invoke the source runner by absolute path from that consumer directory, and assert that bundles identify the external consumer as `PROJECT_ROOT` while loading definitions from the source module.

## Risks and Mitigations

- **Risk:** Running the source runner from an unrelated accidental directory targets that directory. **Mitigation:** This behavior occurs only when invocation cwd is outside the module and matches the explicit global-consumer use case; doctor and phase checks still validate project evidence.
- **Risk:** Symlink paths defeat containment checks. **Mitigation:** Resolve module and working directories physically before comparison.
- **Risk:** Direct OpenSpec fallback remains overused. **Mitigation:** Policy and contracts require all three candidates to be checked first.

## Rollout

1. Add the global-consumer fixture and confirm RED.
2. Implement project-root inference and policy discovery order.
3. Run runner, consumer, full validation, evaluation, and strict OpenSpec gates.
4. Archive and release through Gitflow.

## Rollback

Revert the runner inference and policy changes. Source and vendored layouts return to previous behavior; global consumers must use direct OpenSpec commands.

## Open Questions

None.
