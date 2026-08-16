## Task Refinement Gate

- Status: READY
- Strict validation command: `./opencode-runner.sh phase verification --change refine-implementation-tasks --pack generic`
- Decision gaps: None
- Default executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
- Cost policy: Normal refined blocks use Luna/high to avoid spending Sol capacity on decision-free implementation; Sol execution requires an explicit override or mandatory specialist route.
- Cost metric: Use normalized standard short-context API prices in USD per 1M tokens, independent of the active ChatGPT subscription. Output tokens receive their full model-specific weight.
- Bootstrap exception: Task 1.1 uses the Sol orchestrator because the Luna/high executor does not exist until that task completes; restart OpenCode before Task 1.2 so the running session discovers the new agent.
- Executor boundary: Execute blocks in dependency order and all tasks inside a block in listed order. Stop and return to spec hardening if any step reveals a product, architecture, compatibility, security, data, infrastructure, operational, file-location, or test-strategy choice not resolved below.

## Execution Blocks

### Block B0 — Executor bootstrap

- Ordered tasks: `1.1`.
- Executor: `orchestrator` using `openai/gpt-5.6-sol`.
- External dependencies: None.
- Allowed targets: `agents/subagent/refined-task-executor-subagent.md`, `core/agent-catalog.yaml`, `scripts/validate/runtime-definitions.mjs`, and `scripts/validate/runtime-consumer-contract.sh`.
- Forbidden scope: Phase ownership, task-refinement behavior, runner behavior, evaluation thresholds, and documentation.
- Stop conditions: Any unsupported OpenCode agent field, unavailable Luna model/variant, or unresolved permission/model-policy decision.
- Completion: Runtime and consumer validation pass, then operator restarts OpenCode.
- Single-task reason: Agent must exist and the running session must restart before Luna/high can own later blocks.

### Block B1 — Refinement authoring foundation

- Ordered tasks: `1.2`, `2.1`.
- Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
- External dependencies: Block `B0` complete and OpenCode restarted.
- Allowed targets: `skill/openspec-task-refinement/`, `core/templates/tasks.md`, `openspec/config.yaml`, planning/hardening/workflow skill files, workflow phase checklist, focused validation script, and validation-suite registration named in Tasks 1.2 and 2.1.
- Forbidden scope: Orchestrator routing, implementation delegation, runner intent detection, evaluation metrics, and unrelated skills.
- Stop conditions: Any missing task/block field decision, incompatible OpenSpec artifact rule, or requirement to alter top-level phases.
- Completion: Consumer skill discovery, task-refinement contract, runtime definitions, and baseline contracts pass.

### Block B2 — Routing and runner integration

- Ordered tasks: `3.1`, `4.1`.
- Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
- External dependencies: Block `B1` complete.
- Allowed targets: `agents/orchestrator.md`, `core/routing-policy.md`, `core/workflow-contract.md`, `core/phase-contract-catalog.yaml`, `skill/openspec-implementation/SKILL.md`, `opencode-runner.sh`, and focused runner/refinement validators.
- Forbidden scope: New top-level phase, new primary agent, pack-specific behavior, evaluation thresholds, and documentation outside required contract markers.
- Stop conditions: Any route that loads more than one phase contract, silently falls back to Sol, or cannot preserve existing runner syntax.
- Completion: Focused task-refinement, runtime-definition, and runner contracts pass, and normal ready blocks cannot route to Sol silently.

### Block B3 — Cost accounting, evaluation, and documentation

- Ordered tasks: `5.1`, `5.2`, `6.1`.
- Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
- External dependencies: Block `B2` complete.
- Allowed targets: `core/model-api-prices.json`, cost calculator and validator, evaluation runner, thresholds, sample metrics, one cross-stack golden fixture, `README.md`, and contract validators named in Tasks 5.1, 5.2, and 6.1.
- Forbidden scope: Token benchmarking or Sol-versus-Luna comparison, provider pricing claims, agent implementation, phase behavior, and production lifecycle actions.
- Stop conditions: Any requirement to add token telemetry or comparative benchmarks that belong to a separate future change.
- Completion: Deterministic API-equivalent cost fixtures, evaluation promotion gate, and focused/baseline documentation contracts pass without end-to-end model benchmarking.

