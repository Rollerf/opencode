# quality-evaluation-harness Specification

## Purpose
TBD - created by archiving change agent-platform-evolution. Update Purpose after archive.
## Requirements
### Requirement: Versioned golden-task suites
The platform SHALL maintain versioned golden-task suites for cross-stack and stack-specific workflows.

#### Scenario: Golden tasks cover primary workflows
- **WHEN** the evaluation harness is executed
- **THEN** it runs tasks covering planning, implementation, verification, documentation, and refactor flows

### Requirement: Quantitative quality scoring
The evaluation harness SHALL compute repeatable quality metrics including task success rate, first-pass correctness, and regression count.

#### Scenario: Quality report is generated
- **WHEN** an evaluation run completes
- **THEN** a report is produced with metric values and pass/fail status against defined thresholds

### Requirement: Correctness-first KPI priority
The platform SHALL treat functional correctness and non-regression as primary evaluation outcomes for promotion decisions.

#### Scenario: Correctness gate is evaluated before speed
- **WHEN** a candidate update is evaluated
- **THEN** promotion is blocked if correctness or non-regression criteria fail, regardless of speed-oriented metrics

### Requirement: Release gating on evaluation thresholds
Agent and skill updates SHALL be blocked from promotion when quality thresholds are not met.

#### Scenario: Threshold failure blocks promotion
- **WHEN** any required metric falls below threshold
- **THEN** the update is marked non-promotable and remediation actions are required

### Requirement: Global minimum thresholds across stacks
The platform SHALL apply globally fixed minimum quality thresholds across all supported stacks.

#### Scenario: Stack-independent threshold enforcement
- **WHEN** evaluation results are computed for any stack
- **THEN** the same global minimum thresholds are used to determine pass/fail status

### Requirement: Numeric global quality thresholds
The platform SHALL enforce the following global minimum thresholds for promotion decisions: first-pass correctness >= 95%, regression count = 0, TDD red-first rate = 100%, TDD green pass rate = 100%, TDD refactor safety rate >= 95%, OpenSpec critical scenario coverage = 100%, OpenSpec total scenario coverage >= 95%, strict OpenSpec validation pass = 100%, and unresolved high/critical security findings = 0.

#### Scenario: Candidate fails correctness threshold
- **WHEN** first-pass correctness is below 95%
- **THEN** promotion is blocked and remediation is required

#### Scenario: Candidate introduces regressions
- **WHEN** regression count is greater than 0
- **THEN** promotion is blocked regardless of other metric values

#### Scenario: Candidate fails mandatory TDD evidence
- **WHEN** red-first rate or green pass rate is below 100%
- **THEN** promotion is blocked and the missing TDD phase evidence is reported

#### Scenario: Candidate fails refactor-safety threshold
- **WHEN** refactor safety rate is below 95%
- **THEN** promotion is blocked pending additional refactor validation

#### Scenario: Candidate fails coverage or strict validation
- **WHEN** critical scenario coverage is below 100%, total scenario coverage is below 95%, or strict OpenSpec validation fails
- **THEN** promotion is blocked until compliance is restored

#### Scenario: Candidate has unresolved severe security findings
- **WHEN** unresolved high or critical security findings are greater than 0
- **THEN** promotion is blocked until findings are resolved or formally mitigated

### Requirement: Structured runtime-definition validation
The validation suite SHALL parse and validate agent frontmatter, skill frontmatter, manifests, catalogs, packs, and referenced paths as structured data rather than relying only on raw substring presence.

#### Scenario: Skill is missing native frontmatter
- **WHEN** a repository-owned `SKILL.md` lacks a parseable `name` or `description`
- **THEN** validation fails and identifies the skill path and missing field

#### Scenario: Catalog and runtime names diverge
- **WHEN** an agent catalog entry does not match the runtime name derived from its path
- **THEN** validation fails with both names and the affected path

#### Scenario: Deprecated broad tools remain during this change
- **WHEN** an agent still uses the deprecated `tools` field
- **THEN** validation emits a non-blocking follow-up warning
- **AND** does not fail solely because least-privilege permission migration is deferred

