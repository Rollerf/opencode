## 1. Structured Validation Foundation

- [x] 1.1 Add the `yaml` npm dependency and `scripts/validate/runtime-definitions.mjs` to parse agent frontmatter, skill frontmatter, manifests, agent and phase catalogs, and pack files; make malformed or mismatched definitions fail with exact paths.
- [x] 1.2 RED: add failing cases under `scripts/validate/fixtures/runtime-definitions/` for missing skill frontmatter, directory/name/manifest mismatch, duplicate catalog IDs, unresolved runtime paths, invalid phase mappings, invalid pack detection markers, self-submodule declarations, and tracked `Zone.Identifier` files.
- [x] 1.3 GREEN: implement the minimum validation rules needed to pass the new fixtures while keeping deprecated `tools` declarations as explicit non-blocking warnings.
- [x] 1.4 Integrate the structured validator into `scripts/validate/run-all.sh` and retain existing policy validators only where they assert behavior not covered structurally.

## 2. Distribution and Native Discovery

- [x] 2.1 RED: create a disposable consumer fixture test that places the module once at `<fixture>/.opencode`, creates consumer-owned OpenSpec artifacts and configuration, and demonstrates current native skill, default-agent, and project-root failures.
- [x] 2.2 Add valid `name` and activation `description` frontmatter to every repository-owned `skill/*/SKILL.md`, including the repository-owned n8n wrappers; assert that `third_party/n8n_skills` has no content changes.
- [x] 2.3 Add `core/templates/opencode.consumer.json` with `$schema` and `default_agent: "orchestrator"`, plus `core/templates/opencode-project.yaml` for operator-confirmed `default_pack` and optional `allowed_packs`; document safe merge and persistence behavior.
- [x] 2.4 Add `.codegraph/` and `*:Zone.Identifier` to repository ignore policy, remove tracked `Zone.Identifier` sidecars, and verify CodeGraph indexes remain local caches.
- [x] 2.5 Remove the self-referential `.opencode` gitlink and `.gitmodules` entry while preserving the external `third_party/n8n_skills` submodule.
- [x] 2.6 GREEN: run `opencode debug skill`, `opencode debug agent orchestrator`, and `opencode debug config` in the fixture and assert the repository-owned inventory and default entrypoint resolve natively.

## 3. Phase Contracts and Deterministic Routing

- [x] 3.1 RED: add routing tests for planning versus standalone design, implementation plus documentation, Pulumi verification, feature iteration through the implementation skill, TDD delegation, unknown specialization fallback, and exactly-one-phase selection.
- [x] 3.2 Create native `openspec-planning`, `openspec-spec-hardening`, `openspec-implementation`, `openspec-verification`, and `openspec-archive` skills by moving the current phase contracts without losing entry criteria, completion criteria, evidence requirements, English-artifact policy, hard-spec readiness, TDD, or local-only rules.
- [x] 3.3 Add `core/phase-contract-catalog.yaml` and update the orchestrator to execute phase -> stack -> specialization -> optional delegation in that order, loading exactly one phase skill.
- [x] 3.4 Update `core/agent-catalog.yaml` to include the orchestrator, slash-qualified `runtime_name`, source path, model, steps, delegation scope, expected inputs, and expected outputs for actual runtime agents only.
- [x] 3.5 Update runner phase resolution to always select the orchestrator plus the cataloged phase skill, then remove the obsolete planner, spec-hardener, implementer, verifier, and archiver primary-agent files.
- [x] 3.6 GREEN: make all routing and catalog fixtures pass and verify legacy `opencode-runner.sh phase <phase>` syntax still resolves the new phase contract.

## 4. Sol/Luna and Subagent Responsibility Policy

- [x] 4.1 Configure `orchestrator` with `model: openai/gpt-5.6-sol` and `steps: 40`.
- [x] 4.2 Configure documentation and design-document subagents with `model: openai/gpt-5.6-luna` and step limits `10` and `12` respectively.
- [x] 4.3 Configure Pulumi and TDD subagents with `model: openai/gpt-5.6-sol`, `steps: 20`, and `permission.task: deny`; also deny nested delegation for Luna leaf subagents.
- [x] 4.4 Remove `feature-iteration-subagent`, absorb its incremental workflow into `openspec-implementation`, and remove Go, Lambda, API Gateway, RFC 7807, `apiManagment.yml`, Pulumi, and repository-path assumptions from retained cross-stack subagents.
- [x] 4.5 Resolve test ownership by making the TDD helper responsible for test design and test edits, keeping production changes with the orchestrator unless explicitly delegated, and requiring feature iteration under the implementation skill to update but not weaken valid tests.
- [x] 4.6 Add validation for the exact Sol/Luna role matrix and step limits, and document deprecated broad edit/Bash `tools` configuration as a deferred follow-up rather than changing it in this change.