### Block B4 — Sol integration review

- Ordered tasks: `7.1`.
- Executor: `orchestrator` using `openai/gpt-5.6-sol`.
- External dependencies: Blocks `B0` through `B3` complete.
- Allowed targets: Task checkboxes and optional evidence Markdown under this change.
- Forbidden scope: New behavior or contract edits during final verification.
- Stop conditions: Any failed focused/full check, missing scenario traceability, incomplete block, or unreviewed Luna diff.
- Completion: Full validation, evaluation, strict OpenSpec validation, and whitespace checks pass.
- Single-task reason: Cross-block integration and final completion authority remain with Sol.

## 1. Runtime executor and task-refinement specialization

- [ ] 1.1 Bootstrap and validate the Luna/high refined-task executor.
  - Outcome: OpenCode exposes a hidden leaf implementation subagent that executes exactly one executor-ready task block with Luna high while Sol retains orchestration and final review.
  - Requirements: `implementation-task-refinement` — “Default Luna high implementation executor”; `agent-catalog-routing` — “Refined-task executor ownership”; `runtime-definition-integrity` — “Luna high refined-task executor distribution”.
  - Scenarios: “Ready normal block enters implementation”, “Refined-task executor receives bounded ownership”, “Executor runtime metadata is validated”, and “Consumer discovers the executor”.
  - Dependencies: None.
  - Execution block: `B0`.
  - Executor: Bootstrap exception — `orchestrator` using `openai/gpt-5.6-sol`; rationale: `subagent/refined-task-executor-subagent` is created by this task and is unavailable to the current running session.
  - Targets: new `agents/subagent/refined-task-executor-subagent.md`; `core/agent-catalog.yaml`; `scripts/validate/runtime-definitions.mjs` constants `MODEL_POLICY` and functions `validateAgentPolicy` and `validateAgentCatalog` for required executor variant comparison; `scripts/validate/runtime-consumer-contract.sh` expected skill/agent discovery checks.
  - RED: Add the catalog entry, centralized policy `{ model: "openai/gpt-5.6-luna", variant: "high", steps: 50, leaf: true }`, variant validation, and consumer `opencode debug agent subagent/refined-task-executor-subagent` assertions before creating the agent file. Run `node scripts/validate/runtime-definitions.mjs`; expect non-zero status with `agent-catalog-path-unresolved` for `agents/subagent/refined-task-executor-subagent.md`.
  - GREEN: Create the agent with `mode: subagent`, `model: openai/gpt-5.6-luna`, `variant: high`, `steps: 50`, `hidden: true`, `temperature: 0.1`, and permissions `task: deny`, `edit: allow`, and `bash: allow`. Its prompt must accept exactly one refined execution block, restrict edits to declared targets, execute block tasks in order, enforce RED/GREEN/REFACTOR, prohibit product or technical decisions and non-local actions, and return the specified `COMPLETED`, `PARTIAL`, or `BLOCKED` result envelope. Catalog inputs must be `execution_block_handoff`, `relevant_artifact_excerpts`, and `resolved_stack_pack`; outputs must be `structured_block_result`, `changed_files`, and `command_evidence`. Run `node scripts/validate/runtime-definitions.mjs`; expect zero errors.
  - REFACTOR: Run `bash scripts/validate/runtime-consumer-contract.sh`; expect `Runtime consumer discovery contract passed` and effective debug output containing provider `openai`, model `gpt-5.6-luna`, and variant `high`.
  - Evidence: RED unresolved-path failure; GREEN runtime-definition pass; REFACTOR consumer discovery pass.
  - Completion: Agent, catalog, and centralized policy agree on runtime name, model, variant, steps, leaf status, scope, inputs, and outputs. Report required operator action: restart OpenCode before Task 1.2 so Task-tool discovery refreshes.

