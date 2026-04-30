## 1. Skill Migration

- [x] 1.1 Add `skill/playwright-cli/manifest.yaml` in the repository-native skill format.
- [x] 1.2 Migrate `SKILL.md` and all Playwright reference documents from `.claude/skills/playwright-cli/` to `skill/playwright-cli/`.
- [x] 1.3 Remove the duplicated `.claude/skills/playwright-cli/` copy after migration.

## 2. Frontend Composition

- [x] 2.1 Update `skill/web-ui-ux/` guidance to explain when `$playwright-cli` should be used alongside `$web-ui-ux`.
- [x] 2.2 Update frontend-facing docs (`README.md`, `CONTRIBUTING.md`, and/or Angular pack docs) to describe the `web-ui-ux` + `playwright-cli` workflow.

## 3. Validation

- [x] 3.1 Add validation coverage for the new `playwright-cli` skill and its composition with `web-ui-ux`.
- [x] 3.2 Run affected validation scripts.
- [x] 3.3 Run `openspec validate "integrate-playwright-cli-skill" --strict`.
