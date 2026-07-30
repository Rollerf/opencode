## Context

This repository provides reusable agents, skills, stack packs, routing policy, and validation contracts for OpenCode workflows. Existing skills support backend design, web UI/UX, Playwright CLI workflows, OpenSpec workflow, CodeGraph, RTK command handling, and n8n integration. SEO work is currently handled only by generic guidance or adjacent frontend skills.

SEO tasks need their own guidance because they cut across content, frontend implementation, metadata, structured data, crawlability, performance, accessibility-adjacent signals, and validation evidence. The skill must be useful for implementation and review while avoiding unsupported ranking guarantees or black-hat tactics.

## Goals / Non-Goals

**Goals:**

- Add a `seo-expert` skill with repository-native `manifest.yaml` metadata and `SKILL.md` instructions.
- Make the skill triggerable by explicit `$seo-expert` invocation and by clear SEO intent in orchestrator/routing guidance.
- Require inspection of existing routes, page templates, metadata generation, robots/sitemap/canonical behavior, structured data, and content context before recommendations or edits.
- Require deterministic output: prioritized findings, affected files, recommended changes, validation commands or evidence, and unresolved assumptions.
- Define validation coverage that fails when required skill files or required SEO guidance are missing.

**Non-Goals:**

- Integrating external SEO crawler APIs or paid services.
- Promising search ranking improvements.
- Replacing `web-ui-ux` for visual design work or `playwright-cli` for browser automation.
- Implementing application-specific SEO changes as part of opening this OpenSpec change.

## Chosen Approach

1. Repository-native skill.
   - Decision: add `skill/seo-expert/manifest.yaml` and `skill/seo-expert/SKILL.md`.
   - Rationale: this matches current local skill conventions and keeps the specialization portable across consuming projects.
   - Alternative considered: create a dedicated SEO subagent. Rejected for the initial change because a skill composes better with planning, implementation, verification, and existing frontend/browser skills.

2. Intent-based routing.
   - Decision: update orchestrator/routing guidance so SEO intent activates `seo-expert` while phase selection still determines planner, implementer, verifier, or archiver behavior.
   - Rationale: SEO work can occur during planning, implementation, documentation, or review, so the skill should augment the selected phase instead of replacing it.
   - Alternative considered: always include SEO guidance for web UI work. Rejected because SEO guidance would add unnecessary context to visual-only frontend tasks.

3. Evidence-focused SEO checklist.
   - Decision: require the skill to produce inspectable findings and validation evidence, including applicable commands such as local tests, build checks, sitemap/robots inspection, structured-data validation notes, Lighthouse/PageSpeed notes, or Playwright/browser evidence when available.
   - Rationale: SEO guidance should be actionable and reviewable, not generic advice.
   - Alternative considered: make the skill primarily a content-writing assistant. Rejected because repository workflows need implementation-safe technical guidance first.

4. Validation script.
   - Decision: add `scripts/validate/seo-expert-contract.sh` and include it in `scripts/validate/run-all.sh`.
   - Rationale: validation keeps skill discovery, routing references, and required guidance from regressing.

## Hard-Spec Readiness

- Skill name: `seo-expert`.
- Explicit invocation tag: `$seo-expert`.
- Skill location: `skill/seo-expert/`.
- Required files: `manifest.yaml` and `SKILL.md`.
- Required routing references: `agents/orchestrator.md` and `core/routing-policy.md` must mention `$seo-expert` and SEO intent handling.
- Required validation evidence: `./scripts/validate/seo-expert-contract.sh`, `./scripts/validate/run-all.sh`, and `openspec validate "add-seo-expert-skill" --strict`.
- Critical ambiguity: none identified for the initial skill implementation.

## Risks / Trade-offs

- [Generic SEO advice] -> Mitigation: require repository inspection, affected-file references, assumptions, and validation evidence.
- [Over-triggering on normal frontend work] -> Mitigation: route only explicit SEO intent such as metadata, indexing, structured data, canonical URLs, sitemap, robots, search snippets, crawlability, or content optimization.
- [Unsafe SEO recommendations] -> Mitigation: prohibit deceptive, black-hat, credential-seeking, or ranking-guarantee claims.
- [Tool availability differences] -> Mitigation: require validation evidence from available local tools and clearly label external/manual checks when a crawler or browser audit tool is unavailable.

## Migration Plan

1. Create OpenSpec artifacts for this change.
2. Add `skill/seo-expert/manifest.yaml` and `skill/seo-expert/SKILL.md`.
3. Update orchestrator and routing policy documentation for SEO intent.
4. Add SEO skill validation script and wire it into the validation suite.
5. Update documentation with usage and composition guidance.
6. Run repository validation and strict OpenSpec validation.

## API / Security / Data / Infrastructure Impact

- API contract impact: none expected.
- Security impact: the skill must not request credentials, bypass robots directives, recommend cloaking, keyword stuffing, doorway pages, hidden text, link schemes, or other deceptive practices.
- Data model impact: none expected.
- Pulumi/IaC impact: none expected.

## Open Questions

- None for the initial implementation. Future changes may add optional integrations with specific SEO audit tools if a consuming project requests them.
