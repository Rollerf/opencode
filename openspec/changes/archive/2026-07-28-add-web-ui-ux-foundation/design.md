## Context

The current repository architecture is core-plus-pack, which is a good fit for multi-stack evolution. However, frontend implementation quality is still under-specified. The Angular pack provides local dev, Playwright validation, and TDD commands, but it does not give the implementation workflow enough reusable design and UX guidance to avoid generic results.

There is also a tooling mismatch today: default skill loading is phase-based and backend-oriented, so Angular implementation can inherit `backend-design` guidance even when the task is purely UI. That sends frontend work through the wrong reasoning path and biases results toward backend constraints that do not apply. If we solve the frontend gap with an Angular-only skill, we will likely duplicate that work again when Astro support is added.

## Goals / Non-Goals

**Goals:**
- Add one reusable `web-ui-ux` skill that captures web frontend quality rules independent of Angular internals.
- Make Angular the first consumer of that skill through pack-aware routing and implementation guidance.
- Ensure session bundling and default skill selection can account for stack pack + task intent.
- Ensure Angular frontend/UI tasks explicitly avoid `backend-design` and any backend-oriented default bundle path.
- Keep the path open for a future Astro pack to reuse the same UI/UX foundation.

**Non-Goals:**
- Adding an Astro pack in this change.
- Building shared runtime UI components that compile across Angular and Astro.
- Replacing stack packs with a frontend-only routing model.
- Introducing screenshot baselines or visual diff infrastructure beyond the existing Playwright-oriented guidance.

## Decisions

1. Shared web UI skill, not Angular-only skill.
   - Decision: create `skill/web-ui-ux/` as the canonical reusable frontend guidance layer.
   - Rationale: design heuristics, state coverage, responsive checks, and visual audit workflow are reusable across web stacks, while framework internals are not.
   - Alternative considered: `angular-ui-ux` as the only new skill. Rejected because it would couple reusable UI guidance to one framework and make Astro support noisier later.

2. Angular-first consumption through the existing pack model.
   - Decision: keep Angular specialization in `packs/angular` and route Angular UI work to the existing implementer with shared `web-ui-ux` guidance layered on top.
   - Rationale: the repository already treats stack packs as the extension point; this keeps frontend support additive and consistent with current architecture.
   - Alternative considered: create a dedicated Angular UI subagent now. Rejected because the repo has no Angular subagent abstraction today, and a shared skill solves the immediate quality gap with lower maintenance.

3. Pack-aware skill composition.
   - Decision: update runner/bundling and routing guidance so default skills can vary by pack and by task intent, especially for Angular UI implementation, and explicitly suppress `backend-design` for frontend/UI intent.
   - Rationale: Angular UI work should not inherit backend-specific guidance by default, should not enter a backend design path, and future web stacks need a clean way to compose shared UI guidance.
   - Alternative considered: keep phase-only default skills and rely on ad hoc prompts. Rejected because it would keep frontend specialization inconsistent and easy to forget.

4. Validation and docs as part of the capability.
   - Decision: add contract coverage and documentation for the new skill, Angular integration path, and pack-aware usage.
   - Rationale: frontend specialization will otherwise regress silently as prompts and packs evolve.
   - Alternative considered: documentation-only rollout. Rejected because the repo relies on explicit contracts and validations for maintainability.

## Risks / Trade-offs

- [Shared skill becomes too vague] -> Mitigation: keep `web-ui-ux` focused on concrete web UI checks, deliverables, and evidence requirements.
- [Angular-specific concerns leak into the shared skill] -> Mitigation: keep framework instructions in `packs/angular` and agent/routing overlays, not in the shared web skill.
- [Routing or default skill selection becomes ambiguous] -> Mitigation: define explicit frontend/UI trigger terms and pack-aware defaults for implementation bundles.
- [Frontend work still falls through backend defaults] -> Mitigation: add explicit exclusion rules and validation coverage for `backend-design` on Angular UI/frontend intent.
- [Future Astro support needs different rendering guidance] -> Mitigation: reuse `web-ui-ux` only for cross-framework concerns and add Astro-specific overlay guidance later.

## Migration Plan

1. Create OpenSpec artifacts for the shared web UI foundation change.
2. Add `skill/web-ui-ux/` with manifest and guidance.
3. Update Angular pack docs/metadata and implementation prompts to consume `web-ui-ux` for UI tasks.
4. Extend routing/session-bundle logic for pack-aware skill selection and frontend exclusion of backend skills.
5. Add validation and documentation updates.
6. Validate with repository contract scripts and `openspec validate "add-web-ui-ux-foundation" --strict`.

## Open Questions

- None at this stage. Astro support remains an explicit future pack-level extension, not an implementation target for this change.
