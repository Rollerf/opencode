## MODIFIED Requirements

### Requirement: Deterministic routing policy
Routing SHALL select agents based on task intent and workflow phase before applying stack context as a secondary discriminator, and SHALL allow skill activation rules that depend on both active pack and task intent.

#### Scenario: Intent-first routing selection
- **WHEN** a request asks for planning artifacts
- **THEN** routing selects the planning agent regardless of technology stack and applies stack context only for content constraints

#### Scenario: Angular UI implementation activates shared web skill
- **WHEN** a request is implementation work for Angular frontend, UI, responsive, design-system, or visual polish concerns
- **THEN** routing selects the implementer, applies the Angular pack, and includes `web-ui-ux` guidance in the execution context

#### Scenario: Angular UI intent excludes backend design guidance
- **WHEN** a request is implementation work for Angular frontend or UI concerns without explicit backend scope
- **THEN** routing and bundle selection do not activate `backend-design` or other backend-only guidance

### Requirement: Routing fallback behavior
The platform SHALL define explicit fallback behavior when no specialized agent is available, while preserving reusable skill activation when pack and intent rules provide a safe specialization path.

#### Scenario: Fallback to general workflow-safe agent
- **WHEN** a request cannot be matched to a specialized agent
- **THEN** routing assigns a general agent that follows core workflow contracts and reports the missing specialization as a decision gap
