## ADDED Requirements

### Requirement: Mandatory post-hard-spec task refinement
The platform SHALL require a task-refinement sub-phase after hard-spec readiness is established and before implementation begins. Task refinement SHALL run under the planning phase with the `openspec-task-refinement` specialization and SHALL update `tasks.md` without introducing another phase-owning agent or top-level runner phase.

#### Scenario: Hard spec is ready for task refinement
- **WHEN** strict OpenSpec validation passes and proposal, design, specs, and draft tasks contain no unresolved CRITICAL ambiguity
- **THEN** the orchestrator selects the planning phase contract and applies `openspec-task-refinement`
- **AND** the refiner evaluates and rewrites `tasks.md` against the executor-ready task contract

#### Scenario: Hard spec is not ready
- **WHEN** task refinement discovers an unresolved product, architecture, compatibility, security, data, infrastructure, operational, or test-strategy decision
- **THEN** it marks task refinement as blocked
- **AND** reports the decision, affected requirements or scenarios, and required operator input
- **AND** routes the change back to spec hardening without choosing an answer

### Requirement: Executor-ready task contract
Every implementation task marked ready SHALL define one bounded, verifiable outcome and SHALL include its requirement and scenario references, dependencies, execution-block ID, exact target file paths and symbols, ordered implementation steps, test-first procedure when behavior changes, exact local verification commands, expected evidence, and objective completion conditions. A ready task SHALL NOT contain unresolved placeholders, optional implementation branches, or instructions that require the implementer to select among valid product or technical alternatives.

#### Scenario: Behavior-changing task satisfies the contract
- **WHEN** a task changes observable behavior
- **THEN** it identifies the exact requirement and scenarios covered
- **AND** identifies its execution-block ID
- **AND** names the files and symbols to test and modify
- **AND** defines ordered RED, GREEN, and REFACTOR actions with exact commands and expected results
- **AND** provides completion conditions that can be checked without making a new decision

#### Scenario: Non-behavior task satisfies the contract
- **WHEN** a task changes only documentation, configuration, metadata, or another non-behavior surface
- **THEN** it explicitly states that TDD is not applicable and why
- **AND** still defines exact targets, ordered steps, verification commands, expected evidence, and objective completion conditions

#### Scenario: Task contains an implementation choice
- **WHEN** a task asks the implementer to choose a library, architecture, API shape, compatibility behavior, security policy, persistence strategy, file location, test strategy, or one of multiple valid approaches
- **THEN** the task SHALL NOT be marked ready
- **AND** the unresolved choice SHALL be reported as a decision gap for spec hardening

### Requirement: Executor-ready task blocks
The task refiner SHALL group ready tasks into ordered execution blocks. A normal block SHALL contain two to five cohesive tasks that share requirement context, target area, stack constraints, and verification commands. Each block SHALL identify its ordered task IDs, executor runtime/model/variant, satisfied external dependencies, allowed targets, forbidden scope, exact commands, stop conditions, and block completion criteria. A bootstrap, final-integration, or indivisible block MAY contain one task only when `tasks.md` records the reason.

#### Scenario: Cohesive normal block is ready
- **WHEN** two to five ready tasks affect one target area and have a deterministic internal dependency order
- **THEN** the refiner assigns them one block ID and one shared executor
- **AND** records shared context and verification once at block level
- **AND** no task in the block depends on an incomplete task from another block

#### Scenario: Proposed block is too broad
- **WHEN** proposed tasks span independent target areas, unrelated requirement context, incompatible specialist routes, or independent rollback boundaries
- **THEN** the refiner splits them into separate blocks
- **AND** records deterministic dependencies between those blocks

#### Scenario: Single-task block is necessary
- **WHEN** bootstrap, final integration, or indivisible work cannot be grouped safely
- **THEN** the refiner may create a single-task block
- **AND** records the exact exception reason

### Requirement: Task refinement readiness gate
`tasks.md` SHALL contain a task-refinement gate with status `READY` or `BLOCKED`, the strict-validation command, and an explicit decision-gap result. The status SHALL be `READY` only when every incomplete implementation task satisfies the executor-ready task contract, every task belongs to a valid executor-ready block, and the decision-gap result is `None`.

#### Scenario: All tasks are executor-ready
- **WHEN** every incomplete implementation task and execution block satisfies its contract and strict OpenSpec validation passes
- **THEN** the task-refinement gate is set to `READY`
- **AND** the decision-gap result is `None`
- **AND** implementation may begin

#### Scenario: One task is not executor-ready
- **WHEN** any incomplete implementation task lacks a required field, contains an unresolved choice, or cannot be verified with an exact local command
- **THEN** the task-refinement gate is set to `BLOCKED`
- **AND** implementation SHALL NOT begin

#### Scenario: One execution block is not executor-ready
- **WHEN** any block is too broad, has an unresolved external dependency, mixes incompatible executor routes, lacks a required handoff field, or has no exact block-level verification
- **THEN** the task-refinement gate is set to `BLOCKED`
- **AND** implementation SHALL NOT begin

