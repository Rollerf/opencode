# OpenCode + OpenSpec Agent Platform

Cross-cutting repository for working with OpenCode and OpenSpec across projects with different stacks (for example Go/AWS, Java on-prem, Angular).

Its goal is to provide a shared base of agents, skills, quality rules, and workflow so day-to-day development stays consistent, verifiable, and focused on preventing regressions.

## What it is for

- Standardize how changes are planned, implemented, verified, and archived with OpenSpec.
- Reuse agents and skills across projects without duplicating prompts per stack.
- Enforce TDD (RED -> GREEN -> REFACTOR) for behavior changes.
- Maintain a global quality bar, independent of technology.
- Limit automation to local environments and provide explicit handoff to external operators.

## How it works

The platform is made up of 5 parts:

1. `agents/`: agents by phase (planner, implementer, verifier, archiver, orchestrator, and sub-agents).
2. `skill/`: reusable skills (`openspec-workflow`, `backend-design`, `web-ui-ux`, optional n8n skills).
3. `core/`: shared workflow contract, agent catalog, routing policy, and templates.
4. `packs/`: extensions by stack (`go-aws`, `java-onprem`, `angular`, `generic`).
5. `evals/` + `scripts/`: automated evaluation and validation of contracts and quality thresholds.

Routing is intent-first:

- First, the type of work is detected (planning, implementation, verification, archive, docs, etc.).
- Then, the context of the active stack pack is applied.

## Operating principles

- **Mandatory TDD** for behavior changes: RED -> GREEN -> REFACTOR.
- **Conventional Commits in English** for all repositories and stacks.
- **Trunk-based development**: short-lived branches and PR-based integration to `main`.
- **Correctness and no regression** as the main KPI.
- **Global thresholds** for any stack.
- **Local-only execution**: staging/production actions are not automated.
- **Mandatory handoff** to an external operator when the flow leaves local.

## Main structure

```text
agents/                    # Agents by phase and sub-agents
skill/                     # Reusable skills
third_party/n8n_skills/    # Optional external n8n skills source (submodule)
core/                      # Shared contract and templates
packs/                     # Pack per stack (go-aws, java-onprem, angular, generic)
governance/                # Local-only matrix, security baseline, handoff, audit
evals/                     # Golden tasks + global thresholds
scripts/
  evals/                   # Evaluation runner
  validate/                # Contract/TDD validators
openspec/changes/          # OpenSpec changes (proposal/design/specs/tasks/evidence)
opencode-runner.sh         # Command helper for OpenSpec phases
```

## Quick start

This README is the canonical command reference for `opencode-runner.sh`.

1) Check environment health:

```bash
./opencode-runner.sh doctor
```

2) View available agents and skills:

```bash
./opencode-runner.sh list agents
./opencode-runner.sh list skills
./opencode-runner.sh bundle --phase implementation --pack angular --user-prompt "Polish the Angular dashboard UI"
```

3) Run OpenSpec phase in dry-run mode:

```bash
./opencode-runner.sh phase planning --change <my-change> --dry-run
./opencode-runner.sh phase implementation --change <my-change> --dry-run
./opencode-runner.sh phase verification --change <my-change> --dry-run
./opencode-runner.sh phase archive --change <my-change> --dry-run
```

4) Validate contracts and TDD:

```bash
./scripts/validate/run-all.sh

# or run each validator individually
./scripts/validate/contracts.sh
./scripts/validate/tdd-contract.sh
./scripts/validate/angular-ui-contract.sh
./scripts/validate/n8n-skills-contract.sh
```

5) Run quality harness:

```bash
./scripts/evals/run-all.sh
```

## Web UI / Angular frontend guidance

- Use `$web-ui-ux` for frontend/UI tasks involving layout, visual polish, responsive behavior, state coverage, or component reuse.
- Under `packs/angular`, frontend-only work should use `$web-ui-ux` and should not load `$backend-design`.
- If a request explicitly combines Angular UI work with backend changes, the guidance set may include both `$web-ui-ux` and `$backend-design`.
- Future web packs (for example Astro) should reuse `web-ui-ux` for cross-framework UI quality guidance and add framework-specific overlays separately.

## Global quality thresholds

Defined in `evals/config/global-thresholds.json`.

## Optional n8n support

This repository supports optional n8n skills through `third_party/n8n_skills`.

- Default behavior: n8n skills are not loaded for non-n8n requests.
- Activation: request n8n explicitly (for example, "build an n8n workflow").
- Gateway strategy: `$n8n-gateway` -> `$n8n-mcp-tools-expert`.

If the submodule is not initialized in a consumer project:

```bash
git submodule update --init --recursive third_party/n8n_skills
```

- first-pass correctness >= 95
- regressions = 0
- tdd red-first rate = 100
- tdd green pass rate = 100
- tdd refactor safety rate >= 95
- critical scenario coverage = 100
- total scenario coverage >= 95
- strict validation pass rate = 100
- high/critical security findings = 0

## How to use it in other projects

1. Keep OpenSpec as the source of truth for the change (`proposal`, `design`, `specs`, `tasks`).
2. Choose the right pack for the stack (`packs/go-aws`, `packs/java-onprem`, `packs/angular`, or `packs/generic`).
3. Run implementation with TDD evidence.
4. Verify against global thresholds.
5. If the flow needs to leave local, generate handoff for an external operator using `governance/operator-handoff-template.md`.

## Create or extend capability

- New agent: add file in `agents/` and register metadata in `core/agent-catalog.yaml`.
- New skill: create `skill/<name>/manifest.yaml` + `SKILL.md` and validate its routing/pack integration.
- New stack pack: create `packs/<stack>/pack.yaml` + `README.md` with verification and TDD commands.
- New global rule: update `core/workflow-contract.md` and validation scripts in `scripts/validate/`.
- New quality metric: update `evals/config/global-thresholds.json` and `scripts/evals/run-all.sh`.

## Notes

- This repo does not replace the operator for non-local environments.
- Its focus is maximizing quality and productivity in local development with OpenSpec traceability.
