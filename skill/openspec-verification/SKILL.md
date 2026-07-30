---
name: openspec-verification
description: Use when validating implementation completeness, correctness, traceability, and readiness against OpenSpec artifacts.
---

# OpenSpec Verification Contract

Apply this phase contract after the stack pack has been resolved.

## Entry criteria

- One active change has implementation evidence.
- Proposal, design, specs, and tasks are available as source of truth.

## Workflow

1. Verify hard-spec readiness and implementation completeness.
2. Map every requirement and scenario to implementation and tests.
3. Review task completion and RED/GREEN/REFACTOR evidence.
4. Run strict OpenSpec validation and the resolved pack's test, build, lint, and safety checks.
5. Report findings as CRITICAL, WARNING, or SUGGESTION with exact remediation.
6. Do not modify implementation merely to hide a verification finding.

## Completion criteria

- Strict validation and required checks pass.
- No unresolved CRITICAL finding remains.
- Traceability and residual test gaps are reported.
- The response reports touched files, commands, blockers, and missing decisions.
