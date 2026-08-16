## Context

The current workflow drafts `tasks.md` during planning and reviews it during spec hardening. Hard-spec readiness combines requirement decisions, deterministic scenarios, task traceability, and verification evidence in one gate. This is sufficient for a strong implementation model that can still decompose work and resolve minor technical gaps, but it does not prove that individual tasks are safe for a lower-capability executor.

The repository supports five top-level phase contracts and intentionally keeps phase ownership in the orchestrator. Runner commands, phase catalogs, validators, and consumer documentation all depend on that stable phase set. OpenSpec also treats `tasks.md` as the implementation prerequisite, so task refinement should strengthen that artifact rather than introduce an unsupported artifact type.

## Goals / Non-Goals

**Goals:**

- Separate hard-spec decision closure from executor-oriented task decomposition.
- Make task readiness objective enough for an orchestrator to block unsafe implementation.
- Make Luna with high reasoning effort the default executor for bounded refined task blocks without giving it product or technical decision ownership.
- Minimize redundant context between Sol and Luna through a structured block handoff.
- Reduce expected implementation cost by spending Sol capacity on decisions, refinement, orchestration, escalation, and final review rather than normal decision-free edits.
- Account for observed execution cost with a normalized API-equivalent metric that remains stable when the operator changes ChatGPT subscription.
- Preserve current runner syntax, top-level phase catalog, and single-entrypoint operation.
- Retain all existing quality and safety gates while making executor selection explicit and auditable.

**Non-Goals:**

- Replace Sol as the primary orchestrator, task refiner, escalation owner, or final reviewer.
- Guarantee successful execution when tools, context, or stack knowledge are missing.
- Encode every implementation detail in specifications instead of tasks.
- Add a new OpenSpec artifact or top-level runner phase.
- Replace operator decisions, TDD, strict validation, or verification.

## Decisions

### 1. Model task refinement as a planning sub-phase

`task-refinement` will be a mandatory lifecycle step after spec hardening and before implementation, but it will run under the existing planning phase. Routing will load `openspec-planning` as the sole phase contract and add `openspec-task-refinement` as a specialization.

This preserves the invariant that one session loads exactly one phase-contract skill and avoids changing runner phase parsing, phase catalog validation, archived command examples, and consumer integrations.

**Alternative considered:** Add a sixth top-level `task-refinement` phase. Rejected because it expands the phase state machine and runner compatibility surface without adding permissions or lifecycle behavior distinct from planning.

### 2. Keep `tasks.md` as the only refinement output

The refiner will rewrite `tasks.md` and add a `Task Refinement Gate` section. The gate has a status of `READY` or `BLOCKED`, records the strict validation command, and states whether decision gaps remain.

No `refined-tasks.md`, lock file, or generated hash will be introduced. One canonical task artifact prevents drift and remains compatible with OpenSpec's apply prerequisite.

**Alternative considered:** Add a separate refinement artifact. Rejected because OpenSpec 1.1.1 does not model that artifact and two task sources could disagree.

### 3. Define fixed task and execution-block shapes

Each implementation task will contain:

1. A stable task ID and one bounded outcome.
2. Requirement and scenario references.
3. Explicit dependencies by task ID.
4. The exact executor runtime name, model, and variant.
5. Exact target file paths and symbols, including exact paths for new files.
6. Ordered edit steps with no optional branch or unresolved alternative.
7. RED, GREEN, and REFACTOR steps for behavior changes, or an explicit non-behavior justification.
8. Exact local commands and expected result for each verification point.
9. Expected evidence and objective completion conditions.

Tasks must not use unresolved phrases such as `TBD`, “choose”, “as appropriate”, “if needed”, or “either/or”. An implementation task represents one cohesive outcome and one verification loop; independent outcomes must be split.

The refiner will then group tasks into execution blocks. A normal block contains two to five tasks that share requirement context, target area, stack constraints, and verification commands. Tasks inside a block have a deterministic dependency order and no dependency on another incomplete block. Bootstrap, final integration, or indivisible work may use a single-task block only with an explicit reason.

