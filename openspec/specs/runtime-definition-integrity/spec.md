# runtime-definition-integrity Specification

## Purpose
TBD - created by archiving change harden-opencode-runtime-definitions. Update Purpose after archive.
## Requirements
### Requirement: Non-recursive module distribution
The repository SHALL NOT declare itself as a Git submodule at `.opencode`, and consumer installation guidance SHALL NOT create a recursively self-referential module tree.

#### Scenario: Source repository submodules are validated
- **WHEN** definition validation inspects `.gitmodules`
- **THEN** no `.opencode` entry points to the platform repository itself
- **AND** external submodules such as `third_party/n8n_skills` remain independently declared

#### Scenario: Consumer distribution is exercised
- **WHEN** the validation suite creates a disposable consumer fixture
- **THEN** the platform module is available exactly once at `<consumer>/.opencode`
- **AND** no nested `<consumer>/.opencode/.opencode` module is created

### Requirement: Module and consumer path separation
The runner SHALL resolve platform definitions from `MODULE_DIR` and consumer-owned OpenSpec artifacts and project operations from `PROJECT_ROOT` across source, vendored `.opencode`, and global module layouts.

#### Scenario: Runner executes from a consumer module
- **WHEN** `<consumer>/.opencode/opencode-runner.sh` is invoked with `--change example-change`
- **THEN** agents, skills, and packs are loaded from `<consumer>/.opencode`
- **AND** the change is loaded from `<consumer>/openspec/changes/example-change`

#### Scenario: Runner executes from the platform source repository
- **WHEN** `opencode-runner.sh` is invoked from the platform source checkout or one of its descendants
- **THEN** both `MODULE_DIR` and `PROJECT_ROOT` resolve to the source checkout

#### Scenario: Global runner executes from a consumer project
- **WHEN** a runner whose module directory is outside the consumer working tree is invoked from that consumer project
- **THEN** `MODULE_DIR` resolves to the runner's platform checkout
- **AND** `PROJECT_ROOT` resolves to the physical consumer working directory
- **AND** consumer-owned OpenSpec artifacts are read from that project root

### Requirement: Native metadata for repository-owned skills
Every repository-owned `skill/<name>/SKILL.md` SHALL contain parseable OpenCode frontmatter with a `name` matching its directory and a non-empty activation description.

#### Scenario: Repository-owned wrappers are discovered
- **WHEN** native skill validation runs against the consumer fixture
- **THEN** every repository-owned skill appears in `opencode debug skill`
- **AND** each skill name matches its manifest and directory

#### Scenario: n8n ownership boundary is preserved
- **WHEN** n8n wrapper metadata is corrected
- **THEN** files under `skill/n8n-gateway` and `skill/n8n-mcp-tools-expert` may change
- **AND** files under `third_party/n8n_skills` remain unchanged

### Requirement: Consumer default entrypoint configuration
The platform SHALL provide a schema-valid consumer configuration template that selects `orchestrator` as the default primary agent without overwriting consumer-owned provider or permission settings, plus a separate consumer-owned template for recording confirmed stack-pack choices.

#### Scenario: New consumer applies the template
- **WHEN** a consumer follows the documented setup
- **THEN** `opencode debug config` resolves `default_agent` to `orchestrator`
- **AND** `opencode debug agent orchestrator` resolves the module-owned agent definition

#### Scenario: Consumer already has configuration
- **WHEN** a consumer has an existing `opencode.json` or `opencode.jsonc`
- **THEN** setup guidance provides merge instructions instead of replacing the existing file

#### Scenario: Operator confirms a pack selection
- **WHEN** the operator approves persisting an inferred or explicitly selected pack
- **THEN** the project records `default_pack` and optional `allowed_packs` in `.opencode-project.yaml`
- **AND** provider and permission configuration remains in the consumer's OpenCode configuration

### Requirement: Context-selective bundle generation
Bundle generation SHALL minimize default context while preserving explicit access to references and SHALL emit context-size diagnostics without enforcing a token threshold.

#### Scenario: Default bundle omits references
- **WHEN** a bundle is generated without a reference flag
- **THEN** skill reference files are not embedded
- **AND** the bundle identifies references that can be requested explicitly

#### Scenario: Explicit references are requested
- **WHEN** a bundle is generated with `--references`
- **THEN** the selected skill references are embedded exactly once

