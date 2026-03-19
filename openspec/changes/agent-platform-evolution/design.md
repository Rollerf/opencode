## Context

The repository is used as a transversal OpenCode/OpenSpec foundation across projects with diverse stacks and delivery models. Current value is high, but scale introduces risks: inconsistent agent behavior, duplicated stack logic, unclear routing, and no objective quality gate for changes in prompts/skills. The architecture must preserve one common workflow while enabling stack-specific specialization.

## Goals / Non-Goals

**Goals:**
- Create one stable core contract for phases, artifact expectations, and evidence requirements.
- Enforce TDD as the default and required implementation method across all supported stacks.
- Enable stack-aware customization through additive packs rather than forked workflows.
- Provide deterministic agent routing based on phase and task intent.
- Add quality measurement and regression detection before rolling out changes.
- Define governance controls for local-only autonomy, security, and clear handoff to external operators.

**Non-Goals:**
- Building runtime orchestration services outside repository-level conventions.
- Managing non-local lifecycle operations (integration, staging, production) that belong to another operator.
- Rewriting all existing agents/skills in one iteration.

## Decisions

1. Core-first architecture with extension packs.
   - Decision: Keep one canonical workflow contract in core, and attach stack behavior through pack overlays.
   - Rationale: Reduces drift and makes behavior portable across projects.
   - Alternative considered: Separate agent sets per stack. Rejected due to duplication and maintenance cost.

2. Routing by work type and phase, not by language first.
   - Decision: Route to planner/implementer/verifier/archiver and specialized subagents by intent; stack context is a secondary selector.
   - Rationale: Most developer requests map to process intent before technology details.
   - Alternative considered: Route primarily by stack. Rejected because mixed tasks (docs, design, refactor) would fragment.

3. Golden-task evaluation as release gate.
   - Decision: Maintain versioned eval suites by stack and cross-stack, with pass thresholds required for updates.
   - Rationale: Makes quality measurable and prevents silent regressions.
   - Alternative considered: Manual spot checks. Rejected for low repeatability.

4. Local-only operational boundary.
   - Decision: Restrict OpenCode scope to local development activities and define explicit handoff requirements for any non-local lifecycle step.
   - Rationale: Aligns with operating model ownership and avoids overlap with external operators.
   - Alternative considered: Multi-environment automation from this repository. Rejected because it violates ownership boundaries.

5. Structured output contract for every agent execution.
   - Decision: Require phase declaration, touched files, command evidence, blockers, and missing decisions in every non-trivial response.
   - Rationale: Improves traceability and verification readiness.
   - Alternative considered: Free-form responses. Rejected because validation and audit become difficult.

6. Mandatory TDD across technologies.
   - Decision: Require RED -> GREEN -> REFACTOR workflow for all behavior changes, regardless of stack.
   - Rationale: Improves defect prevention, keeps changes incremental, and standardizes engineering discipline across heterogeneous projects.
   - Alternative considered: Stack-specific testing approaches without mandatory TDD. Rejected due to inconsistent quality outcomes.

7. Primary KPI for Q1 is correctness and non-regression.
   - Decision: Prioritize first-pass correctness and regression prevention over delivery speed metrics.
   - Rationale: Functional correctness and protection of existing behavior are the core quality objectives.
   - Alternative considered: Time-to-PR as primary KPI. Rejected because speed without reliability increases downstream cost.

8. Globally fixed quality thresholds.
   - Decision: Use a global minimum quality bar shared by all stacks from day one.
   - Rationale: Ensures consistent engineering standards independent of implementation technology.
   - Alternative considered: Stack-specific thresholds at launch. Rejected to avoid uneven quality expectations.
   - Initial global thresholds:
     - First-pass correctness >= 95%
     - Regression count = 0
     - TDD red-first rate = 100%
     - TDD green pass rate = 100%
     - TDD refactor safety rate >= 95%
     - OpenSpec critical scenario coverage = 100%
     - OpenSpec total scenario coverage >= 95%
     - `openspec validate --strict` pass = 100%
     - Unresolved high/critical security findings = 0

9. Standard handoff package to external operators.
   - Decision: Require a single handoff artifact template with summary, validated evidence, pending non-local actions, required inputs, and ownership.
   - Rationale: Reduces ambiguity at local-to-operator boundaries and speeds transition.
   - Alternative considered: Free-form handoff notes. Rejected because it creates operational gaps.

## Risks / Trade-offs

- [Increased process overhead] -> Mitigation: keep templates concise and automate boilerplate generation.
- [Too many packs causing fragmentation] -> Mitigation: enforce core compliance checks and periodic pack consolidation.
- [Evaluation suite becomes stale] -> Mitigation: require eval updates whenever major workflow or stack capability changes.
- [Boundary confusion with external operators] -> Mitigation: define explicit local-vs-non-local action matrix and mandatory handoff notes.
- [Perceived slowdown from strict TDD] -> Mitigation: scope tasks into small increments and optimize test execution with pack-specific fast feedback commands.

## Migration Plan

1. Establish core contracts and templates in `core/` and OpenSpec change templates.
2. Implement first stack pack (`go-aws`) and run pilot in one active project.
3. Add routing matrix and agent catalog metadata.
4. Build initial eval harness with 10-20 golden tasks for pilot stack.
5. Add `java-onprem` and `angular` packs after pilot criteria pass.
6. Enforce quality and governance gates for local development flow and handoff readiness.

Rollback strategy:
- Keep new capabilities additive and feature-flagged by pack activation.
- Revert pack-specific overlays without changing core contract if regressions appear.

## Open Questions

- None at this stage.