Each block records its block ID, ordered task IDs, executor runtime/model/variant, shared requirement and scenario references, satisfied external dependencies, allowed targets, forbidden scope, exact commands, stop conditions, and block completion criteria.

**Alternative considered:** Use only a prose quality rubric. Rejected because different models would interpret it inconsistently and implementation entry could not be reviewed deterministically.

### 4. Make decision gaps a hard stop

The task refiner may discover missing decisions but may not resolve them. It must set the gate to `BLOCKED`, identify the decision category, point to affected requirements or scenarios, and return the change to spec hardening. After the decision updates proposal, design, or specs, task refinement runs again.

The same rule applies during implementation. If an executor finds a valid unplanned choice, it stops the affected task rather than guessing.

**Alternative considered:** Let the refiner choose low-risk technical defaults. Rejected because “low risk” is stack- and product-dependent and would recreate hidden implementation decisions.

### 5. Invalidate readiness after planning changes

Any implementation-affecting change to proposal, design, specs, or task scope resets the gate to `BLOCKED`. The orchestrator reruns refinement before implementation. This is a semantic workflow rule rather than a content hash because artifacts are authored and reviewed by models, and a hash would detect harmless prose edits without proving semantic consistency.

### 6. Use a bounded Luna/high block executor by default

The platform will add `agents/subagent/refined-task-executor-subagent.md` with this effective runtime policy:

```yaml
mode: subagent
model: openai/gpt-5.6-luna
variant: high
steps: 50
hidden: true
permission:
  task: deny
  edit: allow
  bash: allow
```

`variant: high` is the schema-supported OpenCode agent setting for the built-in OpenAI high-reasoning variant. The agent is leaf-only, receives exactly one executor-ready block plus minimal relevant artifact excerpts and pack context, and may edit tests and production code within that block's declared targets. It owns the complete block, updates individual task progress, and returns structured evidence with status `COMPLETED`, `PARTIAL`, or `BLOCKED`.

The Sol orchestrator remains the active primary agent and final decision owner. It runs task refinement, delegates each normal `READY` block to the Luna/high executor, reviews the diff and evidence, and marks tasks complete only after checks pass. An explicit operator model override or a mandatory existing specialist route, such as Pulumi-specific implementation, may replace the default executor; the override and rationale must be reported.

`steps: 50` is the configured safety checkpoint, not the unit of ownership or a requirement to finish in one child response. If the checkpoint produces `PARTIAL` without a decision gap, Sol resumes the same child session using its existing task/session identifier and does not resend the unchanged block context. The Luna executor continues owning the block until it returns `COMPLETED` or `BLOCKED`.

If Luna reports a decision gap, the change returns to spec hardening and task refinement. If Luna reports a mechanical, tool, or verification failure without a decision gap, Sol improves the block instructions and resumes or re-delegates the block to Luna. Sol does not silently implement the block; direct Sol implementation requires explicit operator approval.

**Alternative considered:** Change the primary implementation phase model from Sol to Luna. Rejected because phase routing, refinement, cross-task integration, escalation, and final evidence review still require the stronger orchestrator role.

**Alternative considered:** Delegate one task per child session. Rejected because repeated agent, artifact, pack, and source context would duplicate context and increase cross-task integration overhead.

**Alternative considered:** Remove the step checkpoint entirely. Rejected because an unbounded child loop weakens cost and failure containment; same-session continuation preserves block ownership without requiring unbounded execution.

**Alternative considered:** Let Sol implement automatically after Luna fails. Rejected because this would make the claimed default non-deterministic and hide whether task refinement was sufficient.

### 7. Use a compact structured handoff

Sol sends one handoff envelope per block containing only:

```yaml
change: <change-name>
block_id: <block-id>
task_ids: [<ordered-task-ids>]
goal: <bounded block outcome>
requirements: [<requirement/scenario references>]
dependencies_satisfied: [<external task/block ids>]
targets:
  allowed: [<exact paths and symbols>]
  forbidden: [<explicit exclusions>]
steps: [<ordered task steps>]
commands: [<exact RED/GREEN/REFACTOR and block checks>]
stop_conditions: [<decision, scope, security, external-action conditions>]
pack_constraints: [<only applicable constraints>]
expected_evidence: [<required evidence fields>]
```