- [ ] 1.2 Add and validate the repository-owned `openspec-task-refinement` skill.
  - Outcome: Consumer runtimes discover a native planning specialization that converts hard-spec-ready draft tasks into executor-ready tasks without making decisions.
  - Requirements: `implementation-task-refinement` — “Mandatory post-hard-spec task refinement”, “Executor-ready task contract”, and “Task refinement readiness gate”; `runtime-definition-integrity` — “Task-refinement specialization distribution”.
  - Scenarios: “Hard spec is ready for task refinement”, “Hard spec is not ready”, “Runtime definitions are validated”.
  - Dependencies: Task 1.1 and an OpenCode restart that makes `subagent/refined-task-executor-subagent` available in the running session.
  - Execution block: `B1`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: `scripts/validate/runtime-consumer-contract.sh` skill-discovery loop; new `skill/openspec-task-refinement/SKILL.md`; new `skill/openspec-task-refinement/manifest.yaml`.
  - RED: Add `openspec-task-refinement` to the skill-discovery loop before creating the skill. Run `bash scripts/validate/runtime-consumer-contract.sh`; expect non-zero status because `opencode debug skill` does not contain `openspec-task-refinement`.
  - GREEN: Create `SKILL.md` with entry criteria requiring complete hard-spec-ready artifacts, workflow steps that inspect repository context and rewrite `tasks.md`, fixed task and block checklists, two-to-five-task normal block sizing, justified single-task exceptions, `READY`/`BLOCKED` behavior, decision-gap escalation, minimal handoff/result envelopes, and strict validation. Create a matching manifest using the same metadata shape as `skill/openspec-planning/manifest.yaml`. Run `bash scripts/validate/runtime-consumer-contract.sh`; expect `Runtime consumer discovery contract passed`.
  - REFACTOR: Run `node scripts/validate/runtime-definitions.mjs`; expect zero errors and confirm the skill name, directory, frontmatter, and manifest agree.
  - Evidence: RED failure naming the missing skill; GREEN consumer discovery pass; REFACTOR runtime-definition pass.
  - Completion: Both new files exist, the skill is discoverable in a consumer fixture, no phase-owning agent is added, and runtime definition validation passes.

## 2. Executor-ready task authoring contract

- [ ] 2.1 Replace the minimal task template and authoring rules with the fixed executor-ready task shape.
  - Outcome: Newly refined `tasks.md` files expose a deterministic gate and give every incomplete implementation task all information required for decision-free execution.
  - Requirements: `implementation-task-refinement` — “Executor-ready task contract”, “Task refinement readiness gate”, and “Low-reasoning executor boundary”.
  - Scenarios: “Behavior-changing task satisfies the contract”, “Non-behavior task satisfies the contract”, “Task contains an implementation choice”, “All tasks are executor-ready”, “One task is not executor-ready”, and “Luna high executes a refined block”.
  - Dependencies: Tasks 1.1 and 1.2.
  - Execution block: `B1`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: new `scripts/validate/task-refinement-contract.sh`; `scripts/validate/run-all.sh`; `core/templates/tasks.md`; `openspec/config.yaml` under `rules.tasks`; `skill/openspec-planning/SKILL.md` workflow and completion criteria; `skill/openspec-spec-hardening/SKILL.md` workflow and completion criteria; `skill/openspec-workflow/SKILL.md` planning and implementation rules; `skill/openspec-workflow/references/phase-checklists.md` planning and implementation checklists.
  - RED: Create `scripts/validate/task-refinement-contract.sh`, make it executable, and assert that the template contains `Task Refinement Gate`, `Status: <READY|BLOCKED>`, `Execution Blocks`, `Block ID`, `Ordered tasks`, `Executor`, `Requirements`, `Dependencies`, `Execution block`, `Targets`, `RED`, `GREEN`, `REFACTOR`, `Evidence`, and `Completion`; also assert the planning and hardening skills distinguish draft tasks, decision closure, post-hard-spec refinement, block sizing, and compact structured envelopes. Register the script in `scripts/validate/run-all.sh`. Run `bash scripts/validate/task-refinement-contract.sh`; expect non-zero status on the current minimal template.
  - GREEN: Update the listed template, config, phase skills, workflow skill, and checklist with the exact required task/block fields and lifecycle order `draft planning -> spec hardening -> task refinement -> block implementation`. Require `TDD: Not applicable — <reason>` instead of RED/GREEN/REFACTOR only for non-behavior tasks. Put shared context once at block level. Run `bash scripts/validate/task-refinement-contract.sh`; expect `Task refinement contract passed`.
  - REFACTOR: Run `bash scripts/validate/contracts.sh`; expect `Contract validation passed` and remove duplicated prose only when all required markers and semantics remain explicit.
  - Evidence: RED template assertion failure; GREEN focused contract pass; REFACTOR baseline contract pass.
  - Completion: Template and authoring contracts use one fixed task shape, task hardening and task refinement have separate ownership, and focused plus baseline validators pass.