#### Scenario: Planning artifacts change after refinement
- **WHEN** proposal, design, specs, or task scope changes after the gate was set to `READY`
- **THEN** the orchestrator resets the gate to `BLOCKED`
- **AND** reruns task refinement before implementation

### Requirement: Default Luna high implementation executor
The Sol orchestrator SHALL delegate each normal executor-ready implementation block to `subagent/refined-task-executor-subagent` by default. That executor SHALL use `model: openai/gpt-5.6-luna`, `variant: high`, `steps: 50`, and `permission.task: deny`. The executor SHALL own one complete block per child session while the orchestrator retains final review and task-completion authority and reports the effective executor, model, variant, and any override before implementation starts.

#### Scenario: Ready normal block enters implementation
- **WHEN** a normal implementation block has a `READY` refinement gate and names the default executor
- **THEN** the Sol orchestrator delegates exactly that block to `subagent/refined-task-executor-subagent`
- **AND** the child session uses `openai/gpt-5.6-luna` with variant `high`
- **AND** the orchestrator reviews returned changes and evidence before marking block tasks complete

#### Scenario: Explicit executor override applies
- **WHEN** the operator explicitly selects another executor or an already-defined mandatory specialist route owns the block
- **THEN** the orchestrator may bypass the Luna/high default for that block
- **AND** reports the effective executor and override rationale before edits begin

#### Scenario: Luna reports a decision gap
- **WHEN** the Luna/high executor reports that the block requires an unresolved product or technical decision
- **THEN** the orchestrator leaves affected tasks incomplete
- **AND** returns the change to spec hardening followed by task refinement
- **AND** does not implement the task with Sol as an automatic fallback

#### Scenario: Luna reports a non-decision execution failure
- **WHEN** the Luna/high executor reports a mechanical, tool, context, or verification failure without an unresolved decision
- **THEN** the Sol orchestrator improves the block instructions through task refinement
- **AND** resumes or delegates the revised block to Luna/high again
- **AND** direct Sol implementation requires explicit operator approval

#### Scenario: Executor reaches the step checkpoint
- **WHEN** the Luna/high executor reaches its configured step checkpoint before the block is complete and no hard blocker exists
- **THEN** it returns `PARTIAL` with completed and remaining task IDs plus current evidence
- **AND** the Sol orchestrator resumes the same child session with only delta instructions
- **AND** Luna retains ownership of the complete block

### Requirement: Compact block communication
The orchestrator SHALL send one structured handoff envelope per execution block containing only block identity, ordered task IDs, bounded goal, referenced requirements and scenarios, satisfied dependencies, allowed and forbidden targets, ordered steps, exact commands, stop conditions, applicable pack constraints, and expected evidence. The executor SHALL return one compact structured result containing status, completed and remaining task IDs, touched files, command evidence, decision gaps, verification failures, and scope deviations.

#### Scenario: Orchestrator delegates a new block
- **WHEN** the next executor-ready block is delegated
- **THEN** Sol sends the defined handoff envelope with only block-relevant artifact excerpts and source context
- **AND** does not retransmit the full proposal, full design, unrelated specs, full repository tree, or previous conversational narrative

#### Scenario: Orchestrator reviews a completed block
- **WHEN** Luna returns `COMPLETED`
- **THEN** it sends the compact result envelope without reproducing full diffs in prose
- **AND** Sol inspects changed files and diffs directly before accepting evidence

#### Scenario: Partial block continues
- **WHEN** Luna returns `PARTIAL` without a hard blocker
- **THEN** Sol resumes the same child session using its existing task or session identifier
- **AND** sends only new failure evidence, changed constraints, or the next instruction delta

### Requirement: Cost-efficient model allocation
The platform SHALL minimize expected implementation cost by reserving the Sol orchestrator for hard-spec decisions, task refinement, orchestration, escalation, cross-block integration, and final review while routing every eligible normal executor-ready block to the designated lower-cost Luna/high executor. Sol SHALL NOT implement an eligible normal block unless the operator explicitly overrides the default. Mandatory specialist routes MAY take precedence only when their existing routing contract applies and the orchestrator reports the rationale.

#### Scenario: Normal block uses lower-cost execution
- **WHEN** an executor-ready normal block has no mandatory specialist route or operator override
- **THEN** the Sol orchestrator delegates it to `subagent/refined-task-executor-subagent`
- **AND** Luna/high performs the block implementation
- **AND** Sol limits its work to orchestration, evidence review, and completion decisions

#### Scenario: Sol execution is requested for a normal block
- **WHEN** a normal block would be implemented directly by Sol
- **THEN** implementation remains blocked until the operator explicitly approves the override
- **AND** the orchestrator records the override rationale before edits begin

#### Scenario: Mandatory specialist route applies
- **WHEN** an executor-ready block matches an existing mandatory specialist route
- **THEN** that specialist may replace Luna/high for the block
- **AND** the orchestrator reports the effective executor and routing rationale

