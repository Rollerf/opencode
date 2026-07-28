## ADDED Requirements

### Requirement: Repository-native SEO expert skill exposure
The platform SHALL expose a reusable `seo-expert` skill for SEO-focused planning, implementation, review, and validation work.

#### Scenario: SEO skill is discoverable
- **WHEN** a user lists available skills through the repository skill listing command
- **THEN** `seo-expert` appears with manifest metadata, a clear description, and the explicit `$seo-expert` invocation tag

### Requirement: Inspection-first SEO workflow
The `seo-expert` skill SHALL require inspection of existing routes, page templates, metadata generation, canonical URL handling, robots directives, sitemap behavior, structured data, internal links, and relevant content context before recommending broad SEO changes.

#### Scenario: SEO work starts from current implementation evidence
- **WHEN** a user requests SEO analysis, SEO implementation, metadata changes, structured data, indexing fixes, or content optimization
- **THEN** the guidance requires the agent to identify affected files, existing SEO behavior, assumptions, and missing context before proposing or editing changes

### Requirement: SEO checklist coverage
The `seo-expert` skill SHALL cover technical SEO, on-page metadata, structured data, crawlability, indexability, canonicalization, internal linking, content quality signals, performance-related signals, and accessibility-adjacent signals when relevant to the request.

#### Scenario: SEO recommendations are actionable and scoped
- **WHEN** the agent completes an SEO assessment or implementation task
- **THEN** the output includes prioritized findings or changes, affected files, rationale, validation evidence, and any unresolved assumptions

### Requirement: SEO safety guardrails
The `seo-expert` skill SHALL prohibit deceptive or unsafe SEO practices, including cloaking, keyword stuffing, hidden text, doorway pages, link schemes, credential collection, robots bypass attempts, and ranking guarantees.

#### Scenario: Unsafe SEO request is rejected or redirected
- **WHEN** a user asks for deceptive, black-hat, credential-seeking, or ranking-guarantee SEO tactics
- **THEN** the guidance requires refusal of the unsafe tactic and offers safe, standards-aligned alternatives where possible

### Requirement: SEO validation guidance
The `seo-expert` skill SHALL require validation evidence appropriate to available tools and repository context.

#### Scenario: SEO task closes with evidence
- **WHEN** an SEO task is completed
- **THEN** the output identifies the commands, browser checks, structured-data checks, sitemap/robots inspections, build/test results, or manual external checks used or explains why specific checks could not be run