## 3. Routing and implementation entry gate

- [ ] 3.1 Route task-refinement intent through planning and block implementation until the refinement gate is `READY`.
  - Outcome: Orchestrator preserves exactly one phase contract, enforces task refinement before code edits, and delegates normal ready blocks to Luna/high as the cost-efficient default.
  - Requirements: `core-workflow-contracts` — “Unified OpenSpec lifecycle contract”; `agent-catalog-routing` — “Deterministic routing policy”, “Single-entrypoint orchestration”, and “Refined-task executor ownership”; `implementation-task-refinement` — “Mandatory post-hard-spec task refinement”, “Task refinement readiness gate”, “Default Luna high implementation executor”, “Cost-efficient model allocation”, and “Expensive-output minimization”.
  - Scenarios: “Task refinement follows spec hardening”, “Task refinement is requested”, “Implementation is requested with unrefined tasks”, “Implementation is requested with a refined normal block”, “Orchestrator refines tasks locally”, “Orchestrator delegates refined implementation”, “Normal block uses lower-cost execution”, “Sol execution is requested for a normal block”, “Luna completes a block”, “Partial block resumes”, “Clarity or safety requires more output”, “Planning artifacts change after refinement”, “Luna reports a decision gap”, “Luna reports a non-decision execution failure”, “Executor reaches the step checkpoint”, and “Executor encounters an unplanned choice”.
  - Dependencies: Task 2.1.
  - Execution block: `B2`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: `scripts/validate/task-refinement-contract.sh`; `agents/orchestrator.md` routing, default delegation, retry, and execution policy; `core/routing-policy.md` primary selector, task-refinement section, and Luna/high executor precedence; `core/workflow-contract.md` lifecycle and response phase/executor vocabulary; `core/phase-contract-catalog.yaml` planning completion and implementation entry criteria; `skill/openspec-implementation/SKILL.md` entry criteria, whole-block delegation, evidence review, override reporting, and stop behavior.
  - RED: Extend `scripts/validate/task-refinement-contract.sh` to require planning-plus-`openspec-task-refinement` routing, unchanged five-phase ownership, `READY` block entry, default complete-block delegation to `subagent/refined-task-executor-subagent`, effective Luna/high reporting, same-child-session continuation on `PARTIAL`, readiness invalidation, no silent Sol fallback, and stop-on-new-decision behavior. Run `bash scripts/validate/task-refinement-contract.sh`; expect non-zero status because those contracts do not yet contain the block gate and executor route.
  - GREEN: Update all targets with the specified routing, block gate, delegation, override, continuation, retry, compact envelope, and Sol review semantics. Keep `planning`, `spec-hardening`, `implementation`, `verification`, and `archive` as the only top-level phase IDs. Run `bash scripts/validate/task-refinement-contract.sh`; expect `Task refinement contract passed`.
  - REFACTOR: Run `node scripts/validate/runtime-definitions.mjs --self-test && node scripts/validate/runtime-definitions.mjs`; expect both commands to exit zero and the phase catalog to remain valid.
  - Evidence: RED missing-routing assertion; GREEN focused contract pass; REFACTOR runtime-definition self-test and repository pass.
  - Completion: Task-refinement requests deterministically select planning plus the specialization, unrefined requests are blocked, normal ready blocks use Luna/high as the cost-efficient default, Sol use and other overrides are explicit, new decision gaps stop execution, and no sixth phase or primary agent exists.

## 4. Runner bundle specialization selection