#### Scenario: Cost comparison is requested
- **WHEN** maintainers need quantitative token, reasoning, or currency comparison between Sol and Luna
- **THEN** they perform that work in a separate project or OpenSpec change
- **AND** this change continues to enforce cost-efficient default routing without claiming measured savings

### Requirement: API-equivalent execution cost accounting
The platform SHALL define `api_equivalent_cost_usd` from a versioned `standard-short-context` API price profile rather than from ChatGPT subscription allowances or message limits. The profile SHALL use USD per one million tokens with rates Sol `5.00` input, `0.50` cached input, and `30.00` output; Terra `2.00`, `0.20`, and `12.00`; and Luna `0.20`, `0.02`, and `1.20`. It SHALL record `https://platform.openai.com/docs/pricing` as its source and a checked date. When `input_tokens` includes cached input, the calculation SHALL use `max(input_tokens - cached_input_tokens, 0)` at the uncached-input rate, cached input at the cached-input rate, and output at the output rate, divided by `1_000_000`.

#### Scenario: Standard-profile execution has token telemetry
- **WHEN** an observed model execution records non-negative `input_tokens`, `cached_input_tokens`, and `output_tokens` under the `standard-short-context` profile
- **THEN** the platform calculates `api_equivalent_cost_usd` with the versioned rate for that exact model
- **AND** does not double-count cached input as uncached input

#### Scenario: Deterministic rate fixture is calculated
- **WHEN** each configured model receives `1_000_000` input tokens including `200_000` cached input tokens and `100_000` output tokens
- **THEN** Sol cost is `$7.10`
- **AND** Terra cost is `$2.84`
- **AND** Luna cost is `$0.284`
- **AND** these values validate the formula only and SHALL NOT be reported as an end-to-end workload comparison

#### Scenario: Subscription changes
- **WHEN** the operator moves between Plus, Pro, Business, Enterprise, or API-key execution
- **THEN** the normalized API-equivalent price profile remains unchanged
- **AND** subscription allowances and message limits do not alter `api_equivalent_cost_usd`

#### Scenario: Unsupported pricing profile or missing telemetry
- **WHEN** execution uses long context, Batch, Flex, Fast, regional processing, separately charged tools, or lacks required token telemetry
- **THEN** `api_equivalent_cost_usd` is reported as `unknown`
- **AND** the platform does not substitute standard rates, message estimates, or invented token counts

#### Scenario: API prices change
- **WHEN** maintainers update any model rate
- **THEN** they update the source-checked date and affected deterministic fixtures in the same reviewed change
- **AND** existing historical records retain the rate-card version used for their calculation

#### Scenario: Eligible cost-accounting coverage is evaluated
- **WHEN** evaluation records contain supported-profile executions with complete token telemetry
- **THEN** `api_cost_accounting_coverage` is the percentage of those eligible records with a numeric `api_equivalent_cost_usd`
- **AND** the required coverage is `100`
- **AND** a set with no eligible records reports coverage `100` without inventing an execution cost

### Requirement: Expensive-output minimization
The Sol orchestrator SHALL minimize model output that does not contribute a decision, blocker, instruction delta, or final evidence decision. It SHALL inspect files and diffs directly and SHALL NOT reproduce Luna source changes, full result envelopes, unchanged block context, or verbose progress narratives. This requirement SHALL NOT remove mandatory safety warnings, irreversible-action wording, blockers, decisions, or verification evidence.

#### Scenario: Luna completes a block
- **WHEN** Luna returns a structured `COMPLETED` result
- **THEN** Sol inspects the changed files and diff directly
- **AND** responds with only acceptance or remediation, mandatory evidence, blockers, and next action
- **AND** does not restate the full Luna result or diff

#### Scenario: Partial block resumes
- **WHEN** Luna returns `PARTIAL` without a hard blocker
- **THEN** Sol sends only the instruction or evidence delta required to continue
- **AND** does not resend unchanged block context

#### Scenario: Clarity or safety requires more output
- **WHEN** compressed output would make a security warning, irreversible action, blocker, or required decision ambiguous
- **THEN** Sol uses sufficient explicit wording for safety and correctness
- **AND** cost minimization does not suppress required information

### Requirement: Low-reasoning executor boundary
Executor-ready tasks SHALL contain all decisions needed for implementation so that an executor may follow the prescribed steps without inferring product intent or inventing technical policy. Model capability SHALL NOT weaken tests, validation, security boundaries, stack-pack constraints, or completion evidence.

#### Scenario: Luna high executes a refined block
- **WHEN** `subagent/refined-task-executor-subagent` receives one executor-ready block plus the referenced artifact excerpts, repository context, and resolved stack pack
- **THEN** Luna/high can identify the required edits, task order, and verification evidence from the block
- **AND** it is not required to resolve any product or technical decision to complete the task

#### Scenario: Executor encounters an unplanned choice
- **WHEN** implementation reveals a valid choice not resolved by the refined task and hard spec
- **THEN** the executor stops the affected block
- **AND** reports the decision gap without guessing or broadening scope
- **AND** the change returns to spec hardening followed by task refinement
