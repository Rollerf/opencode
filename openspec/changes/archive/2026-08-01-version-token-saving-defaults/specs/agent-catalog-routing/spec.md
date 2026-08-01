# Agent Catalog Routing Delta

## ADDED Requirements

### Requirement: Default token-saving communication policy

The orchestrator SHALL apply `$caveman` full mode by default to status updates and conversational output while preserving explicit operator overrides and protected-output boundaries.

#### Scenario: Session starts without a communication-mode request

- **WHEN** the orchestrator starts a session and the operator has not selected another communication mode
- **THEN** the orchestrator loads and applies `$caveman` full mode
- **AND** the mode persists for the session

#### Scenario: Operator changes communication mode

- **WHEN** the operator selects another Caveman intensity or requests `stop caveman` or `normal mode`
- **THEN** the orchestrator follows that explicit preference for the session

#### Scenario: Compression conflicts with clarity or safety

- **WHEN** Caveman style would make technical, security, or irreversible-action wording ambiguous
- **THEN** the orchestrator uses normal prose for that output
- **AND** resumes the selected Caveman mode for later eligible communication