- [ ] 4.1 Include task-refinement specialization automatically in planning bundles whose user prompt expresses refinement intent.
  - Outcome: Source, vendored, and global consumers can generate complete task-refinement context with the existing `bundle --phase planning` interface.
  - Requirements: `runtime-definition-integrity` — “Task-refinement specialization distribution”; `agent-catalog-routing` — “Deterministic routing policy”.
  - Scenarios: “Consumer bundles task-refinement context” and “Task refinement is requested”.
  - Dependencies: Tasks 1.2 and 3.1.
  - Execution block: `B2`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: `scripts/validate/runtime-runner-contract.sh`; `opencode-runner.sh` functions `is_task_refinement_intent` and `phase_default_skills`.
  - RED: In `runtime-runner-contract.sh`, generate a planning bundle with `--user-prompt 'Refine tasks into executor-ready steps without implementation decisions'` and no explicit `--skills`; assert the bundle contains `Skill: openspec-planning` and `Skill: openspec-task-refinement`. Run `bash scripts/validate/runtime-runner-contract.sh`; expect non-zero status because the refinement skill is absent from default selection.
  - GREEN: Add `is_task_refinement_intent` using case-insensitive English and Spanish patterns for task refinement, executor-ready/decision-free tasks, and `refinar tareas`. In `phase_default_skills`, append `openspec-task-refinement` only when phase is `planning` and the prompt matches. Run `bash scripts/validate/runtime-runner-contract.sh`; expect `Runtime runner contract passed`.
  - REFACTOR: Run `./opencode-runner.sh bundle --phase planning --change refine-implementation-tasks --pack generic --user-prompt 'Refina las tareas para que Luna pueda ejecutarlas sin tomar decisiones' --out /tmp/opencode/refine-implementation-tasks-bundle.md`; inspect command success and require output file to contain both planning and task-refinement skill headings, then delete the temporary bundle.
  - Evidence: RED bundle assertion failure; GREEN runtime-runner pass; REFACTOR Spanish-intent bundle evidence.
  - Completion: Existing phase syntax is unchanged, matching planning bundles include exactly one phase contract plus the refinement specialization, and unrelated planning prompts do not auto-load the specialization.

## 5. Cost accounting and quality evaluation

- [ ] 5.1 Add versioned API-equivalent model cost accounting.
  - Outcome: Observed execution token usage can be normalized to USD with a subscription-independent standard short-context API rate card, while unsupported profiles report `unknown`.
  - Requirements: `implementation-task-refinement` — “API-equivalent execution cost accounting” and “Expensive-output minimization”.
  - Scenarios: “Standard-profile execution has token telemetry”, “Deterministic rate fixture is calculated”, “Subscription changes”, “Unsupported pricing profile or missing telemetry”, and “API prices change”.
  - Dependencies: Tasks 2.1 and 3.1.
  - Execution block: `B3`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: new `core/model-api-prices.json`; new `scripts/evals/calculate-api-cost.mjs`; new `scripts/validate/model-cost-contract.sh`; `scripts/validate/run-all.sh` registration.
  - RED: Create `scripts/validate/model-cost-contract.sh`, make it executable, register it in `scripts/validate/run-all.sh`, and require the rate card plus calculator. Have the validator create a temporary normalized usage record with `1_000_000` input tokens including `200_000` cached input and `100_000` output for Sol, Terra, and Luna; run `bash scripts/validate/model-cost-contract.sh` before adding the targets and expect non-zero status for the missing rate card or calculator.
  - GREEN: Add `core/model-api-prices.json` with schema version `1`, currency `USD`, unit `1000000`, profile `standard-short-context`, source `https://platform.openai.com/docs/pricing`, checked date `2026-08-16`, and exact Sol/Terra/Luna input, cached-input, and output rates from the hard spec. Implement `calculate-api-cost.mjs` so cached input is subtracted from total input before applying the uncached rate, negative or malformed counts fail, supported records emit per-execution and total `api_equivalent_cost_usd`, and unsupported profiles or missing telemetry emit status `unknown` without an invented cost. Run `bash scripts/validate/model-cost-contract.sh`; expect Sol `$7.10`, Terra `$2.84`, and Luna `$0.284` fixture results.
  - REFACTOR: Validate `core/model-api-prices.json` with `node -e "JSON.parse(require('node:fs').readFileSync('core/model-api-prices.json'))"`, rerun `bash scripts/validate/model-cost-contract.sh`, and confirm fixture output is labeled formula validation rather than workload comparison.
  - Evidence: RED missing-target failure; GREEN deterministic cost outputs; REFACTOR JSON parse and focused contract pass.
  - Completion: Rate source/profile/date are explicit, formula does not double-count cached input, subscription plan is absent from calculation, unsupported profiles return `unknown`, and focused validation passes.

