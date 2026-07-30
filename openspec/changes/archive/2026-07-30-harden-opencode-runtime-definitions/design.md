## Context

The repository is both a source module and a distributable `.opencode` submodule. It currently tests that distribution model by embedding itself as `.opencode`, which creates recursive submodule metadata and leaves the running copy behind the source copy. The custom runner also conflates the module location with the consumer project root, lists skills from manifests even when the native OpenCode loader rejects their `SKILL.md`, and eagerly concatenates all references and change artifacts.

The advertised single-entrypoint model has a second mismatch: phase contracts are defined as separate primary agents, but a primary orchestrator cannot load another primary agent's prompt by naming its Markdown file. Routing rules, catalog metadata, and runner behavior have consequently drifted. Shared subagents also embed Go/AWS assumptions despite cross-stack routing.

OpenCode 1.17.19 provides native debug commands (`opencode debug skill`, `opencode debug agent`, and `opencode debug config`) that can validate a disposable consumer fixture. Available model identifiers include `openai/gpt-5.6-sol` and `openai/gpt-5.6-luna`.

## Goals / Non-Goals

**Goals:**

- Make source validation representative of consumer runtime discovery.
- Keep one interactive orchestrator while making every phase contract explicitly loadable.
- Make routing, model selection, step limits, stack composition, and delegation deterministic.
- Reduce default bundle context without selecting an arbitrary maximum token budget.
- Keep repository-owned wrappers valid while preserving external submodule ownership.

**Non-Goals:**

- Migrate edit, Bash, or other broad tool access to least-privilege permissions. That remains a separately tracked security hardening change.
- Set a pass/fail limit for bundle bytes or estimated tokens.
- Edit upstream files in `third_party/n8n_skills`.
- Add a new stack pack or change application architecture guidance.

## Decisions

### 1. Remove self-consumption and test distribution through a fixture

- **Decision:** Remove the `.opencode` entry and gitlink from `.gitmodules` while retaining `third_party/n8n_skills`. Add a disposable consumer fixture created under a temporary directory by validation scripts.
- **Rationale:** A source repository cannot safely validate itself through a recursively declared submodule. A fixture can pin the module under `<fixture>/.opencode`, add consumer-owned OpenSpec artifacts and configuration outside the module, and assert actual path resolution without stale copies.
- **Alternative considered:** Keep the self-submodule and update it after every source edit. Rejected because it remains recursive, easy to forget, and impossible to make source and runtime atomic.

### 2. Keep module and project roots independent

- **Decision:** Introduce explicit runner variables:
  - `MODULE_DIR`: the directory containing `agents/`, `skill/`, `packs/`, and module scripts.
  - `PROJECT_ROOT`: the consumer root; it is the parent when `MODULE_DIR` is named `.opencode`, otherwise it is the source repository root.
- **Rationale:** Runtime definitions belong to the module, while OpenSpec changes, project configuration, and project commands belong to the consumer.
- **Alternative considered:** Infer one `ROOT_DIR` from the presence of `openspec/`. Rejected because the module itself also contains OpenSpec artifacts.

### 3. Treat all root wrappers as repository-owned skills

- **Decision:** Add native frontmatter to every `skill/*/SKILL.md` owned by this repository and require the frontmatter name to match the directory and manifest. The n8n files under `skill/n8n-*` are owned wrappers and will be fixed; `third_party/n8n_skills/**` remains read-only.
- **Rationale:** Native OpenCode discovery reads `SKILL.md` metadata, not the custom manifest. Ownership is determined by the Git boundary, not by whether a wrapper points to upstream content.
- **Alternative considered:** Teach only the custom runner to understand invalid skills. Rejected because runtime and runner inventory would still diverge.

### 4. Replace phase agents with phase-contract skills

- **Decision:** Keep `orchestrator.md` as the only phase-owning primary agent. Replace `planner.md`, `spec-hardener.md`, `implementer.md`, `verifier.md`, and `archiver.md` with these native skills:
  - `openspec-planning`
  - `openspec-spec-hardening`
  - `openspec-implementation`
  - `openspec-verification`
  - `openspec-archive`

  `openspec-workflow` remains the common lifecycle skill. The runner always selects the orchestrator and adds exactly one phase-contract skill for phase operations.
- **Rationale:** Skills can be explicitly loaded into the current orchestrator session. Separate primary agents cannot be imported by prose references and contradict the single-entrypoint contract.
- **Alternative considered:** Convert phase owners to subagents. Rejected because the operator explicitly wants direct single-entrypoint execution and because delegating every phase adds context and coordination cost.

### 5. Use a deterministic routing pipeline

