## MODIFIED Requirements

### Requirement: Unified OpenSpec lifecycle contract
The platform SHALL define one common lifecycle contract plus native phase-contract skills for planning, spec hardening, implementation, verification, and archive, with explicit entry and exit criteria loadable by the primary Sol orchestrator. The planning lifecycle SHALL include a mandatory task-refinement sub-phase after spec hardening and before implementation, implemented as a specialization that does not add a top-level phase or phase-owning agent. To reduce expected implementation cost, normal executor-ready task blocks SHALL be delegated to the designated lower-cost Luna/high refined-task executor by default while Sol retains orchestration and final review.

#### Scenario: Phase transition criteria are available
- **WHEN** the orchestrator starts work on an OpenSpec change
- **THEN** it loads the common lifecycle skill and exactly one matching phase-contract skill
- **AND** the loaded phase contract provides required artifacts, permitted actions, and completion criteria before progression
- **AND** implementation entry requires both hard-spec readiness and a `READY` task-refinement gate

#### Scenario: Task refinement follows spec hardening
- **WHEN** a change reaches hard-spec readiness
- **THEN** the orchestrator remains within the planning lifecycle and applies the task-refinement specialization
- **AND** implementation does not begin until every incomplete implementation task and execution block is executor-ready

#### Scenario: Refined block enters implementation
- **WHEN** a normal task block passes task refinement and implementation begins
- **THEN** the Sol orchestrator keeps the implementation phase contract active
- **AND** delegates one cohesive block to the Luna/high refined-task executor
- **AND** retains final evidence review and task-completion authority

#### Scenario: Phase contract is not an agent
- **WHEN** runtime definitions are validated
- **THEN** planning, spec hardening, implementation, verification, and archive contracts are discoverable as phase-contract skills
- **AND** task refinement is discoverable as a planning specialization skill
- **AND** no separate primary agent is required for any of those contracts