### Requirement: Native consumer discovery validation
The validation suite SHALL create a disposable consumer fixture and use installed OpenCode debug commands to verify resolved skills, agents, and configuration.

#### Scenario: Consumer fixture is validated
- **WHEN** runtime contract validation runs
- **THEN** `opencode debug skill` contains every repository-owned skill
- **AND** `opencode debug agent orchestrator` resolves the expected agent
- **AND** `opencode debug config` selects `orchestrator` as the default agent

### Requirement: Runner integration validation
The validation suite SHALL exercise runner behavior from the platform source layout, the consumer `.opencode` layout, and a global-module layout invoked from an external consumer working directory.

#### Scenario: Consumer change is bundled
- **WHEN** the fixture invokes `.opencode/opencode-runner.sh bundle --change fixture-change`
- **THEN** the bundle references the consumer root and consumer-owned change path
- **AND** module-owned agents, skills, and packs are included from `.opencode`

#### Scenario: Global consumer change is bundled
- **WHEN** the fixture invokes a platform runner outside the consumer tree from the consumer working directory
- **THEN** the bundle references the external consumer root and consumer-owned change path
- **AND** module-owned agents, skills, and packs are included from the platform checkout

#### Scenario: Pack content is checked
- **WHEN** a bundle is generated with `--pack angular`
- **THEN** validation confirms that Angular constraints and verification commands are present

#### Scenario: Unique pack inference is checked
- **WHEN** a fixture matches exactly one non-generic pack's required markers
- **THEN** validation confirms that the orchestrator selects that pack and reports its evidence

#### Scenario: Ambiguous pack inference is checked
- **WHEN** a fixture matches multiple non-generic packs
- **THEN** validation confirms that phase work is blocked pending operator confirmation

#### Scenario: Unsupported stack inference is checked
- **WHEN** a fixture matches no non-generic pack
- **THEN** validation confirms that `generic` is not silently selected
- **AND** the result requests explicit generic confirmation or a new pack definition

#### Scenario: Default reference behavior is checked
- **WHEN** a bundle is generated without `--references`
- **THEN** validation confirms skill reference bodies are absent
- **AND** size diagnostics are present

### Requirement: Distribution integrity validation
The validation suite SHALL fail on recursive self-submodule declarations, unresolved catalog paths, invalid phase-skill mappings, duplicate IDs, missing manifests, invalid pack detection metadata, and tracked `Zone.Identifier` sidecar files.

#### Scenario: Self-submodule is introduced
- **WHEN** `.gitmodules` declares the platform repository at `.opencode`
- **THEN** validation fails before runtime fixture execution

#### Scenario: Windows sidecar is tracked
- **WHEN** Git tracks a path ending in `:Zone.Identifier`
- **THEN** validation fails and lists the path for removal

### Requirement: Bundle size reporting without promotion threshold
The evaluation harness SHALL record bundle byte, line, and approximate token measurements for representative fixtures without using those measurements as a promotion gate in this change.

#### Scenario: Representative bundles are evaluated
- **WHEN** evaluation runs for generic, Angular, and Go/AWS fixtures
- **THEN** bundle size measurements are included in the report
- **AND** no candidate fails solely because of bundle size

### Requirement: Token-saving defaults contract integration

The main validation runner SHALL execute a dedicated contract for versioned Caveman and RTK defaults.

#### Scenario: Full validation runs

- **WHEN** `scripts/validate/run-all.sh` executes
- **THEN** it runs `scripts/validate/token-savings-defaults-contract.sh`
- **AND** any token-saving contract failure fails the full validation run

### Requirement: Bundled OpenSpec CLI contract coverage
The validation suite SHALL verify the exact OpenSpec dependency and module-local runner selection.

#### Scenario: Runner doctor executes after npm install
- **WHEN** the runner contract invokes doctor
- **THEN** doctor reports `${MODULE_DIR}/node_modules/.bin/openspec`
- **AND** reports OpenSpec version `1.1.1`

#### Scenario: Dependency metadata drifts
- **WHEN** `package.json` does not declare exact runtime dependency `@fission-ai/openspec` version `1.1.1`
- **THEN** the distribution contract fails with an actionable message
