## ADDED Requirements

### Requirement: Structured runtime-definition validation
The validation suite SHALL parse and validate agent frontmatter, skill frontmatter, manifests, catalogs, packs, and referenced paths as structured data rather than relying only on raw substring presence.

#### Scenario: Skill is missing native frontmatter
- **WHEN** a repository-owned `SKILL.md` lacks a parseable `name` or `description`
- **THEN** validation fails and identifies the skill path and missing field

#### Scenario: Catalog and runtime names diverge
- **WHEN** an agent catalog entry does not match the runtime name derived from its path
- **THEN** validation fails with both names and the affected path

#### Scenario: Deprecated broad tools remain during this change
- **WHEN** an agent still uses the deprecated `tools` field
- **THEN** validation emits a non-blocking follow-up warning
- **AND** does not fail solely because least-privilege permission migration is deferred

### Requirement: Native consumer discovery validation
The validation suite SHALL create a disposable consumer fixture and use installed OpenCode debug commands to verify resolved skills, agents, and configuration.

#### Scenario: Consumer fixture is validated
- **WHEN** runtime contract validation runs
- **THEN** `opencode debug skill` contains every repository-owned skill
- **AND** `opencode debug agent orchestrator` resolves the expected agent
- **AND** `opencode debug config` selects `orchestrator` as the default agent

### Requirement: Runner integration validation
The validation suite SHALL exercise runner behavior from both the platform source layout and the consumer `.opencode` layout.

#### Scenario: Consumer change is bundled
- **WHEN** the fixture invokes `.opencode/opencode-runner.sh bundle --change fixture-change`
- **THEN** the bundle references the consumer root and consumer-owned change path
- **AND** module-owned agents, skills, and packs are included from `.opencode`

#### Scenario: Pack content is checked
- **WHEN** a bundle is generated with `--pack angular`
- **THEN** validation confirms that Angular constraints and verification commands are present

#### Scenario: Default reference behavior is checked
- **WHEN** a bundle is generated without `--references`
- **THEN** validation confirms skill reference bodies are absent
- **AND** size diagnostics are present

### Requirement: Distribution integrity validation
The validation suite SHALL fail on recursive self-submodule declarations, unresolved catalog paths, invalid phase-skill mappings, duplicate IDs, missing manifests, and tracked `Zone.Identifier` sidecar files.

#### Scenario: Self-submodule is introduced
- **WHEN** `.gitmodules` declares the platform repository at `.opencode`
- **THEN** validation fails before runtime fixture execution

#### Scenario: Windows sidecar is tracked
- **WHEN** Git tracks a path ending in `:Zone.Identifier`
- **THEN** validation fails and lists the path for removal

### Requirement: Bundle size reporting without promotion threshold
The evaluation harness SHALL record bundle byte, line, and approximate token measurements for representative fixtures without using those measurements as a promotion gate in this change.

#### Scenario: Representative bundles are evaluated
- **WHEN** evaluation runs for generic, Angular, and Go/AWS fixtures
- **THEN** bundle size measurements are included in the report
- **AND** no candidate fails solely because of bundle size
