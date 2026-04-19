# gitflow-branching-policy Specification

## Purpose
Define gitflow as the default branching strategy for consumer repositories and align OpenSpec changes with feature-branch traceability.
## Requirements
### Requirement: Gitflow is the default branching model for consumer projects
The platform SHALL document gitflow as the default branching and release strategy for repositories that consume it as a submodule.

#### Scenario: Consumer project reads shared branching guidance
- **WHEN** a maintainer reads the shared workflow documentation
- **THEN** the documented default branching model is gitflow rather than trunk-based development

### Requirement: Each OpenSpec change maps to a feature branch
Each OpenSpec change SHALL be implemented on its own `feature/*` branch created from `develop`.

#### Scenario: Contributor starts a new change
- **WHEN** a contributor begins work on an OpenSpec change
- **THEN** the workflow guidance instructs them to create a dedicated `feature/*` branch from `develop` for that change

### Requirement: Gitflow release loop is explicitly defined
The platform SHALL define the standard gitflow path for completed work as feature merge into `develop`, release branch from `develop`, merge into `main`, and synchronization of `main` back into `develop`.

#### Scenario: Team prepares a release from completed features
- **WHEN** completed feature branches have been reintegrated into `develop`
- **THEN** the workflow guidance describes creating a release from `develop`, merging it into `main`, and syncing `main` back into `develop`