The envelope embeds only the design decisions, requirement scenarios, and source excerpts referenced by the block. It does not repeat the full proposal, full design, unrelated specs, full repository tree, or previous conversational narrative. Sol supplies source through file paths or CodeGraph-derived focused excerpts and lets Luna read a target file only when current content is needed.

Luna returns one compact result envelope:

```yaml
status: COMPLETED | PARTIAL | BLOCKED
block_id: <block-id>
completed_task_ids: [<ids>]
remaining_task_ids: [<ids>]
touched_files: [<paths>]
evidence:
  red: [<command and result>]
  green: [<command and result>]
  refactor: [<command and result>]
  block_checks: [<command and result>]
decision_gaps: [<none or exact gaps>]
verification_failures: [<none or exact failures>]
scope_deviations: [<none or exact deviations>]
```

Sol inspects changed files and diffs directly instead of asking Luna to reproduce them in prose. For `PARTIAL`, Sol resumes the same child session with only the failed command, changed constraint, or next instruction delta.

### 8. Enforce and account for cost-efficient model allocation

Cost efficiency is a normative routing requirement even though quantitative benchmarking is outside this change. Luna/high is the designated lower-cost executor for every eligible normal block. Sol remains responsible for hard-spec decisions, task refinement, cross-block coordination, blocker handling, and final review.

Sol may implement a normal block only after an explicit operator override. Mandatory specialist routes remain allowed when their existing routing contract applies, but the effective executor and rationale must be reported before edits begin. The `luna_refined_block_dispatch_rate` quality metric verifies policy conformance at 100%; it does not claim a measured token or currency reduction.

Cost accounting uses a versioned `standard-short-context` API-equivalent profile rather than subscription limits or Codex message estimates. The initial USD rates per one million tokens, checked on 2026-08-16 against `https://platform.openai.com/docs/pricing`, are:

| Model | Input | Cached input | Output |
| --- | ---: | ---: | ---: |
| `openai/gpt-5.6-sol` | `$5.00` | `$0.50` | `$30.00` |
| `openai/gpt-5.6-terra` | `$2.00` | `$0.20` | `$12.00` |
| `openai/gpt-5.6-luna` | `$0.20` | `$0.02` | `$1.20` |

For a normalized usage record where `input_tokens` includes cached input, cost is:

```text
uncached_input_tokens = max(input_tokens - cached_input_tokens, 0)
api_equivalent_cost_usd = (
  uncached_input_tokens * input_usd_per_million
  + cached_input_tokens * cached_input_usd_per_million
  + output_tokens * output_usd_per_million
) / 1_000_000
```

Output is six times the uncached-input rate and sixty times the cached-input rate for all three selected models. Sol is twenty-five times Luna for each listed token category; Terra is ten times Luna. Therefore Sol must keep orchestration output compact: send only block deltas, inspect diffs directly, and avoid reproducing Luna's result or source in prose.

The rate card is a normalization profile, not an invoice. It excludes long-context, cache-write, Batch, Flex, Fast, regional-processing, tool-call, and container charges. A record using another profile reports `api_equivalent_cost_usd: unknown` rather than applying the wrong rate. Price changes update the versioned rate card and checked date without coupling the workflow to a subscription plan.

Observed token records may be converted to `api_equivalent_cost_usd` without comparing Sol and Luna workloads. End-to-end comparative benchmarking remains a separate change.

### 9. Validate contract presence and behavior

Static contract validation will require the new skill, executor agent, catalog and model-policy entries, routing text, block template sections, handoff/result envelopes, API rate card, cost formula, and implementation entry language. Runtime definition validation will verify `openai/gpt-5.6-luna`, `variant: high`, `steps: 50`, and leaf delegation denial. Focused evaluation fixtures will test block refinement, Luna/high routing, same-session continuation, compact envelope fields, deterministic API-equivalent cost calculation, and decision-bearing task rejection. Comparative workload benchmarking is intentionally deferred to a separate change. Existing full validation remains the regression gate.

