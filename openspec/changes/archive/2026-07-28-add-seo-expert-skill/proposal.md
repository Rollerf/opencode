## Why

Projects that use this repository need reusable SEO guidance for web-facing work. Current skills cover backend architecture, web UI/UX, Playwright workflows, n8n workflows, OpenSpec lifecycle, CodeGraph, and command-output handling, but there is no dedicated specialization for technical SEO, on-page SEO, structured data, indexing controls, or SEO validation evidence.

Without a dedicated SEO skill, agents may produce generic marketing or frontend advice that is not tied to inspectable files, deterministic checks, or safe SEO practices. A repository-native `seo-expert` skill will make SEO work discoverable, routeable, and verifiable while staying optional for non-SEO tasks.

## What Changes

- Add a reusable `seo-expert` skill under `skill/` with manifest metadata and explicit `$seo-expert` invocation.
- Define an inspection-first SEO workflow covering technical SEO, on-page metadata, structured data, indexing controls, internal linking, performance signals, accessibility-adjacent signals, and validation evidence.
- Extend routing guidance so explicit SEO intent activates the SEO skill without forcing it into unrelated frontend or backend work.
- Add validation coverage to ensure the SEO skill remains discoverable and contains required guidance.
- Document how users and orchestrators should compose `seo-expert` with existing skills such as `web-ui-ux` and `playwright-cli` when appropriate.

## Capabilities

### New Capabilities

- `seo-expert-skill`: reusable SEO guidance for technical SEO, metadata, structured data, indexing controls, content-quality checks, and evidence-based recommendations.

### Modified Capabilities

- `agent-catalog-routing`: activate `seo-expert` for explicit SEO intent while preserving phase-first routing and optional composition with web/browser skills.

## Scope Boundaries

- In scope: repository-local skill files, manifest metadata, routing documentation, validation scripts, README/CONTRIBUTING usage notes, and OpenSpec artifacts.
- Out of scope: integrating third-party SEO APIs, running paid SEO crawlers, generating production marketing copy without user-provided product context, changing application SEO behavior directly, or guaranteeing search ranking outcomes.

## Impact

- Adds a new reusable skill under `skill/seo-expert/`.
- Updates routing/orchestrator documentation to describe SEO intent handling.
- Adds validation checks to the repository validation suite.
- No API contract changes are expected.
- No security model changes are expected; the skill must avoid credential collection and must not recommend deceptive or black-hat SEO practices.
- No database, data model, Pulumi, or IaC changes are expected.

## Open Decisions

- None. The initial implementation will use `seo-expert` as the skill name, `$seo-expert` as the explicit invocation tag, and repository-local validation scripts for evidence.