- [ ] 5.2 Add executor-ready task, Luna block-dispatch, and cost-accounting coverage metrics plus a golden fixture.
  - Outcome: Promotion metrics enforce task readiness, the cost-efficient Luna/high route, and API-equivalent cost presence for eligible telemetry without benchmarking complete Sol and Luna workloads.
  - Requirements: `implementation-task-refinement` — “Executor-ready task contract”, “Task refinement readiness gate”, “Default Luna high implementation executor”, “Cost-efficient model allocation”, and “API-equivalent execution cost accounting”.
  - Scenarios: “All tasks are executor-ready”, “One task is not executor-ready”, “Task contains an implementation choice”, “Cohesive normal block is ready”, “Ready normal block enters implementation”, “Normal block uses lower-cost execution”, “Sol execution is requested for a normal block”, “Standard-profile execution has token telemetry”, and “Eligible cost-accounting coverage is evaluated”.
  - Dependencies: Task 5.1.
  - Execution block: `B3`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: `scripts/evals/run-all.sh` Python `checks` list; `evals/config/global-thresholds.json`; `evals/sample-metrics.json`; new `evals/golden-tasks/cross-stack/refine-tasks-for-basic-model.yaml`; `README.md` global quality thresholds list.
  - RED: Add `("executor_ready_task_rate", ">=", thresholds["executor_ready_task_rate_min"])`, `("luna_refined_block_dispatch_rate", ">=", thresholds["luna_refined_block_dispatch_rate_min"])`, and `("api_cost_accounting_coverage", ">=", thresholds["api_cost_accounting_coverage_min"])` to the evaluation runner before adding threshold or sample values. Run `bash scripts/evals/run-all.sh`; expect non-zero status caused by missing threshold or metric data.
  - GREEN: Add all three minimum thresholds at `100` with matching sample metrics, and a golden fixture covering a `READY` gate, cohesive blocks, no decision gaps, exact targets, ordered steps, traceability, Luna/high default block dispatch, structured envelopes, explicit override evidence, API-equivalent cost presence for eligible telemetry, and command evidence. Do not add end-to-end Sol-versus-Luna workload benchmarks. Update the README threshold list. Run `bash scripts/evals/run-all.sh`; expect `Promotion gate: PASS` and passing lines for all three metrics.
  - REFACTOR: Validate both JSON files with `node -e "JSON.parse(require('node:fs').readFileSync('evals/config/global-thresholds.json')); JSON.parse(require('node:fs').readFileSync('evals/sample-metrics.json'))"` and rerun `bash scripts/evals/run-all.sh`; expect zero exit status.
  - Evidence: RED missing-key or missing-metric failure; GREEN promotion pass; REFACTOR JSON parse and evaluation pass.
  - Completion: Readiness, Luna block-dispatch, and eligible cost-accounting coverage thresholds are exactly 100%, sample metrics satisfy them, and the golden fixture rejects decision-bearing tasks, one-task-per-session default routing, silent Sol execution, missing eligible cost records, and non-explicit executor deviation.

## 6. Consumer and operator documentation