## 5. Runner Root, Pack Inference, and Composition

- [x] 5.1 RED: add source-layout and consumer-layout tests proving that module definitions and consumer OpenSpec artifacts resolve from different roots, plus fixtures for explicit, confirmed, uniquely inferred, ambiguous, unsupported, and stale pack selections.
- [x] 5.2 Replace the single `ROOT_DIR` inference with explicit `MODULE_DIR` and `PROJECT_ROOT` resolution and update agent, skill, pack, change, output, and command paths accordingly.
- [x] 5.3 Add valid `detection.required` markers to every non-generic pack using only `path_exists` and literal `file_contains`; keep `generic` confirmation-only.
- [x] 5.4 Implement pack resolution precedence: explicit selection, compatible `.opencode-project.yaml`, then project-evidence inference; block phase work and request confirmation for multiple matches, or explicit generic/new-pack definition for no matches.
- [x] 5.5 Validate the resolved pack name and embed its constraints, verification commands, TDD commands, and prohibited actions in generated runtime context.
- [x] 5.6 GREEN: verify source and consumer bundles resolve expected roots, unique inference succeeds with evidence, ambiguous or unsupported inference blocks work, stale confirmations are rejected, and unknown explicit packs fail actionably.

## 6. Context-Selective Bundle Generation

- [x] 6.1 RED: add bundle tests for prompt-first ordering, default reference omission, explicit reference inclusion, phase-relevant artifact selection, duplicate prevention, embedded backticks, and context-size diagnostics.
- [x] 6.2 Make references opt-in through `--references`, preserve `--no-references` as a compatibility alias, and list available references without embedding their bodies by default.
- [x] 6.3 Place the user goal before generated context and select artifacts by phase as defined in the design and runtime-definition-integrity spec.
- [x] 6.4 Implement dynamic Markdown fences that remain valid when embedded files or user prompts contain backtick runs.
- [x] 6.5 Emit line count, byte count, and an explicitly approximate token estimate after bundle generation without introducing a pass/fail token threshold.
- [x] 6.6 GREEN: make representative generic, Angular, and Go/AWS bundle fixtures pass and record their size measurements as non-gating evaluation evidence.

## 7. Documentation and Migration

- [x] 7.1 Update README installation guidance to remove recursive self-installation, describe consumer-owned configuration, identify repository-owned wrappers versus the external n8n submodule, and document CodeGraph initialization and cache exclusion.
- [x] 7.2 Add a migration table from removed primary phase agents to orchestrator-plus-phase-skill execution; document pack inference/confirmation, the removal of feature-iteration as an agent, and retained Sol/Luna subagent responsibilities and step limits.
- [x] 7.3 Update `core/routing-policy.md`, workflow documentation, and contributor guidance so catalogs and phase skills are the source of truth and specialized subagents are optional overlays.
- [x] 7.4 Document the deferred least-privilege permission migration and the deferred numeric token-budget decision as explicit residual risks with suggested evidence to collect.

## 8. Verification Evidence

- [x] 8.1 Run `bash -n opencode-runner.sh scripts/validate/*.sh scripts/evals/*.sh` and record successful shell syntax validation.
- [x] 8.2 Run `./scripts/validate/run-all.sh` and confirm structured definitions, native fixture discovery, routing, stack composition, and bundle behavior pass.
- [x] 8.3 Run `./scripts/evals/run-all.sh` and confirm existing correctness and non-regression thresholds remain satisfied.
- [x] 8.4 Run representative source and consumer bundles for planning, implementation, verification, and archive phases; record module/project paths, pack inference evidence or confirmation, selected phase skill, pack content, references mode, artifacts, and size diagnostics.
- [x] 8.5 Run `opencode models openai` and verify `openai/gpt-5.6-sol` and `openai/gpt-5.6-luna` remain available in the target environment.
- [x] 8.6 Run `codegraph status` after repository changes, rebuild the index if needed, and verify `.codegraph/` remains ignored.
- [x] 8.7 Run `openspec validate "harden-opencode-runtime-definitions" --strict` and confirm no CRITICAL hard-spec ambiguity remains before implementation is declared ready.