## Workflow

1. Planning drafts proposal, specs, design, and initial tasks.
2. Spec hardening resolves all CRITICAL decisions and passes strict validation.
3. Task refinement inspects artifacts and relevant repository context, rewrites `tasks.md`, evaluates every incomplete task, and groups ready tasks into cohesive execution blocks.
4. If a decision gap exists, the gate becomes `BLOCKED` and the flow returns to step 2.
5. If every task and block passes, the gate becomes `READY` and each normal block records `subagent/refined-task-executor-subagent` with Luna/high as its executor.
6. During implementation, Sol sends one minimal handoff envelope for the next ready block and Luna/high owns that block through completion or a hard blocker.
7. A `PARTIAL` checkpoint resumes the same child session with only delta instructions; no unchanged context is retransmitted.
8. Any newly discovered decision returns the change to steps 2 and 3; a non-decision execution failure returns to block refinement and Luna retry.
9. Verification and archive retain their current responsibilities under Sol orchestration.

## Risks / Trade-offs

- **Task files become longer** → Put shared context once at block level and keep individual task fields focused on task-specific deltas.
- **Refinement duplicates some hardening review** → Hardening owns decisions and scenario correctness; refinement owns executable decomposition and evidence instructions.
- **A textual readiness marker can become stale** → Require invalidation after implementation-affecting artifact changes and recheck the rubric at implementation entry.
- **Exact file and symbol targets may require repository discovery during planning** → Make repository inspection part of task refinement, before handing work to the executor.
- **Over-prescriptive tasks may block legitimate implementation adaptation** → Stop and return to hardening when adaptation represents a real choice; permit only mechanical corrections that do not alter specified behavior or architecture.
- **Lower-capability execution may still fail for context or tool reasons** → Treat task readiness as necessary but not sufficient; never weaken verification to accommodate the executor.
- **Subagent delegation adds orchestration overhead** → Delegate one cohesive block per child session, use structured envelopes, and resume the same session after checkpoints.
- **Specialist routes can conflict with the Luna default** → Give explicit operator overrides and mandatory specialist routes precedence, and report executor plus rationale before work starts.
- **Larger blocks increase rollback and debugging scope** → Limit normal blocks to two to five cohesive tasks with one target area and deterministic internal dependencies.
- **Luna retries can erode expected cost efficiency** → Require decision-free blocks, compact continuation, bounded checkpoints, and escalation instead of repeated blind retries.
- **API prices change** → Store source URL, profile, currency, unit, and checked date beside rates and update them through a reviewed change.
- **Runtime token telemetry may be unavailable** → Report cost as `unknown`; never invent token counts or use subscription message limits as a substitute.

## Migration Plan

1. Add the new skill and manifest.
2. Bootstrap and catalog the Luna/high refined-task executor with Sol and centralized model-policy validation.
3. Restart OpenCode so the running orchestrator session discovers the new subagent before subsequent tasks are delegated to Luna/high.
4. Update planning, hardening, implementation, workflow, orchestrator, routing, template, and OpenSpec config contracts through the new executor.
5. Add the versioned API rate card, deterministic cost calculator, focused validators, and evaluation coverage.
6. Update README lifecycle guidance and examples.
7. Run strict OpenSpec validation and the repository validation suite under Sol review.

Existing active changes without a task-refinement gate will be treated as `BLOCKED` when implementation is requested and must run the refinement step. The agent definition is loaded at OpenCode startup, so the bootstrap implementation of this change requires one local operator restart before Luna/high delegation becomes available. Archived changes remain unchanged.

Rollback is local and reversible: remove the specialization and its routing/gate requirements, restore the previous task template and lifecycle wording, and rerun validation. No production data or external migration is involved.

## Open Questions

None. The task-refinement step, block sizing, artifact ownership, readiness states, Luna/high default, Sol ownership, override precedence, checkpoint continuation, communication envelopes, and executor boundary are fully specified. Token benchmarking is out of scope for this change.