#### Scenario: User goal is prioritized
- **WHEN** a bundle includes a user prompt
- **THEN** the user goal appears before agent, skill, pack, and OpenSpec context

#### Scenario: Bundle diagnostics are emitted
- **WHEN** bundle generation completes
- **THEN** the runner reports output lines, bytes, and a labeled approximate token estimate
- **AND** no pass/fail decision is based on token count

#### Scenario: Embedded content contains Markdown fences
- **WHEN** an embedded file contains a run of backticks
- **THEN** the generated boundary uses a longer fence and preserves the embedded content without closing early

### Requirement: Phase-relevant OpenSpec context
Bundle generation SHALL select OpenSpec artifacts according to the requested phase instead of unconditionally embedding every artifact.

#### Scenario: Implementation bundle is generated
- **WHEN** the implementation phase bundles an existing change
- **THEN** design, delta specs, and tasks are included
- **AND** proposal and unrelated reference files are omitted by default

#### Scenario: Planning bundle is generated
- **WHEN** the planning phase bundles an existing change
- **THEN** every existing planning artifact is available because any artifact may require refinement

#### Scenario: Verification bundle is generated
- **WHEN** the verification phase bundles an existing change
- **THEN** design, delta specs, and tasks are included
- **AND** proposal and unrelated reference files are omitted by default

#### Scenario: Archive bundle is generated
- **WHEN** the archive phase bundles an existing change
- **THEN** proposal, delta specs, tasks, and Markdown evidence files are included when present
- **AND** unrelated skill reference files are omitted by default

### Requirement: Supported model and step policy
Runtime agent definitions SHALL use centralized model and step assignments based on the Sol and Luna roles defined by the design.

#### Scenario: Final decision role is validated
- **WHEN** the orchestrator definition is inspected
- **THEN** its model is `openai/gpt-5.6-sol`
- **AND** its step limit is `40`

#### Scenario: Bounded prose helper is validated
- **WHEN** a documentation or design-document subagent is inspected
- **THEN** its model is `openai/gpt-5.6-luna`
- **AND** its configured step limit matches the central role matrix

#### Scenario: Code-changing helper is validated
- **WHEN** a Pulumi or TDD subagent is inspected
- **THEN** its model is `openai/gpt-5.6-sol`
- **AND** its step limit is `20`

#### Scenario: Feature iteration is not a runtime agent
- **WHEN** runtime agent definitions and catalogs are inspected
- **THEN** no feature-iteration subagent exists
- **AND** incremental feature work is defined by the implementation phase skill

#### Scenario: Leaf delegation is blocked
- **WHEN** a leaf subagent definition is inspected
- **THEN** `permission.task` is `deny`
- **AND** migration of deprecated edit and Bash tool declarations is not required by this change

### Requirement: Local CodeGraph cache exclusion
The repository SHALL ignore the project-local `.codegraph/` index directory while allowing each consumer to initialize its own index.

#### Scenario: CodeGraph is initialized
- **WHEN** `codegraph init -i` creates a project index
- **THEN** `.codegraph/` does not appear as an untracked Git change

### Requirement: Deterministic OpenSpec CLI resolution
The platform SHALL provide and resolve an OpenSpec CLI for runner operations without requiring a global npm installation.

#### Scenario: Module dependencies are installed
- **WHEN** `${MODULE_DIR}/node_modules/.bin/openspec` is executable
- **THEN** the runner selects that binary before any global or project-local candidate
- **AND** all runner OpenSpec operations use the platform-tested CLI version

#### Scenario: Module-local CLI is absent
- **WHEN** the module-local candidate is absent
- **THEN** the runner checks an existing `openspec` command on `PATH`
- **AND** then checks `${PROJECT_ROOT}/node_modules/.bin/openspec`

#### Scenario: No CLI candidate exists
- **WHEN** no executable OpenSpec CLI candidate is available
- **THEN** runner doctor and phase operations fail with a non-zero status
- **AND** the error instructs the operator to run `npm install` in the platform module

### Requirement: Pinned OpenSpec runtime dependency
The platform SHALL declare `@fission-ai/openspec` version `1.1.1` as an exact runtime dependency.

#### Scenario: Platform dependencies are installed
- **WHEN** an operator runs `npm install` in the platform checkout
- **THEN** `node_modules/.bin/openspec` is installed
- **AND** `openspec --version` reports `1.1.1`
