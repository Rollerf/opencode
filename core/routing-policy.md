# Intent-First Routing Policy

Routing is deterministic and intent-first.

## Precondition: Resolve the Stack Pack

Before phase work, resolve one pack from an explicit selection, compatible `.opencode-project.yaml`, or project evidence evaluated against `packs/*/pack.yaml` detection markers. If multiple packs match, ask the operator to confirm one. If none match, ask the operator to confirm `generic` or request a new pack definition. Do not silently select a pack or begin mutating work while the decision is unresolved.

## Primary Selector: Workflow Intent

1. Planning artifacts (`proposal`, `design`, `specs`, `tasks`) -> `$openspec-planning`.
2. Spec hardening, ambiguity review, or turning drafted OpenSpec artifacts into an implementation-ready hard spec -> `$openspec-spec-hardening`.
3. Code implementation and feature iteration from `tasks.md` -> `$openspec-implementation`.
4. Readiness checks and traceability -> `$openspec-verification`.
5. Archive/closure -> `$openspec-archive`.
6. Documentation requests -> `subagent/code-documentation-subagent.md`.
7. Design-document requests -> `subagent/design-doc-subagent.md`.
8. Pulumi/IaC requests -> `subagent/pulumi-infrastructure-subagent.md`.
9. TDD test planning/creation -> `subagent/tdd-tests-subagent.md`.
10. Semantic code exploration, call graph questions, impact analysis, or affected-test discovery -> apply `$codegraph` when CodeGraph MCP tools are available.
11. Shell commands with large or noisy output -> apply `$rtk` when RTK is installed or the OpenCode RTK hook is active.
12. n8n workflow design/debug/validation requests -> apply `$n8n-gateway` then `$n8n-mcp-tools-expert`.

## Secondary Selector: Stack Pack

After phase selection, apply the already resolved stack pack:

- `packs/go-aws`
- `packs/java-onprem`
- `packs/angular`
- `packs/astro`
- `packs/generic`

Stack pack influence is limited to constraints, command sets, and test strategy.

## Single-entrypoint orchestration

`orchestrator.md` is the only phase-owning interactive entrypoint. Routing loads exactly one native phase-contract skill in the same session.

OpenSpec artifact language is global: write and maintain `proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md` in English regardless of the user's conversation language. Consumer projects that include this repository as a submodule inherit this rule through the shared agents and skills.

Hard-spec readiness is mandatory for OpenSpec-backed implementation: before coding, artifacts must resolve CRITICAL ambiguity, contain deterministic requirements/scenarios, and define concrete tasks plus verification evidence. If readiness is unclear, apply `$openspec-spec-hardening` first.

Use phase skills and subagents as contracts or targeted helpers:

- Load exactly one phase-contract skill according to `core/phase-contract-catalog.yaml`.
- Apply `$openspec-spec-hardening` during planning to resolve ambiguity before implementation.
- Invoke specialized subagents only when expertise, parallelism, context reduction, or a distinct deliverable justifies the handoff.
- Keep the orchestrator responsible for final decisions, command evidence, touched files, blockers, and missing decisions.

## OpenSpec spec hardening

Apply `$openspec-spec-hardening` when the user asks to harden, polish, de-risk, clarify, or review drafted OpenSpec artifacts before implementation.

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

- Keep routing intent-first and select `$openspec-implementation` for implementation work.
- Apply the Angular pack as the active stack context.
- Activate `$web-ui-ux` for frontend/UI, responsive, visual polish, component, layout, and design-system intent.
- Exclude `$backend-design` for frontend-only Angular work.
- Allow `$backend-design` only when backend scope is explicit in the request.

## Astro public-web requests

For requests under the `astro` pack:

- Treat pack selection as explicit SEO intent and always activate `$seo-expert`.
- Activate `$web-ui-ux` for frontend/UI, responsive, visual, component, consent-interface, and accessibility intent.
- Exclude `$backend-design` for frontend-only work; include it only when the request explicitly changes a Go/AWS backend in the same scope.
- Keep public indexable and CRM-backed primary content SSG by default; mixed or server rendering requires explicit adapter, compute, routing, caching, security, SEO, accessibility, and verification decisions.
- Require generated TypeScript API clients from backend-owned OpenAPI contracts and reject drift before completion.
- Require default-denied consent and cookie-policy/browser evidence when Google Analytics is enabled.
- Require WCAG 2.2 AA as the technical accessibility target, with automated plus manual post-change evidence and project-owned legal applicability review.
- Keep `/llms.txt` and other AI discovery surfaces synchronized with canonical published content without treating them as access controls or provider guarantees.

## Node DeFi arbitrage requests

For Node.js/TypeScript requests involving DeFi arbitrage, DEX integrations, blockchain RPC, transaction simulation or execution, MEV, or on-chain trading risk:

- Keep routing intent-first and apply the selected phase contract.
- Require explicit confirmation of `generic` unless a dedicated Node/DeFi pack is introduced and detected.
- Activate `$node-defi-arbitrage` for architecture, numeric correctness, reliability, testing, and live-execution safety.
- Exclude `$backend-design` unless the request explicitly also changes the Go/AWS backend.
- Treat wallet funding, secret provisioning, deployment, transaction signing, and public-network broadcasting as operator actions.

## SEO requests

For explicit SEO intent involving metadata, structured data, indexing, crawlability, canonical URLs, hreflang, robots directives, sitemaps, redirects, search snippets, Core Web Vitals, or content optimization for search visibility:

- Keep phase selection primary and activate `$seo-expert` as a specialization overlay.
- Do not activate SEO guidance solely because a task is web-facing, frontend-related, backend-related, or documentation-related.
- Treat selection of `packs/astro` as explicit SEO intent because that pack is restricted to public SEO-dependent websites.
- Combine `$seo-expert` with `$web-ui-ux` when SEO changes also affect page hierarchy, semantics, responsive presentation, or UX.
- Combine `$seo-expert` with `$playwright-cli` when rendered metadata, browser redirects, navigation, or executable browser evidence must be inspected.
- Reject deceptive or black-hat tactics and never promise ranking outcomes.

### Repository-local SEO fallback

If `$seo-expert` is not in runtime `available_skills` but `skill/seo-expert/SKILL.md` or `.opencode/skill/seo-expert/SKILL.md` exists, load and apply that repository-local file. Emit `missing_specialization` only when neither source is available.

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
