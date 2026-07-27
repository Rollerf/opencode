# OpenCode + OpenSpec Agent Platform

Cross-cutting repository for working with OpenCode and OpenSpec across projects with different stacks (for example Go/AWS, Java on-prem, Angular).

Its goal is to provide a shared base of agents, skills, quality rules, and workflow so day-to-day development stays consistent, verifiable, and focused on preventing regressions.

## What it is for

- Standardize how changes are planned, implemented, verified, and archived with OpenSpec.
- Reuse agents and skills across projects without duplicating prompts per stack.
- Enforce TDD (RED -> GREEN -> REFACTOR) for behavior changes.
- Maintain a global quality bar, independent of technology.
- Limit automation to local environments and provide explicit handoff to external operators.

## How it works

The platform is made up of 5 parts:

1. `agents/`: agents by phase (planner, implementer, verifier, archiver, orchestrator, and sub-agents).
2. `skill/`: reusable skills (`openspec-workflow`, `backend-design`, `node-defi-arbitrage`, `web-ui-ux`, `playwright-cli`, optional CodeGraph, RTK, and n8n skills).
3. `core/`: shared workflow contract, agent catalog, routing policy, and templates.
4. `packs/`: extensions by stack (`go-aws`, `java-onprem`, `angular`, `generic`).
5. `evals/` + `scripts/`: automated evaluation and validation of contracts and quality thresholds.

Routing is intent-first:

- First, the type of work is detected (planning, implementation, verification, archive, docs, etc.).
- Then, the context of the active stack pack is applied.
- `orchestrator.md` is the recommended single interactive entrypoint: it selects the phase contract and executes local work directly unless a specialized subagent clearly reduces context, adds expertise, enables parallelism, or produces a distinct deliverable.

## Operating principles

- **Mandatory TDD** for behavior changes: RED -> GREEN -> REFACTOR.
- **Conventional Commits in English** for all repositories and stacks.
- **Gitflow**: feature branches start from `develop`, reintegrate into `develop`, release from `develop`, merge to `main`, then sync `main` back into `develop`.
- **Correctness and no regression** as the main KPI.
- **Global thresholds** for any stack.
- **Local-only execution**: staging/production actions are not automated.
- **Mandatory handoff** to an external operator when the flow leaves local.

## Branching strategy (gitflow)

This platform defines gitflow as the default branching strategy for repositories that consume it.

1. Create each OpenSpec-backed unit of work on its own `feature/<change-name>` branch from `develop`.
2. Keep one OpenSpec change mapped to one feature branch for clean traceability.
3. Merge completed feature branches back into `develop`.
4. When a set of completed changes is ready, the release branch is cut from `develop` and merged into `main`.
5. After the release merge, sync `main` back into `develop`.

## Main structure

```text
agents/                    # Agents by phase and sub-agents
skill/                     # Reusable skills
third_party/n8n_skills/    # Optional external n8n skills source (submodule)
core/                      # Shared contract and templates
packs/                     # Pack per stack (go-aws, java-onprem, angular, generic)
governance/                # Local-only matrix, security baseline, handoff, audit
evals/                     # Golden tasks + global thresholds
scripts/
  evals/                   # Evaluation runner
  validate/                # Contract/TDD validators
openspec/changes/          # OpenSpec changes (proposal/design/specs/tasks/evidence)
opencode-runner.sh         # Command helper for OpenSpec phases
```

## Quick start

This README is the canonical command reference for `opencode-runner.sh`.

1) Check environment health:

```bash
./opencode-runner.sh doctor
```

2) View available agents and skills:

```bash
./opencode-runner.sh list agents
./opencode-runner.sh list skills
./opencode-runner.sh bundle --phase implementation --pack angular --user-prompt "Polish the Angular dashboard UI"
```

3) Run OpenSpec phase in dry-run mode:

```bash
./opencode-runner.sh phase planning --change <my-change> --dry-run
./opencode-runner.sh phase implementation --change <my-change> --dry-run
./opencode-runner.sh phase verification --change <my-change> --dry-run
./opencode-runner.sh phase archive --change <my-change> --dry-run
```

4) Validate contracts and TDD:

```bash
./scripts/validate/run-all.sh

# or run each validator individually
./scripts/validate/contracts.sh
./scripts/validate/gitflow-branching-contract.sh
./scripts/validate/tdd-contract.sh
./scripts/validate/angular-ui-contract.sh
./scripts/validate/web-ui-ux-contract.sh
./scripts/validate/playwright-cli-contract.sh
./scripts/validate/n8n-skills-contract.sh
```

5) Run quality harness:

```bash
./scripts/evals/run-all.sh
```

## Web UI / Angular frontend guidance

