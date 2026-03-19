## ADDED Requirements

### Requirement: Canonical agent taxonomy
The platform SHALL maintain a canonical taxonomy of agents grouped by workflow phase and specialization domain.

#### Scenario: Catalog presents phase and specialization metadata
- **WHEN** a maintainer inspects the agent catalog
- **THEN** each agent entry includes phase scope, specialization, expected inputs, and expected outputs

### Requirement: Deterministic routing policy
Routing SHALL select agents based on task intent and workflow phase before applying stack context as a secondary discriminator.

#### Scenario: Intent-first routing selection
- **WHEN** a request asks for planning artifacts
- **THEN** routing selects the planning agent regardless of technology stack and applies stack context only for content constraints

### Requirement: Routing fallback behavior
The platform SHALL define explicit fallback behavior when no specialized agent is available.

#### Scenario: Fallback to general workflow-safe agent
- **WHEN** a request cannot be matched to a specialized agent
- **THEN** routing assigns a general agent that follows core workflow contracts and reports the missing specialization as a decision gap