- [ ] 6.1 Document the post-hard-spec refinement flow and existing-runner usage.
  - Outcome: Consumers know when refinement runs, how it differs from spec hardening, how to invoke it, why `READY` is required, and how Luna/high reduces expected implementation cost by reserving Sol for decision-heavy work.
  - Requirements: `core-workflow-contracts` — “Unified OpenSpec lifecycle contract”; `runtime-definition-integrity` — “Task-refinement specialization distribution”; `implementation-task-refinement` — “Cost-efficient model allocation”, “API-equivalent execution cost accounting”, and “Expensive-output minimization”.
  - Scenarios: “Task refinement follows spec hardening”, “Consumer bundles task-refinement context”, “Implementation is requested with unrefined tasks”, “Normal block uses lower-cost execution”, “Subscription changes”, “Unsupported pricing profile or missing telemetry”, “Luna completes a block”, and “Cost comparison is requested”.
  - Dependencies: Tasks 3.1, 4.1, and 5.1.
  - Execution block: `B3`.
  - Executor: `subagent/refined-task-executor-subagent` using `openai/gpt-5.6-luna` with `variant: high`.
  - Targets: `README.md` sections “How it works”, “Quick start”, “Recommended consumer flow”, new “OpenSpec task refinement”, skill listing, validation command list, and model-policy explanation.
  - TDD: Not applicable — this task changes documentation only and does not alter executable behavior.
  - Steps: Add `openspec-task-refinement` and `refined-task-executor-subagent` to inventories; place refinement between spec hardening and implementation in lifecycle lists; document required task/block fields and `READY`/`BLOCKED` behavior; document Sol refinement and final review plus cost-efficient Luna/high block execution; explain two-to-five-task blocks, justified single-task exceptions, compact structured envelopes, same-session continuation, explicit overrides, no silent Sol fallback, bootstrap restart, standard short-context API rates, formula, subscription independence, output-cost priority, unsupported-profile behavior, and rate-card update policy; state that end-to-end model benchmarking belongs to a separate future change; add source, vendored, and global bundle examples using `--phase planning` and a refinement user prompt; add both focused validation scripts to validation commands.
  - Verification: Run `bash scripts/validate/task-refinement-contract.sh`; expect `Task refinement contract passed`. Run `bash scripts/validate/model-cost-contract.sh`; expect `Model cost contract passed`. Run `bash scripts/validate/contracts.sh`; expect `Contract validation passed`.
  - Evidence: Focused and baseline contract pass output.
  - Completion: Documentation contains no sixth phase, no new agent-switch instruction, no claim that task readiness guarantees model success, and all invocation examples use existing runner syntax.

## 7. Final traceability and regression validation

- [ ] 7.1 Validate the complete change and record implementation evidence before marking tasks complete.
  - Outcome: All new requirements and scenarios are covered by implementation tasks and repository checks pass without regressions.
  - Requirements: All requirements in `implementation-task-refinement`, modified `core-workflow-contracts`, modified `agent-catalog-routing`, and added `runtime-definition-integrity` delta specs.
  - Scenarios: All scenarios in the four delta spec files.
  - Dependencies: Tasks 1.1, 1.2, 2.1, 3.1, 4.1, 5.1, 5.2, and 6.1.
  - Execution block: `B4`.
  - Executor: `orchestrator` using `openai/gpt-5.6-sol`; rationale: final cross-task traceability, integration review, and completion authority remain with Sol.
  - Targets: `openspec/changes/refine-implementation-tasks/tasks.md` checkboxes and optional Markdown evidence files under `openspec/changes/refine-implementation-tasks/evidence/` when command output needs a durable summary.
  - TDD: Not applicable — this task verifies completed behavior and records evidence; behavior changes receive RED/GREEN/REFACTOR evidence in Tasks 1.1 through 5.2.
  - Steps: Review every requirement/scenario against completed tasks and changed files; mark a checkbox complete only after its evidence passes; run focused checks before the full suite; leave any failed task unchecked and report its blocker.
  - Verification: Run `bash scripts/validate/task-refinement-contract.sh`, `bash scripts/validate/model-cost-contract.sh`, `bash scripts/validate/runtime-runner-contract.sh`, `bash scripts/validate/runtime-consumer-contract.sh`, `node scripts/validate/runtime-definitions.mjs --self-test`, `node scripts/validate/runtime-definitions.mjs`, `bash scripts/evals/run-all.sh`, `bash scripts/validate/run-all.sh`, and `./opencode-runner.sh phase verification --change refine-implementation-tasks --pack generic`; expect every command to exit zero.
  - Evidence: Command and result summary for each focused check, full validation suite, evaluation promotion gate, and strict OpenSpec validation.
  - Completion: Every completed checkbox has passing evidence, no unresolved decision gap remains, strict validation passes, and `git diff --check` reports no whitespace errors.