- **Decision:** Before phase work starts, the orchestrator resolves one pack through this precedence:
  1. Use an explicit `--pack` or operator selection after validating that the pack exists.
  2. Use a previously confirmed `.opencode-project.yaml` selection when current project evidence remains compatible.
  3. Inspect the consumer project against structured `detection.required` markers in every non-generic `pack.yaml`.
  4. If exactly one non-generic pack matches, select it and report the evidence.
  5. If multiple packs match, stop before phase execution, show the candidates and evidence, and ask the operator to confirm one.
  6. If no non-generic pack matches, stop before phase execution and ask the operator either to explicitly confirm `generic` or request a new pack definition. The orchestrator must not silently choose `generic`.

  Supported detection markers are `path_exists` and `file_contains`. Every marker declares `type`, `path`, and, for `file_contains`, a literal `value`. A non-generic pack matches only when all `detection.required` markers match. The `generic` pack is confirmation-only and has no automatic match rule.

  After pack resolution, task routing executes in this order:
  1. Select one phase contract.
  2. Apply the resolved stack pack.
  3. Add zero or more skill overlays based on explicit intent.
  4. Delegate a bounded unit only when the helper produces a distinct deliverable, supplies specialized expertise, enables safe parallel work, or materially reduces the orchestrator context.

  Specialized helpers supplement the phase owner and never replace phase selection. Ambiguous phase requests require clarification or the safest non-mutating phase. Routing references must resolve through catalogs.
- **Rationale:** Evidence-based pack resolution prevents old stack assumptions from moving into generic agents, while the task pipeline removes peer-route collisions between planning, implementation, documentation, tests, Pulumi, and refactoring.
- **Alternative considered:** Continue keyword-first peer routing. Rejected because overlapping terms cannot provide deterministic precedence.

### 6. Assign Sol and Luna by responsibility

- **Decision:** Use this initial model and step policy:

  | Runtime role | Model | Steps |
  | --- | --- | ---: |
  | `orchestrator` | `openai/gpt-5.6-sol` | 40 |
  | `subagent/code-documentation-subagent` | `openai/gpt-5.6-luna` | 10 |
  | `subagent/design-doc-subagent` | `openai/gpt-5.6-luna` | 12 |
  | `subagent/pulumi-infrastructure-subagent` | `openai/gpt-5.6-sol` | 20 |
  | `subagent/tdd-tests-subagent` | `openai/gpt-5.6-sol` | 20 |

  Leaf subagents receive `permission.task: deny` to prevent nested delegation. The broader migration from deprecated `tools` to least-privilege permissions remains deferred.
- **Rationale:** Luna handles bounded prose-oriented deliverables at lower cost, while Sol owns final decisions and code-changing or high-risk work. Step limits prevent unbounded loops while leaving the orchestrator enough room for multi-phase local work.
- **Alternative considered:** Use Luna for every subagent. Rejected because tests and infrastructure require stronger reasoning and failure analysis. Using Sol everywhere was rejected because it provides no cost control for routine documentation.

### 7. Make bundles selective and diagnostic

- **Decision:** Change bundle behavior as follows:
  - Include the user goal before generated context.
  - Make skill references opt-in through `--references`; retain `--no-references` as a compatibility alias.
  - Include the selected `pack.yaml` and reject unknown pack names.
  - Select OpenSpec artifacts by phase: planning includes all existing artifacts; implementation includes design, specs, and tasks; verification includes design, specs, and tasks; archive includes proposal, specs, tasks, and Markdown files under `evidence/` when present.
  - Use a dynamically sized Markdown fence that is longer than any backtick run in the embedded content.
  - Print line count, byte count, and a clearly labeled approximate token estimate after generation, but do not enforce a threshold.
- **Rationale:** Default bundles should be useful without eagerly duplicating every reference. Diagnostics establish a measurement baseline before a future token budget is selected.
- **Alternative considered:** Set an immediate maximum token count. Rejected because the operator requested evidence before choosing a reference value.

### 8. Reduce and neutralize shared subagents

- **Decision:** Retain only documentation, design-document, Pulumi, and TDD subagents. Remove `feature-iteration-subagent` and absorb its incremental implementation workflow into `openspec-implementation`. Remove Go/Lambda/API Gateway/RFC 7807/Pulumi assumptions from retained cross-stack documentation, design, and TDD helpers. Stack-specific rules are supplied only by the resolved pack and specialized skills. The TDD helper owns test planning and test edits; production changes remain with the orchestrator unless explicitly delegated. Feature iteration under the implementation skill may update tests when behavior changes and must not weaken valid tests.
- **Rationale:** Documentation and design can produce bounded independent deliverables with Luna; Pulumi and TDD provide distinct specialist work with Sol. Feature iteration directly overlaps phase implementation and creates avoidable editing and context conflicts.
- **Alternative considered:** Duplicate every helper per stack. Rejected because it multiplies prompts and drift.

