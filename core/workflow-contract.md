# Core Workflow Contract

This contract is mandatory for all agents and stack packs in this repository.

## Phase Contract

Every non-trivial response MUST include:

1. Current phase.
2. Touched files.
3. Executed commands.
4. Blockers.
5. Missing decisions.

## TDD Contract

For every behavior-changing implementation task, the workflow MUST include:

1. RED: a failing test before production code changes.
2. GREEN: the minimal implementation that makes tests pass.
3. REFACTOR: cleanup while keeping tests green.

Required evidence fields:

- `red_evidence`: command and failing result summary.
- `green_evidence`: command and passing result summary.
- `refactor_evidence`: command and passing result summary after cleanup.

## Commit Convention Contract

All repositories and all stacks SHALL use Conventional Commits for commit messages.

Required baseline:

1. Commit messages are in English.
2. Commit header follows `<type>(<optional-scope>): <description>`.
3. Use standard types such as `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.

## Local-Only Operational Boundary

Autonomous execution is restricted to local development workflows.

Blocked categories:

- Integration, staging, or production lifecycle operations.
- Release approvals and deployment orchestration.
- External environment changes owned by another operator.

## Response Skeleton

Use this skeleton for implementation and verification responses:

```text
Fase actual: <planning|implementation|verification|archive>
Archivos tocados:
- <path>
Comandos ejecutados:
- <command>
Bloqueadores:
- <none or description>
Decisiones pendientes:
- <none or description>
```
