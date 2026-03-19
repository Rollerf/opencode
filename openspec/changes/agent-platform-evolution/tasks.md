## 1. Core Workflow Contracts

- [x] 1.1 Define and document mandatory phase output contract (phase, touched files, commands, blockers, missing decisions).
- [x] 1.2 Add reusable templates for `proposal.md`, `design.md`, `specs/*/spec.md`, and `tasks.md` aligned with contract rules.
- [x] 1.3 Add validation checks to ensure required fields are present in non-trivial responses and review artifacts.
- [x] 1.4 Add mandatory TDD contract checks requiring explicit RED, GREEN, and REFACTOR evidence for behavior changes.

## 2. Stack Capability Packs

- [x] 2.1 Create `go-aws` pack with architecture constraints, test/build/lint commands, and deployment safety notes.
- [x] 2.2 Create `java-onprem` pack with build/test conventions, environment assumptions, and operational guardrails.
- [x] 2.3 Create `angular` pack with workspace conventions, test/lint/build commands, and UI-specific guardrails.
- [x] 2.4 Create `generic` fallback pack for unsupported stacks with minimal safe defaults.
- [x] 2.5 Define stack-specific RED/GREEN/REFACTOR command sequences in every pack.

## 3. Agent Catalog and Routing

- [x] 3.1 Define canonical agent taxonomy with metadata: phase scope, specialization, expected inputs, and outputs.
- [x] 3.2 Implement intent-first routing policy with stack context as secondary selector.
- [x] 3.3 Implement explicit fallback routing to a workflow-safe general agent and decision-gap reporting.

## 4. Evaluation Harness

- [x] 4.1 Define golden-task suites (cross-stack and per-stack) covering planning, implementation, verification, docs, and refactor flows.
- [x] 4.2 Implement evaluation scoring for success rate, first-pass correctness, and regression count.
- [x] 4.3 Define promotion thresholds and blocking behavior for failed evaluations.
- [x] 4.4 Add a repeatable evaluation command and document usage (for example: `./scripts/evals/run-all.sh`).
- [x] 4.5 Add TDD conformance metrics (red-first rate, green pass rate, refactor safety pass rate) to evaluation scoring.
- [x] 4.6 Implement globally fixed thresholds: first-pass >=95%, regressions=0, red-first=100%, green=100%, refactor-safety>=95%, critical coverage=100%, total coverage>=95%, strict validation=100%, high/critical security findings=0.

## 5. Governance and Safety Controls

- [x] 5.1 Define local-only autonomy matrix with explicit blocked non-local actions.
- [x] 5.2 Define minimum security/compliance baseline required for every stack pack.
- [x] 5.3 Add audit-trail requirements for high-impact commands and linkages to OpenSpec change identifiers.
- [x] 5.4 Define mandatory handoff artifact template for external operators (pending actions, required inputs, ownership).
- [x] 5.5 Specify mandatory baseline controls (secrets, dependencies/licenses, vulnerabilities, prohibited high-risk commands) and verification method for each.

## 6. Pilot, Verification, and Rollout

- [ ] 6.1 Run pilot using `go-aws` pack in one active project and collect baseline productivity/quality metrics.
- [ ] 6.2 Expand pilot to `java-onprem` and `angular` after go/no-go criteria are met.
- [x] 6.3 Execute strict validation: `openspec validate "agent-platform-evolution" --strict`.
- [ ] 6.4 Publish rollout decision with KPI results, unresolved risks, and follow-up change proposals.
