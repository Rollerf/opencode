## MODIFIED Requirements

### Requirement: Deterministic routing policy
Routing SHALL select agents based on task intent and workflow phase before applying stack context as a secondary discriminator, and SHALL allow skill activation rules that depend on explicit task intent.

#### Scenario: Intent-first routing selection
- **WHEN** a request asks for planning artifacts
- **THEN** routing selects the planning agent regardless of technology stack and applies stack context only for content constraints

#### Scenario: SEO intent activates SEO expert guidance
- **WHEN** a request explicitly mentions SEO, metadata, search snippets, structured data, schema.org, indexing, crawlability, canonical URLs, hreflang, robots directives, sitemap behavior, redirects, Core Web Vitals, or content optimization for search visibility
- **THEN** routing applies `seo-expert` guidance in addition to the selected phase contract

#### Scenario: Non-SEO work does not activate SEO guidance
- **WHEN** a request is frontend-only, backend-only, documentation-only, or general implementation work without explicit SEO intent
- **THEN** routing does not activate `seo-expert` solely because the work is web-facing

### Requirement: Routing fallback behavior
The platform SHALL define explicit fallback behavior when no specialized agent is available, while preserving reusable skill activation when repository-local skill files provide a safe specialization path.

#### Scenario: Fallback to general workflow-safe agent
- **WHEN** a request cannot be matched to a specialized agent
- **THEN** routing assigns a general agent that follows core workflow contracts and reports the missing specialization as a decision gap

#### Scenario: SEO runtime skill missing but local skill exists
- **WHEN** SEO intent is present and `$seo-expert` is not listed in runtime available skills, but `skill/seo-expert/SKILL.md` exists locally
- **THEN** routing reads and applies the repository-local SEO skill guidance instead of reporting the specialization as missing
