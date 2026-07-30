## 1. Shared Web UI Skill

- [x] 1.1 Add `skill/web-ui-ux/SKILL.md` with reusable web UI guidance for visual audit, component reuse, state coverage, responsive behavior, accessibility, and evidence expectations.
- [x] 1.2 Add `skill/web-ui-ux/manifest.yaml` with metadata and explicit invocation tag.

## 2. Angular-First Integration

- [x] 2.1 Update `packs/angular/README.md` and `packs/angular/pack.yaml` so Angular UI work uses the shared `web-ui-ux` skill plus Angular-specific commands.
- [x] 2.2 Update `agents/implementer.md`, `agents/orchestrator.md`, and `core/routing-policy.md` with explicit Angular UI/frontend trigger guidance that applies `web-ui-ux` without introducing a new Angular subagent.
- [x] 2.3 Add explicit routing guidance that Angular UI/frontend intent must not activate `backend-design` or backend-oriented design paths.

## 3. Pack-Aware Skill Selection

- [x] 3.1 Update `opencode-runner.sh` so session bundle skill selection can account for active pack and UI/frontend intent instead of using backend-oriented defaults for every implementation task.
- [x] 3.2 Ensure Angular implementation bundles can include `web-ui-ux` as part of the selected guidance set.
- [x] 3.3 Ensure Angular frontend/UI bundles exclude `backend-design` unless the request also includes explicit backend work.

## 4. Validation and Documentation

- [x] 4.1 Add or update validation coverage for the new skill and its Angular integration path.
- [x] 4.2 Add or update validation coverage for frontend exclusion of `backend-design` in Angular UI/frontend flows.
- [x] 4.3 Update `README.md` and `CONTRIBUTING.md` to describe when to use `web-ui-ux`, when not to use `backend-design`, and how the model composes with Angular today and future web packs later.

## 5. Verification

- [x] 5.1 Run `./opencode-runner.sh list skills`.
- [x] 5.2 Run affected validation scripts.
- [x] 5.3 Run `openspec validate "add-web-ui-ux-foundation" --strict`.
