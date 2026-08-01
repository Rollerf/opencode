# Global Token-Saving Defaults Specification

## ADDED Requirements

### Requirement: Versioned Caveman default instruction

The repository SHALL provide `instructions/caveman-default.md` as a versioned global instruction that enables `$caveman` full mode at the start of every OpenCode session.

#### Scenario: Consumer starts a normal session

- **WHEN** an OpenCode installation loads the versioned global instruction
- **THEN** Caveman full mode applies to status updates and conversational responses by default
- **AND** the mode remains active until the operator selects another intensity or explicitly requests `stop caveman` or `normal mode`

#### Scenario: Caveman skill is unavailable

- **WHEN** the instruction is loaded but the `$caveman` skill cannot be resolved
- **THEN** the agent uses equivalent terse communication without dropping technical facts
- **AND** the missing specialization does not block the requested work

### Requirement: Protected output boundaries

The Caveman default SHALL preserve normal prose for outputs where compression could reduce safety, interoperability, or technical clarity.

#### Scenario: Agent produces a protected output

- **WHEN** the agent writes code, commands, commit messages, pull request text, security warnings, irreversible-action confirmations, or OpenSpec artifacts
- **THEN** the output uses normal technical style instead of Caveman prose
- **AND** `proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md` remain normal English technical prose

### Requirement: Versioned RTK OpenCode plugin

The repository SHALL provide `plugins/rtk.ts` as a versioned OpenCode plugin that delegates eligible Bash and shell command rewriting to `rtk rewrite`.

#### Scenario: RTK rewrites an eligible command

- **WHEN** OpenCode executes a Bash or shell command and `rtk rewrite` returns a different non-empty command
- **THEN** the plugin replaces the command with the RTK form before execution

#### Scenario: RTK is unavailable or declines rewriting

- **WHEN** the `rtk` binary is missing, rewriting fails, or the rewritten command is empty or unchanged
- **THEN** OpenCode startup and command execution continue without a rewritten command

### Requirement: Portable global configuration template

The repository SHALL provide `core/templates/opencode.global.json` without machine-specific absolute paths, credentials, provider settings, or MCP settings.

#### Scenario: Operator configures a global checkout

- **WHEN** the operator merges the template into `~/.config/opencode/opencode.json`
- **THEN** the config references `instructions/caveman-default.md` using a repository-relative path
- **AND** it registers repository-local skill paths
- **AND** the active `opencode.json` remains machine-owned

### Requirement: Pull-based updates

Portable token-saving defaults SHALL be tracked by Git so a global checkout can receive updates from `main`.

#### Scenario: Global checkout pulls a newer main

- **WHEN** `main` contains updated `instructions/caveman-default.md` or `plugins/rtk.ts`
- **THEN** `git pull` updates those files without replacing machine-owned `opencode.json`
- **AND** OpenCode uses the updated config-time files after restart

### Requirement: Deterministic token-saving contract

The validation suite SHALL verify all repository-owned token-saving runtime assets and policy references.

#### Scenario: Required asset or policy is missing

- **WHEN** the instruction, plugin, global template, orchestrator default, or validation-runner integration is absent or malformed
- **THEN** the token-saving defaults contract fails with a non-zero status and an actionable message

#### Scenario: All token-saving defaults are valid

- **WHEN** every required asset, policy, and runner integration is present
- **THEN** the contract passes and the full validation runner continues
