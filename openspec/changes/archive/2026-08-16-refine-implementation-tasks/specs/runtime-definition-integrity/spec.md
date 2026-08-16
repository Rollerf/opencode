## ADDED Requirements

### Requirement: Task-refinement specialization distribution
The platform SHALL distribute `openspec-task-refinement` as a repository-owned native skill with valid frontmatter, a matching manifest, deterministic routing guidance, and task-relevant planning context in source, vendored `.opencode`, and global runner layouts.

#### Scenario: Runtime definitions are validated
- **WHEN** repository-owned skills and manifests are validated
- **THEN** `skill/openspec-task-refinement/SKILL.md` is discoverable
- **AND** its skill name matches its directory and manifest
- **AND** it is not registered as a phase-owning runtime agent

#### Scenario: Consumer bundles task-refinement context
- **WHEN** a consumer generates a planning bundle for task refinement
- **THEN** the bundle includes the orchestrator, planning phase contract, task-refinement specialization, resolved stack pack, and existing planning artifacts
- **AND** the operator is not required to use a new top-level runner phase

### Requirement: Luna high refined-task executor distribution
The platform SHALL distribute `subagent/refined-task-executor-subagent` with `model: openai/gpt-5.6-luna`, `variant: high`, `steps: 50`, hidden subagent mode, code-edit and local-command permissions, and `permission.task: deny`. The centralized model policy and agent catalog SHALL validate the same model, variant, steps, path, runtime name, scope, inputs, and outputs.

#### Scenario: Executor runtime metadata is validated
- **WHEN** runtime definition validation inspects the refined-task executor and agent catalog
- **THEN** model is `openai/gpt-5.6-luna`
- **AND** variant is `high`
- **AND** steps is `50`
- **AND** nested task delegation is denied

#### Scenario: Consumer discovers the executor
- **WHEN** a consumer runs `opencode debug agent subagent/refined-task-executor-subagent`
- **THEN** the effective agent uses provider `openai`, model `gpt-5.6-luna`, and variant `high`
- **AND** the agent is available for orchestrator delegation without becoming a primary agent