### 9. Make catalogs executable contracts

- **Decision:** `core/agent-catalog.yaml` catalogs only actual runtime agents, includes the orchestrator, stores `runtime_name`, model profile, step limit, path, and delegation scope, and uses slash-qualified names for nested agents. Add `core/phase-contract-catalog.yaml` for phase skill names and completion criteria. Runner and validators consume these catalogs.
- **Rationale:** Catalog metadata that no runtime code reads cannot prevent drift.
- **Alternative considered:** Remove the catalog and keep routing only in prose. Rejected because structured catalogs are useful for deterministic validation and bundle assembly.

### 10. Use structured validation plus native debug commands

- **Decision:** Add `scripts/validate/runtime-definitions.mjs` using the `yaml` npm package, with deterministic cases under `scripts/validate/fixtures/runtime-definitions/`. It validates frontmatter, manifests, catalogs, model/step policy, referenced paths, routing references, pack schema, self-submodule absence, and bundle defaults. A temporary consumer fixture invokes `opencode debug skill`, `opencode debug agent orchestrator`, and `opencode debug config`, then exercises runner bundles against consumer-owned OpenSpec artifacts.
- **Rationale:** String-presence checks cannot prove parseability or runtime discovery. Native debug commands provide integration evidence against the installed OpenCode version.
- **Alternative considered:** Expand Bash substring checks. Rejected because comments and malformed YAML can satisfy them.

### 11. Provide an explicit consumer configuration template

- **Decision:** Add `core/templates/opencode.consumer.json` with `default_agent: "orchestrator"`, schema declaration, and documented safe merge instructions. Also add `core/templates/opencode-project.yaml` as the consumer-owned record for a confirmed `default_pack` and optional `allowed_packs`. The orchestrator still validates the confirmed pack against current project evidence and asks again when evidence conflicts. The fixture copies these templates to its consumer root. Installation documentation states that the consumer, not the module, owns final provider, permission, and confirmed pack configuration.
- **Rationale:** A submodule cannot safely overwrite an existing consumer configuration, but the advertised default entrypoint must be reproducibly configurable.
- **Alternative considered:** Place `opencode.json` at the module source root. Rejected because that configuration would also apply when developing the module directly, where root `agents/` are not native project agent paths.

## Risks / Trade-offs

- [Existing users invoke removed phase agent names] -> Provide a migration table and make the runner map phase commands to the orchestrator plus phase skill. Mark removal as breaking.
- [Step limits stop an unusually complex task] -> The orchestrator reports an incomplete result and the operator can continue the same session; limits are centralized and can be tuned from evidence.
- [Native debug output changes across OpenCode versions] -> Pin the supported minimum version in fixture expectations and parse stable identifiers rather than presentation formatting.
- [Temporary consumer fixture misses Git submodule behavior] -> Validate both copied-module and submodule-shaped directory layouts without recursively cloning the repository.
- [References omitted by default hide useful detail] -> Print available reference names in the bundle and support explicit `--references` selection.
- [Permission risk remains] -> Keep the known deprecated broad tool policy visible as a non-blocking validator warning and open a dedicated follow-up change.
- [Model availability differs in consumers] -> Validate configured model identifiers against `opencode models openai` during environment readiness checks and report a clear fallback requirement instead of silently changing models.
- [Stack evidence matches multiple packs] -> Stop before phase work, show matching markers, and require operator confirmation; persist the accepted selection only with operator approval.
- [No existing pack represents the project] -> Report the inspected evidence and request a new pack definition or explicit use of `generic` instead of silently applying unrelated constraints.

## Migration Plan

1. Add structured validators and consumer fixture first so subsequent definition changes have runtime coverage.
2. Correct repository-owned skill frontmatter and catalog metadata.
3. Introduce phase-contract skills and update orchestrator and runner routing while old phase agents still exist.
4. Update runner root resolution, pack inclusion, selective bundling, and diagnostics.
5. Add pack detection metadata and pre-work inference/confirmation, then reduce and neutralize retained subagents and apply the Sol/Luna step policy.
6. Switch validators and documentation to the new contracts.
7. Remove obsolete phase agents and the self-referential `.opencode` submodule last.
8. Run native fixture discovery, all validators, evaluation harness, and strict OpenSpec validation.

Rollback consists of reverting the feature branch before release. No production or external lifecycle action is required.

## Open Questions

- None. Least-privilege edit/Bash permission migration and a numeric token budget are explicitly deferred rather than unresolved.
