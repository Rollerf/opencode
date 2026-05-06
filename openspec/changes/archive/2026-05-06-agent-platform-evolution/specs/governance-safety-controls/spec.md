## ADDED Requirements

### Requirement: Local-only autonomy policy
The platform SHALL enforce that autonomous execution is limited to local development workflows and SHALL block non-local lifecycle actions.

#### Scenario: Non-local action is blocked
- **WHEN** an agent attempts an operation with write or release impact
- **THEN** the operation is blocked if it targets non-local lifecycle stages and the response reports required handoff to the external operator

### Requirement: Explicit operator handoff contract
The platform SHALL require explicit handoff notes for any task that crosses from local development into non-local lifecycle ownership.

#### Scenario: Handoff note is required
- **WHEN** work completion requires integration, staging, production, or other non-local operations
- **THEN** the output includes a handoff section with pending actions, required inputs, and ownership assigned to the external operator

### Requirement: Standard handoff artifact schema
The platform SHALL use a standard handoff artifact schema containing change summary, validated local evidence, pending non-local actions, required inputs, risks, and owning operator.

#### Scenario: Handoff artifact is complete
- **WHEN** a local change is marked ready for external continuation
- **THEN** the handoff artifact includes all mandatory sections and references the active OpenSpec change identifier

### Requirement: Security and compliance baseline
All packs SHALL include a minimum security/compliance checklist aligned with repository policy.

#### Scenario: Pack readiness includes security baseline
- **WHEN** a new stack pack is introduced
- **THEN** it cannot be marked ready until all baseline security/compliance checks are defined

### Requirement: Baseline security checklist content
The minimum security/compliance checklist SHALL include at least secret-handling rules, dependency/license validation, high-severity vulnerability handling, and prohibited high-risk command policies for local execution.

#### Scenario: Baseline checklist is verifiable
- **WHEN** a stack pack is reviewed for readiness
- **THEN** reviewers can verify each mandatory baseline control is documented with a concrete check or command

### Requirement: Audit trail for high-impact actions
The platform SHALL persist traceable evidence for high-impact actions including actor, command, target artifacts, and outcome.

#### Scenario: High-impact command is audited
- **WHEN** an agent executes a command classified as high impact
- **THEN** an audit entry is recorded and linked to the active OpenSpec change
