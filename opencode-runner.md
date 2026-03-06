# OpenCode Runner

Runner helper for this repository.

## File

- `.opencode/opencode-runner.sh`

## Commands

1. Doctor

```bash
.opencode/opencode-runner.sh doctor
```

2. List agents

```bash
.opencode/opencode-runner.sh list agents
```

3. List skills

```bash
.opencode/opencode-runner.sh list skills
```

4. Build a session bundle

```bash
.opencode/opencode-runner.sh bundle --phase planning --change my-change --user-prompt "Draft proposal and tasks"
```

5. Run phase command templates

```bash
.opencode/opencode-runner.sh phase planning --change my-change --dry-run
.opencode/opencode-runner.sh phase implementation --change my-change --dry-run
.opencode/opencode-runner.sh phase verification --change my-change --dry-run
.opencode/opencode-runner.sh phase archive --change my-change --dry-run
```

Use `--dry-run` first to preview commands.
