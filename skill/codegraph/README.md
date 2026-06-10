# CodeGraph

CodeGraph provides semantic code intelligence through an OpenCode MCP integration. It helps agents answer structural code questions with fewer file reads by querying a project-local code graph.

## Consumer Setup

When this repository is installed as a submodule at `.opencode`, the wrapper skill is available to agents at:

- `.opencode/skill/codegraph/SKILL.md`
- `.opencode/skill/codegraph/manifest.yaml`

The wrapper skill only tells agents when and how to use CodeGraph. Each consumer machine must also install CodeGraph and wire it into OpenCode:

```bash
npm i -g @colbymchenry/codegraph
codegraph install --target=opencode --location=global
```

Each consumer project must initialize its own local index:

```bash
codegraph init -i
```

The generated `.codegraph/` directory is an index/cache and should normally be ignored by git.

## Readiness Checklist

- `codegraph --version` works.
- OpenCode has the CodeGraph MCP server configured.
- OpenCode has been restarted after CodeGraph setup.
- The consumer project has `.codegraph/` from `codegraph init -i`.
- CodeGraph MCP tools are visible to the agent.

If any check fails, agents should fall back to Glob/Grep/Read and explain the missing setup when relevant.

## Agent Usage

Use `$codegraph` for:

- structural code exploration
- architecture and flow questions
- symbol lookup
- callers/callees analysis
- impact analysis before edits
- affected-test discovery

Do not use CodeGraph as a blocker. If MCP tools or the index are unavailable, continue with normal repository exploration.

## See Also

- [`SKILL.md`](./SKILL.md) - agent-facing usage rules
- [CodeGraph upstream](https://github.com/colbymchenry/codegraph)
