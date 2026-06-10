# RTK

RTK is a CLI proxy and OpenCode hook/plugin integration that reduces token usage by compacting common shell command output before it reaches the agent context.

## Consumer Setup

When this repository is installed as a submodule at `.opencode`, the wrapper skill is available to agents at:

- `.opencode/skill/rtk/SKILL.md`
- `.opencode/skill/rtk/manifest.yaml`

The wrapper skill only tells agents when and how to use RTK. Each consumer machine must also install RTK and wire it into OpenCode.

Install RTK with Homebrew:

```bash
brew install rtk
```

Or install on Linux/macOS with the upstream installer:

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

Configure OpenCode:

```bash
rtk init -g --opencode
```

Restart OpenCode after setup.

## Readiness Checklist

- `rtk --version` works.
- `rtk init -g --opencode` has been run.
- OpenCode has been restarted after RTK setup.
- `rtk init --show` confirms the OpenCode integration.
- `rtk gain` works.

If any check fails, agents should run normal commands or use explicit fallback commands without RTK.

## Agent Usage

Use `$rtk` for shell commands with large or noisy output:

- `rtk git status`, `rtk git diff`, `rtk git log -n 10`
- `rtk test <command>` for generic test commands
- `rtk pytest`, `rtk go test`, `rtk cargo test`, `rtk vitest`, `rtk playwright test`
- `rtk lint`, `rtk tsc`, `rtk cargo clippy`, `rtk ruff check`
- `rtk docker logs <container>`, `rtk kubectl logs <pod>`, `rtk aws logs get-log-events`
- `rtk find "<pattern>" .`, `rtk grep "<pattern>" .`, `rtk read <file>` when shell-based compact output is preferred

If the OpenCode RTK hook is active, normal shell commands may already be rewritten automatically. If not, agents can call `rtk <command>` explicitly when compact output is useful.

Use normal commands instead when exact full output is required, when RTK is unavailable, or when filtering could hide important detail.

## See Also

- [`SKILL.md`](./SKILL.md) - agent-facing usage rules
- [RTK upstream](https://github.com/rtk-ai/rtk)
