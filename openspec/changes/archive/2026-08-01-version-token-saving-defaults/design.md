# Design: Version Global Token-Saving Defaults

## Context

`~/.config/opencode` is a checkout of this repository's `main` branch. The current machine has an ignored `opencode.json`, an ignored Caveman instruction, and an ignored RTK plugin. Ignoring all three prevents accidental overwrite of machine configuration, but it also prevents policy and plugin improvements from being distributed through Git.

The portable parts are the Caveman instruction and RTK plugin. Provider credentials, MCP settings, permissions, absolute references, and local overrides remain machine-owned. A versioned template provides a safe onboarding contract without turning the active machine configuration into a tracked file.

## Goals

- Make Caveman full mode the default for repository consumers.
- Make RTK command rewriting available automatically when RTK is installed.
- Allow `git pull` on the global checkout to update both defaults.
- Preserve normal technical prose where compression is unsafe or inappropriate.
- Keep machine-specific configuration untracked.

## Non-Goals

- Installing the `rtk` binary on consumer machines.
- Tracking active `~/.config/opencode/opencode.json` files.
- Forcing Caveman when an operator explicitly requests normal mode.
- Applying Caveman prose to OpenSpec artifacts, code, commits, pull requests, security warnings, or irreversible-action confirmations.
- Replacing specialized OpenCode Read, Grep, Glob, or CodeGraph tools with RTK.

## Decisions

### Repository-owned instruction

The repository SHALL own `instructions/caveman-default.md`. The instruction loads `$caveman` in full mode at session start, defines persistence and opt-out behavior, and repeats the protected-output boundaries required by the orchestrator policy.

This file is referenced from the global config template by a relative path. Existing machine configs may reference the same file by relative or absolute path. Once configured, future pulls update behavior without rewriting machine config.

### Repository-owned RTK plugin

The repository SHALL own `plugins/rtk.ts`. The plugin checks for `rtk`, intercepts Bash and shell execution, delegates rewrite decisions to `rtk rewrite`, and passes the original command through when RTK is missing, no rewrite applies, or rewriting fails.

The plugin does not implement its own rewrite registry. RTK remains the source of truth for command eligibility and output compaction.

### Portable global config template

The repository SHALL own `core/templates/opencode.global.json`. It references `instructions/caveman-default.md` and repository skill paths without embedding machine-specific absolute paths, credentials, provider configuration, or MCP configuration.

Operators merge or copy this template during initial setup. Existing active `opencode.json` files remain machine-owned and are reconciled rather than overwritten.

### Orchestrator default

`agents/orchestrator.md` SHALL require Caveman full mode by default for status updates and conversational output. Explicit operator intensity changes and `stop caveman` or `normal mode` override the default for the current session. Clarity and safety exceptions remain authoritative.

### Contract validation

A shell contract SHALL fail when any versioned token-saving asset is missing or when required policy text and plugin hooks are absent. The main validation runner SHALL execute the contract.

## Risks and Mitigations

- **Risk:** Caveman compression obscures safety instructions. **Mitigation:** Protected-output boundaries require normal prose for security and irreversible actions.
- **Risk:** RTK hides diagnostics needed for debugging. **Mitigation:** The skill and plugin allow raw commands when exact output is required, and RTK retains full failed output where supported.
- **Risk:** Consumer lacks RTK. **Mitigation:** Plugin disables itself without failing OpenCode startup.
- **Risk:** Pull conflicts with ignored local files at the same paths. **Mitigation:** Before the first pull, reconcile identical local copies against tracked files and retain only machine-owned `opencode.json` as ignored state.

## Rollout

1. Add a failing validation contract.
2. Add versioned instruction, plugin, template, orchestrator policy, and documentation.
3. Run the contract, full validation, evaluations, and strict OpenSpec validation.
4. Merge through feature, develop, release, and main.
5. Reconcile the global checkout's ignored copies, then update it to released `main`.
6. Restart OpenCode and verify effective instructions plus RTK plugin discovery.

## Rollback

Revert the versioned instruction, plugin, template, policy, and contract commit. Existing machine-owned config can remove the instruction entry and RTK plugin can be disabled or deleted. Restart OpenCode after rollback.

## Open Questions

None. Portable and machine-owned boundaries are explicit.