- Use `$web-ui-ux` for frontend/UI tasks involving layout, visual polish, responsive behavior, state coverage, or component reuse.
- Use `$playwright-cli` alongside `$web-ui-ux` when frontend work needs browser automation, traces, snapshots, or Playwright test debugging.
- Under `packs/angular`, frontend-only work should use `$web-ui-ux` and should not load `$backend-design`.
- If a request explicitly combines Angular UI work with backend changes, the guidance set may include both `$web-ui-ux` and `$backend-design`.
- Future web packs (for example Astro) should reuse `web-ui-ux` for cross-framework UI quality guidance and add framework-specific overlays separately.

If a consumer runtime exposes a narrower `available_skills` list than the module imports, module-owned skills remain usable through the repository-local skill files. For example, when `$web-ui-ux` is not available through the runtime skill loader but `.opencode/skill/web-ui-ux/SKILL.md` exists in the consumer project, agents should read and apply that local file instead of reporting `missing_specialization`.

## Node DeFi arbitrage guidance

- Use `$node-defi-arbitrage` for TypeScript services that discover, simulate, or execute arbitrage through DEXs and blockchain RPC providers.
- The skill provides reusable context for exact execution math, quote and simulation semantics, same-chain atomicity, cross-chain limitations, RPC reliability, MEV, and testing approaches.
- Blockchains, DEXs, tokens, providers, relays, hosting, storage, contracts, risk thresholds, and operational commands remain decisions of each consuming project.
- Public testnet liquidity must not be treated as representative of mainnet arbitrage performance; projects may use mainnet forks, historical backtesting, and live-data shadow mode as appropriate.
- Do not apply `$backend-design` unless the request also changes the Go/AWS backend.

## Global quality thresholds

Defined in `evals/config/global-thresholds.json`.

## Optional n8n support

This repository supports optional n8n skills through `third_party/n8n_skills`.

- Default behavior: n8n skills are not loaded for non-n8n requests.
- Activation: request n8n explicitly (for example, "build an n8n workflow").
- Gateway strategy: `$n8n-gateway` -> `$n8n-mcp-tools-expert`.

If the submodule is not initialized in a consumer project:

```bash
git submodule update --init --recursive third_party/n8n_skills
```

- first-pass correctness >= 95
- regressions = 0
- tdd red-first rate = 100
- tdd green pass rate = 100
- tdd refactor safety rate >= 95
- critical scenario coverage = 100
- total scenario coverage >= 95
- strict validation pass rate = 100
- high/critical security findings = 0

## Optional CodeGraph support

