# Contributing Guide

Thanks for contributing to this repository.

This project defines a cross-cutting platform of agents and skills for OpenCode + OpenSpec, focused on local development, mandatory TDD, and consistent global quality across stacks.

## Base rules

1. Always work on an OpenSpec change in `openspec/changes/<name>/`.
2. Keep artifact order: `proposal -> specs -> design -> tasks`.
3. For behavior changes, apply TDD: `RED -> GREEN -> REFACTOR`.
4. Do not automate non-local actions (staging/production are handled by an external operator).
5. Do not lower global quality thresholds for a specific stack.
6. Use Conventional Commits for every commit in English.
7. Use gitflow for branch lifecycle across all consumer projects.

## Branching strategy (gitflow)

1. Create a dedicated `feature/<change-name>` branch from `develop` for each OpenSpec change.
2. Keep one OpenSpec change mapped to one feature branch.
3. Merge completed feature branches into `develop`.
4. Create `release/*` branches from `develop` when a releasable set of changes is ready.
5. Merge the release branch into `main`.
6. After release merges to `main`, sync `main` back into `develop`.
7. Require passing checks before merge:
   - `.github/workflows/dependency-review.yml`
   - `.github/workflows/codeql.yml`
   - `./scripts/validate/run-all.sh`
8. Prefer a merge strategy that preserves the intended gitflow history for the target repository.
9. Never commit directly to `main` except controlled emergency fixes.

## Global distribution through `main`

The workstation-wide OpenCode installation is a checkout of this repository at `~/.config/opencode` on the `main` branch. Therefore:

1. Treat `main` as the stable distribution channel for all local projects.
2. Do not consider a feature globally available until it has passed `feature -> develop -> release -> main` and `main` has been pushed.
3. Update the global checkout only after the release reaches `origin/main`.
4. Preserve and reconcile machine-local `opencode.json`, package metadata, commits, and uncommitted changes before updating the global checkout.
5. Run dependency/submodule setup and restart OpenCode after updating because configuration-time definitions are not hot-reloaded.
6. Keep non-local `push`, release merge, and global checkout update as explicit operator actions with command evidence.
7. Keep portable runtime defaults such as `instructions/caveman-default.md` and `plugins/rtk.ts` versioned so global installations receive them through `git pull`.
8. Keep provider credentials, MCP endpoints, permissions, absolute references, and the active `opencode.json` machine-owned; merge `core/templates/opencode.global.json` into new or existing installations instead of overwriting local configuration.

## Recommended flow

1. Create or select an OpenSpec change.
2. Create its matching `feature/<change-name>` branch from `develop`.
3. Prepare planning artifacts.
4. Implement tasks in small, reversible changes.
5. Verify contracts, TDD, and thresholds.
6. Merge the feature back into `develop`, continue through `release/*`, merge into `main`, and sync `main` back into `develop`.
7. Leave a handoff if there are non-local steps.

## Useful commands

The commands below assume the platform source checkout. In a consumer project, try `./.opencode/opencode-runner.sh` and then `$HOME/.config/opencode/opencode-runner.sh` when `./opencode-runner.sh` is absent. Invoke the selected runner from the consumer project root.

```bash
./opencode-runner.sh doctor
./opencode-runner.sh list agents
./opencode-runner.sh list skills

./opencode-runner.sh phase planning --change <change> --dry-run
./opencode-runner.sh phase implementation --change <change> --dry-run
./opencode-runner.sh phase verification --change <change> --dry-run
./opencode-runner.sh phase archive --change <change> --dry-run

./scripts/validate/contracts.sh
./scripts/validate/gitflow-branching-contract.sh
./scripts/validate/tdd-contract.sh
./scripts/validate/angular-ui-contract.sh
./scripts/validate/web-ui-ux-contract.sh
./scripts/validate/playwright-cli-contract.sh
./scripts/validate/n8n-skills-contract.sh
./scripts/validate/seo-expert-contract.sh
node ./scripts/validate/runtime-definitions.mjs --self-test
node ./scripts/validate/runtime-definitions.mjs
./scripts/validate/runtime-runner-contract.sh
./scripts/validate/runtime-consumer-contract.sh
./scripts/validate/run-all.sh
./scripts/evals/run-all.sh
openspec validate "<change>" --strict
```

## How to add or change an agent

Checklist:

- [ ] Create or edit a file in `agents/`.
- [ ] Keep phase and evidence policies (phase, touched files, commands, blockers, decisions).
- [ ] Keep TDD for behavior changes.
- [ ] Register metadata in `core/agent-catalog.yaml`.
- [ ] Keep phase contracts in `skill/openspec-*/`, not as additional primary agents.
- [ ] Set the approved model, step limit, and `permission.task: deny` for leaf subagents.
- [ ] Adjust routing if applicable in `core/routing-policy.md`.
- [ ] Validate with `./scripts/validate/contracts.sh`.

## How to add or change a skill

Checklist:

- [ ] Edit the skill in `skill/<name>/`.
- [ ] For n8n wrappers, keep references aligned with `third_party/n8n_skills`.
- [ ] Keep instructions aligned with OpenSpec and the core contract.
- [ ] If the skill targets frontend/UI work, document when `$web-ui-ux` applies and when `$backend-design` must stay excluded.
- [ ] If the skill provides browser tooling, document when it composes with `$web-ui-ux`.
- [ ] If the skill targets SEO, keep activation explicit, require inspection and validation evidence, and run `./scripts/validate/seo-expert-contract.sh`.
- [ ] If you add references, include them in `skill/<name>/references/`.
- [ ] Verify that agents depending on the skill remain consistent.

## How to add a new stack pack

Checklist:

- [ ] Create `packs/<stack>/pack.yaml`.
- [ ] Create `packs/<stack>/README.md`.
- [ ] Define deterministic `detection.required` markers using only `path_exists` and literal `file_contains`.
- [ ] Do not add automatic detection to the `generic` pack.
- [ ] Define `verification_commands` (test/build/lint).
- [ ] Define `tdd_commands` (red/green/refactor).
- [ ] If the pack supports frontend/UI work, define `skill_overlays` for shared UI guidance and explicit exclusions.
- [ ] Include `local_only: true` and prohibited non-local actions.
- [ ] Align the security baseline in `governance/security-compliance-baseline.md`.
- [ ] Validate with `./scripts/validate/tdd-contract.sh`.

## How to change global thresholds

Checklist:

- [ ] Update `evals/config/global-thresholds.json`.
- [ ] Adjust `scripts/evals/run-all.sh` if gate logic changes.
- [ ] Update related docs (`README.md`, OpenSpec change docs).
- [ ] Run `./scripts/evals/run-all.sh` with representative metrics.

## Handoff to external operator

If the change requires non-local actions:

- Use `governance/operator-handoff-template.md`.
- Include TDD evidence and validations.
- List pending non-local actions, required inputs, and ownership.

## Contribution acceptance criteria

A contribution is considered ready when:

1. It complies with OpenSpec and passes `openspec validate "<change>" --strict`.
2. It keeps TDD for behavior changes.
3. It does not introduce regressions.
4. It passes contract/TDD validators and the evaluation harness.
5. It leaves traceability and handoff documentation (if applicable).
