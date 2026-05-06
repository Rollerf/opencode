## ADDED Requirements

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
