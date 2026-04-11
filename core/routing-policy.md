# Intent-First Routing Policy

Routing is deterministic and intent-first.

## Primary Selector: Workflow Intent

1. Planning artifacts (`proposal`, `design`, `specs`, `tasks`) -> `planner.md`.
2. Code implementation from `tasks.md` -> `implementer.md`.
3. Readiness checks and traceability -> `verifier.md`.
4. Archive/closure -> `archiver.md`.
5. Documentation requests -> `subagent/code-documentation-subagent.md`.
6. Design-document requests -> `subagent/design-doc-subagent.md`.
7. Feature iteration/refactor -> `subagent/feature-iteration-subagent.md`.
8. Pulumi/IaC requests -> `subagent/pulumi-infrastructure-subagent.md`.
9. TDD test planning/creation -> `subagent/tdd-tests-subagent.md`.
10. n8n workflow design/debug/validation requests -> apply `$n8n-gateway` then `$n8n-mcp-tools-expert`.

## Secondary Selector: Stack Pack

After intent is resolved, apply the active stack pack:

- `packs/go-aws`
- `packs/java-onprem`
- `packs/angular`
- `packs/generic`

Stack pack influence is limited to constraints, command sets, and test strategy.

## Optional n8n Skill Routing

Apply n8n skills only when intent is explicit or strongly implied.

Trigger examples:

- "build an n8n workflow"
- "fix n8n validation errors"
- "configure n8n node expressions"
- "use n8n-mcp tools"

Default behavior for non-n8n requests: do not load n8n skills.

## Fallback Policy

If no specialized route is available:

1. Route to `orchestrator.md` in safe mode.
2. Enforce core workflow contract and local-only boundary.
3. Emit a decision gap with required specialization.

Required fallback output field:

`missing_specialization: <what is missing and why it matters>`
