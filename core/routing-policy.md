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

## Single-entrypoint orchestration

`orchestrator.md` is the default interactive entrypoint. Routing selects the phase contract to apply, but it does not require a manual switch to `planner.md`, `implementer.md`, `verifier.md`, or `archiver.md` when the orchestrator can execute the selected local workflow safely.

Use phase agents and subagents as contracts or targeted helpers:

- Apply `planner.md`, `implementer.md`, `verifier.md`, and `archiver.md` rules according to the selected phase.
- Invoke specialized subagents only when expertise, parallelism, context reduction, or a distinct deliverable justifies the handoff.
- Keep the orchestrator responsible for final decisions, command evidence, touched files, blockers, and missing decisions.

## Angular frontend/UI requests

For Angular frontend/UI requests:

- Keep routing intent-first and select `implementer.md` for implementation work.
- Apply the Angular pack as the active stack context.
- Activate `$web-ui-ux` for frontend/UI, responsive, visual polish, component, layout, and design-system intent.
- Exclude `$backend-design` for frontend-only Angular work.
- Allow `$backend-design` only when backend scope is explicit in the request.

## Repository-local skill fallback

The runtime `available_skills` registry can be narrower than the skills imported in this module. When a route asks for a module-owned skill such as `$web-ui-ux`, first prefer the runtime skill loader. If the runtime registry does not list it, but a repository-local skill file exists at `skill/<name>/SKILL.md` or `.opencode/skill/<name>/SKILL.md`, load and apply that file as the specialization.

Only emit `missing_specialization` when neither the runtime registry nor the repository-local skill file provides the requested specialization.

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
