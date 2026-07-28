## ADDED Requirements

### Requirement: Reusable web UI/UX skill exposure
The platform SHALL expose a reusable `web-ui-ux` skill for web frontend implementation work.

#### Scenario: Web UI skill is discoverable
- **WHEN** a user lists available skills
- **THEN** `web-ui-ux` appears with manifest metadata and an explicit invocation tag

### Requirement: Inspection-first web UI workflow
The `web-ui-ux` skill SHALL require inspection of existing components, styles, tokens, and layout patterns before implementing major UI changes.

#### Scenario: UI work starts from current system audit
- **WHEN** a user requests a frontend or UI implementation task
- **THEN** the guidance requires a summary of the current visual language and reusable building blocks before code changes begin

### Requirement: Web UI completion checklist
The `web-ui-ux` skill SHALL require state coverage, responsive review, accessibility considerations, and visual verification guidance for major UI work.

#### Scenario: UI task closes with quality evidence
- **WHEN** an agent completes a major web UI change using `web-ui-ux`
- **THEN** the output includes covered UI states, responsive/accessibility considerations, and the verification commands or evidence used for visual review
