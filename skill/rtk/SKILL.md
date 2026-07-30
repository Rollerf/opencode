---
name: rtk
description: Use when RTK is installed and shell command output may be large, repetitive, noisy, or expensive for model context.
---

# RTK

Use this skill when RTK is installed and the task involves shell commands whose output may be large, repetitive, noisy, or expensive for LLM context.

## Activation Criteria

Activate for Bash/shell work involving:

- git status, diffs, logs, commits, pulls, pushes, or GitHub CLI output
- test runners such as pytest, go test, cargo test, jest, vitest, Playwright, rspec, or generic npm/pnpm tests
- build, lint, typecheck, or formatting commands with long diagnostics
- logs from Docker, Kubernetes, AWS, application files, or CI output
- directory listing, file reading, search, find, JSON, dependencies, or environment summaries where compact output is enough
- repeated command execution where token savings matter

Do not activate only because a command is short and already expected to produce small output.

## Required Preconditions

RTK is a CLI proxy and OpenCode hook/plugin integration, not only a prompt skill.

Use RTK when:

- `rtk` is installed and available on `PATH`, or
- OpenCode has the RTK integration active through `rtk init -g --opencode`.

If RTK is unavailable, fall back to normal Bash commands. Do not block the task.

## Command Guidance

When the OpenCode RTK integration is active, normal Bash commands may be rewritten automatically to RTK equivalents.

When the hook/plugin is not known to be active but `rtk` is available, prefer explicit RTK commands for noisy output:

- `rtk git status`
- `rtk git diff`
- `rtk git log -n 10`
- `rtk test <command>` for generic test commands
- `rtk pytest`, `rtk go test`, `rtk cargo test`, `rtk vitest`, `rtk playwright test`
- `rtk lint`, `rtk tsc`, `rtk cargo clippy`, `rtk ruff check`
- `rtk docker logs <container>`, `rtk kubectl logs <pod>`, `rtk aws logs get-log-events`
- `rtk find "<pattern>" .`, `rtk grep "<pattern>" .`, `rtk read <file>` when shell-based compact output is preferred

Use raw commands instead of RTK when:

- exact full output is required
- an interactive command is involved
- RTK filtering could hide important detail
- the command is destructive or needs uncompressed confirmation
- a specialized tool is more appropriate, such as OpenCode Read/Grep/Glob or CodeGraph MCP tools

## Failure Handling

RTK may save full raw output for failed commands in its tee directory. If RTK reports a path to full output, read that file only when the compact failure summary is insufficient.

If an RTK-wrapped command fails because RTK is missing, retry the original command without RTK.

## Consumer Setup

Consumer projects that use this repository as `.opencode` still need RTK installed and configured separately.

Install RTK:

```bash
brew install rtk
```

Or on Linux/macOS without Homebrew:

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

Wire RTK into OpenCode:

```bash
rtk init -g --opencode
```

Then restart OpenCode.

Verify setup:

```bash
rtk --version
rtk init --show
rtk gain
```
