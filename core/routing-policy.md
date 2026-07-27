# Intent-First Routing Policy

Routing is deterministic and intent-first.

## Primary Selector: Workflow Intent

1. Planning artifacts (`proposal`, `design`, `specs`, `tasks`) -> `planner.md`.
2. Spec hardening, ambiguity review, or turning drafted OpenSpec artifacts into an implementation-ready hard spec -> `spec-hardener.md`.
3. Code implementation from `tasks.md` -> `implementer.md`.
4. Readiness checks and traceability -> `verifier.md`.
5. Archive/closure -> `archiver.md`.
6. Documentation requests -> `subagent/code-documentation-subagent.md`.
7. Design-document requests -> `subagent/design-doc-subagent.md`.
8. Feature iteration/refactor -> `subagent/feature-iteration-subagent.md`.
9. Pulumi/IaC requests -> `subagent/pulumi-infrastructure-subagent.md`.
10. TDD test planning/creation -> `subagent/tdd-tests-subagent.md`.
11. Semantic code exploration, call graph questions, impact analysis, or affected-test discovery -> apply `$codegraph` when CodeGraph MCP tools are available.
12. Shell commands with large or noisy output -> apply `$rtk` when RTK is installed or the OpenCode RTK hook is active.
13. n8n workflow design/debug/validation requests -> apply `$n8n-gateway` then `$n8n-mcp-tools-expert`.

## Secondary Selector: Stack Pack

After intent is resolved, apply the active stack pack:

- `packs/go-aws`
- `packs/java-onprem`
- `packs/angular`
- `packs/generic`

Stack pack influence is limited to constraints, command sets, and test strategy.

## Single-entrypoint orchestration

`orchestrator.md` is the default interactive entrypoint. Routing selects the phase contract to apply, but it does not require a manual switch to `planner.md`, `implementer.md`, `verifier.md`, or `archiver.md` when the orchestrator can execute the selected local workflow safely.

OpenSpec artifact language is global: write and maintain `proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md` in English regardless of the user's conversation language. Consumer projects that include this repository as a submodule inherit this rule through the shared agents and skills.

Hard-spec readiness is mandatory for OpenSpec-backed implementation: before coding, artifacts must resolve CRITICAL ambiguity, contain deterministic requirements/scenarios, and define concrete tasks plus verification evidence. If readiness is unclear, route to `spec-hardener.md` first.

Use phase agents and subagents as contracts or targeted helpers:

- Apply `planner.md`, `implementer.md`, `verifier.md`, and `archiver.md` rules according to the selected phase.
- Apply `spec-hardener.md` during planning to define hard specs and resolve ambiguity before implementation.
- Invoke specialized subagents only when expertise, parallelism, context reduction, or a distinct deliverable justifies the handoff.
- Keep the orchestrator responsible for final decisions, command evidence, touched files, blockers, and missing decisions.

## OpenSpec spec hardening

Route to `spec-hardener.md` when the user asks to harden, polish, de-risk, clarify, or review drafted OpenSpec artifacts before implementation.

Trigger examples:

- "harden this spec"
- "make this a hard spec"
- "review OpenSpec ambiguity"
- "ask questions before implementation"
- "find unclear requirements"
- "turn this change into an implementation-ready spec"

Default behavior: ask targeted clarification questions first. Do not edit artifacts until the user answers or explicitly asks for artifact updates.

## Angular frontend/UI requests

For Angular frontend/UI requests:

- Keep routing intent-first and select `implementer.md` for implementation work.
- Apply the Angular pack as the active stack context.
- Activate `$web-ui-ux` for frontend/UI, responsive, visual polish, component, layout, and design-system intent.
- Exclude `$backend-design` for frontend-only Angular work.
- Allow `$backend-design` only when backend scope is explicit in the request.

## Node DeFi arbitrage requests

For Node.js/TypeScript requests involving DeFi arbitrage, DEX integrations, blockchain RPC, transaction simulation or execution, MEV, or on-chain trading risk:

- Keep routing intent-first and apply the selected phase contract.
- Use the generic stack pack unless a dedicated Node/DeFi pack is introduced.
- Activate `$node-defi-arbitrage` for architecture, numeric correctness, reliability, testing, and live-execution safety.
- Exclude `$backend-design` unless the request explicitly also changes the Go/AWS backend.
- Treat wallet funding, secret provisioning, deployment, transaction signing, and public-network broadcasting as operator actions.

## Repository-local skill fallback

The runtime `available_skills` registry can be narrower than the skills imported in this module. When a route asks for a module-owned skill such as `$web-ui-ux` or `$node-defi-arbitrage`, first prefer the runtime skill loader. If the runtime registry does not list it, but a repository-local skill file exists at `skill/<name>/SKILL.md` or `.opencode/skill/<name>/SKILL.md`, load and apply that file as the specialization.

For `$codegraph`, also use the repository-local skill fallback at `skill/codegraph/SKILL.md` or `.opencode/skill/codegraph/SKILL.md`. This fallback only provides guidance; CodeGraph still requires the MCP tools to be installed and the consumer project to have a `.codegraph/` index.

For `$rtk`, also use the repository-local skill fallback at `skill/rtk/SKILL.md` or `.opencode/skill/rtk/SKILL.md`. This fallback only provides guidance; RTK still requires the CLI and OpenCode hook/plugin to be installed when command output rewriting is expected.

For Caveman skills (`$caveman`, `$cavecrew`, `$caveman-review`, `$caveman-commit`, `$caveman-compress`, `$caveman-help`, `$caveman-stats`), also check `.agents/skills/<name>/SKILL.md` and `.opencode/.agents/skills/<name>/SKILL.md`. Projects that consume this repository as a `.opencode` submodule can use those local files even when the runtime does not list them in `available_skills`.

When the user requests Caveman or token-saving mode for the session, apply `$caveman` to reasoning/status updates and conversational user output unless clarity, safety, or irreversible-action wording requires normal prose. Do not apply Caveman prose to OpenSpec artifacts: keep `proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md` as normal English technical prose.

Only emit `missing_specialization` when neither the runtime registry nor the repository-local skill file provides the requested specialization.

## Optional CodeGraph Routing

Apply `$codegraph` when CodeGraph MCP tools are available and intent is codebase discovery or graph analysis.

Trigger examples:

- "how does this flow work?"
- "find callers of this function"
- "what breaks if I change this API?"
- "which tests are affected by these files?"
- "where is this route handled?"

Default behavior when CodeGraph MCP tools are unavailable: fall back to Glob/Grep/Read and, when useful, tell the user to run `codegraph install --target=opencode` and `codegraph init -i`.

## Optional RTK Routing

Apply `$rtk` when RTK is available and intent involves Bash commands with large, noisy, or repetitive output.

Trigger examples:

- "show git diff/status/log"
- "run tests and inspect failures"
- "run build/lint/typecheck"
- "inspect Docker/Kubernetes/AWS logs"
- "search/list/read through shell output compactly"

Default behavior when RTK is unavailable: run normal commands and continue. When useful, tell the user to install RTK and run `rtk init -g --opencode`.

## Optional n8n Skill Routing

Apply n8n skills only when intent is explicit or strongly implied.

Trigger examples:

- "build an n8n workflow"
- "fix n8n validation errors"
- "configure n8n node expressions"
- "use n8n-mcp tools"

Default behavior for non-n8n requests: do not load n8n skills.

## Fallback Policy

If no specialized route is available:

1. Route to `orchestrator.md` in safe mode.
2. Enforce core workflow contract and local-only boundary.
3. Emit a decision gap with required specialization.

Required fallback output field:

`missing_specialization: <what is missing and why it matters>`
