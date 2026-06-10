# CodeGraph

Use this skill when CodeGraph MCP tools are available and the task benefits from semantic code intelligence, structural exploration, call graph analysis, impact analysis, or affected-test discovery.

## Activation Criteria

Activate for requests involving:

- architecture or flow questions such as "how does X work" or "how does X reach Y"
- locating symbols, entry points, handlers, routes, callers, or callees
- understanding impact before changing a function, class, API, or module
- selecting affected tests from changed files
- surveying a code area where file-by-file discovery would be expensive

Do not activate only because the task is a simple one-file edit with an already-known path.

## Required Preconditions

CodeGraph is an MCP-backed CLI integration, not only a prompt skill.

Use CodeGraph only when:

- CodeGraph MCP tools are available in the current runtime.
- The target project has a `.codegraph/` index, or the user agrees to initialize one.

If `.codegraph/` does not exist, tell the user to run:

```bash
codegraph init -i
```

If CodeGraph MCP tools are unavailable, fall back to Glob, Grep, Read, and normal repository exploration.

## Tool Selection

Prefer CodeGraph tools by intent:

- `codegraph_explore`: primary tool for architecture, flow, "how does X work", area surveys, and grouped relevant source.
- `codegraph_search`: locate symbols by name.
- `codegraph_callers`: find what calls a symbol.
- `codegraph_callees`: find what a symbol calls.
- `codegraph_impact`: analyze blast radius before editing a symbol or API.
- `codegraph_node`: inspect one specific symbol in detail.
- `codegraph_files`: inspect indexed file structure.
- `codegraph_status`: check index health, freshness, and pending sync state.

## Usage Rules

- Treat CodeGraph results as already-read source when they include the relevant code.
- Do not repeat CodeGraph discovery with Grep or broad file reads just to verify the same facts.
- Read files directly when CodeGraph reports stale or pending files, when the file was just edited, or when exact current contents are required.
- After edits, trust the staleness signal. If needed, use `codegraph_status` or direct file reads for recently changed files.
- Keep CodeGraph out of default context when no codebase exploration or impact analysis is needed.

## Consumer Setup

Consumer projects that use this repository as `.opencode` still need CodeGraph installed and configured separately:

```bash
npm i -g @colbymchenry/codegraph
codegraph install --target=opencode --location=global
```

Then initialize each project:

```bash
codegraph init -i
```

The project-local `.codegraph/` directory is an index/cache and should normally be ignored by git.
