## Context

This repository already distinguishes between shared visual/frontend guidance (`web-ui-ux`) and stack-specific execution details. The Playwright CLI material installed under `.claude/skills/playwright-cli` is useful, but it is currently outside the repository-native skill catalog and therefore not part of the platform that consumer projects import.

The right model is not to merge Playwright automation directly into `web-ui-ux`, because `web-ui-ux` is a higher-level UX/design workflow. Instead, `playwright-cli` should become a separate operational skill that `web-ui-ux` and Angular UI flows can recommend or compose when browser evidence, tracing, or test generation is needed.

## Goals / Non-Goals

**Goals:**
- Migrate `.claude/skills/playwright-cli` into the repository skill system.
- Preserve the useful reference material for snapshots, tracing, storage, request mocking, and Playwright tests.
- Make the relationship between `web-ui-ux` and `playwright-cli` explicit.
- Remove duplicate skill storage after the migration.

**Non-Goals:**
- Rewriting the Playwright CLI content from scratch.
- Replacing existing Angular pack Playwright commands.
- Introducing a new frontend subagent.

## Decisions

1. `playwright-cli` becomes a standalone reusable skill.
   - Decision: create `skill/playwright-cli/manifest.yaml`, `SKILL.md`, and `references/`.
   - Rationale: browser automation is operational guidance that can be reused by multiple frontend stacks and composed with `web-ui-ux`.
   - Alternative considered: merge it into `web-ui-ux`. Rejected because it would mix visual design guidance with low-level browser tooling.

2. `web-ui-ux` references `playwright-cli` rather than absorbing it.
   - Decision: update `web-ui-ux` docs/guidance so browser evidence flows can call into `$playwright-cli`.
   - Rationale: this keeps responsibilities clean while improving the frontend workflow.
   - Alternative considered: keep the relationship implicit. Rejected because users and agents would miss the composition path.

3. Repository-native copy becomes the source of truth.
   - Decision: remove `.claude/skills/playwright-cli` after migration.
   - Rationale: duplicated skill sources drift quickly and confuse consumers about which version is authoritative.
   - Alternative considered: keep both copies. Rejected because it would create maintenance debt.

## Risks / Trade-offs

- [Playwright CLI tool may not exist in every consumer environment] -> Mitigation: document it as a skill for environments where the CLI is installed and keep stack-pack fallback commands intact.
- [Skill overlap with Angular pack commands] -> Mitigation: position the skill as complementary browser guidance rather than a replacement for pack verification commands.
- [Migration loses useful references] -> Mitigation: move all reference documents under `skill/playwright-cli/references/`.

## Migration Plan

1. Create the OpenSpec change artifacts.
2. Add `skill/playwright-cli/` and migrate the `.claude` content.
3. Update `web-ui-ux`, docs, and validations to describe composition.
4. Remove the `.claude/skills/playwright-cli` copy.
5. Run validation and strict OpenSpec checks.

## Open Questions

- None at this stage.