This repository includes a `$codegraph` wrapper skill at `skill/codegraph/SKILL.md` for projects that use [CodeGraph](https://github.com/colbymchenry/codegraph) as an OpenCode MCP integration. See `skill/codegraph/README.md` for consumer setup details.

CodeGraph is not only a prompt skill. Consumer machines must install and wire the MCP server into OpenCode:

```bash
npm i -g @colbymchenry/codegraph
codegraph install --target=opencode --location=global
```

Each consumer project must also initialize its local code graph index:

```bash
codegraph init -i
```

The generated `.codegraph/` directory is an index/cache and should normally be ignored by git.

Agents should use `$codegraph` when CodeGraph MCP tools are available and the task involves structural code exploration, call graph questions, impact analysis, symbol lookup, or affected-test discovery. If CodeGraph MCP tools are not available, or the project has not been indexed, agents should fall back to normal Glob/Grep/Read exploration and explain the missing setup when relevant.

## Optional RTK support

This repository includes an `$rtk` wrapper skill at `skill/rtk/SKILL.md` for projects that use [RTK](https://github.com/rtk-ai/rtk) to reduce token usage from shell command output. See `skill/rtk/README.md` for consumer setup details.

RTK is not only a prompt skill. Consumer machines must install RTK and wire the OpenCode integration:

```bash
brew install rtk
# or
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

rtk init -g --opencode
```

Restart OpenCode after setup.

Agents should use `$rtk` when RTK is available and the task involves shell commands with large or noisy output, such as `git diff`, test runners, lint/build commands, logs, Docker/Kubernetes/AWS output, or repeated command execution. If RTK is not available, agents should run normal commands and continue the task.

## Consumer readiness checklist

For CodeGraph:

- `codegraph --version` works.
- OpenCode has the CodeGraph MCP server configured.
- OpenCode has been restarted after CodeGraph setup.
- The project has `.codegraph/` created with `codegraph init -i`.
- The agent can access CodeGraph MCP tools.

For RTK:

- `rtk --version` works.
- `rtk init -g --opencode` has been run.
- OpenCode has been restarted after RTK setup.
- `rtk init --show` confirms the OpenCode integration.
- `rtk gain` works.

If any check fails, agents should fall back to normal tools and explain the missing setup when relevant.

## Consumer optional tools setup script

Consumer projects can run the helper script from the `.opencode` submodule to check Caveman, CodeGraph, and RTK readiness:

```bash
bash .opencode/scripts/setup-opencode-tools.sh
```

The script is submodule-aware:

- It checks tool wrapper files inside `.opencode`.
- It checks or initializes `.codegraph/` in the consumer project root.
- It does not modify global OpenCode configuration unless `--configure-global` is passed.

Useful modes:

```bash
bash .opencode/scripts/setup-opencode-tools.sh --strict
bash .opencode/scripts/setup-opencode-tools.sh --init-codegraph
bash .opencode/scripts/setup-opencode-tools.sh --configure-global
```

Use `--configure-global` only as an explicit operator step because it changes files outside the repository.

## How to use it in other projects

Consumer projects install this repository as a submodule at `.opencode`:

```bash
git submodule add <repo-url> .opencode
git submodule update --init --recursive .opencode
```

OpenCode can then use the reusable agents from the submodule:

- `.opencode/agents/orchestrator.md`
- `.opencode/agents/planner.md`
- `.opencode/agents/spec-hardener.md`
- `.opencode/agents/implementer.md`
- `.opencode/agents/verifier.md`
- `.opencode/agents/archiver.md`
- `.opencode/agents/subagent/*.md`

OpenCode can also use wrapper skills from the submodule, including:

- `.opencode/skill/codegraph/SKILL.md`
- `.opencode/skill/rtk/SKILL.md`

Recommended consumer flow:

1. Keep OpenSpec as the source of truth for the change (`proposal`, `design`, `specs`, `tasks`).
2. Write every OpenSpec artifact in English, regardless of the conversation language, to keep shared specs portable and token-efficient.
3. Define implementation-ready hard specs before coding: no unresolved CRITICAL ambiguity, deterministic requirements/scenarios, traceable tasks, and explicit verification evidence.
4. Use `spec-hardener.md` after drafting artifacts and before implementation to establish hard-spec readiness.
5. Under gitflow, each OpenSpec change should map to its own `feature/<change-name>` branch created from `develop`.
6. Choose the right pack for the stack (`packs/go-aws`, `packs/java-onprem`, `packs/angular`, or `packs/generic`).
7. Run implementation with TDD evidence.
8. Verify against global thresholds.
9. If the flow needs to leave local, generate handoff for an external operator using `governance/operator-handoff-template.md`.

## OpenSpec spec hardening

Use `agents/spec-hardener.md` after a change has drafted OpenSpec artifacts and before implementation starts. The agent reviews `proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md`, then asks targeted questions about ambiguity, missing decisions, weak acceptance criteria, and incomplete scenario coverage. Implementation should not start until the change has hard specs or any remaining gaps are explicitly accepted as non-critical.

Example bundle:

```bash
./.opencode/opencode-runner.sh bundle \
  --agent spec-hardener \
  --change <change-name> \
  --skills openspec-workflow \
  --user-prompt "Harden this OpenSpec change before implementation"
```

The hardener does not implement code. It edits OpenSpec artifacts only after the user answers the questions or explicitly asks for artifact updates.

## Caveman in consumer projects

Caveman skills live in this module under `.agents/skills`. When this repository is installed as `.opencode`, those skills are available at:

- `.opencode/.agents/skills/caveman/SKILL.md`
- `.opencode/.agents/skills/cavecrew/SKILL.md`
- `.opencode/.agents/skills/caveman-review/SKILL.md`
- `.opencode/.agents/skills/caveman-commit/SKILL.md`
- `.opencode/.agents/skills/caveman-compress/SKILL.md`
- `.opencode/.agents/skills/caveman-help/SKILL.md`
- `.opencode/.agents/skills/caveman-stats/SKILL.md`

If the OpenCode runtime exposes these entries in `available_skills`, agents should load them through the normal skill loader.

If the runtime does not expose them, agents should read and apply the local `SKILL.md` file from `.opencode/.agents/skills/<name>/SKILL.md` instead of reporting the skill as missing. This keeps Caveman available to projects that consume this repository as a submodule even when the runtime skill registry is narrower than the files present in the workspace.

## Create or extend capability

- New agent: add file in `agents/` and register metadata in `core/agent-catalog.yaml`.
- New skill: create `skill/<name>/manifest.yaml` + `SKILL.md` and validate its routing/pack integration.
- New stack pack: create `packs/<stack>/pack.yaml` + `README.md` with verification and TDD commands.
- New global rule: update `core/workflow-contract.md` and validation scripts in `scripts/validate/`.
- New quality metric: update `evals/config/global-thresholds.json` and `scripts/evals/run-all.sh`.

## Notes

- This repo does not replace the operator for non-local environments.
- Its focus is maximizing quality and productivity in local development with OpenSpec traceability.
