## ADDED Requirements

### Requirement: External n8n skill source integration
The platform SHALL include the external `n8n-skills` repository as a tracked source under `third_party/n8n_skills`.

#### Scenario: Third-party source is present
- **WHEN** maintainers inspect repository dependencies
- **THEN** `third_party/n8n_skills` exists and points to the configured upstream repository

### Requirement: Repository-native n8n skill exposure
The platform SHALL expose n8n skills through local `skill/` entries with manifest metadata compatible with current skill loading.

#### Scenario: n8n skills are discoverable
- **WHEN** a user lists available skills
- **THEN** n8n skills appear with names, descriptions, and invocation tags

### Requirement: Intent-based n8n skill routing
The platform SHALL route n8n-related user intent to n8n skills only when requested or clearly inferred from n8n workflow context.

#### Scenario: n8n request triggers n8n skill usage
- **WHEN** a user asks to design, validate, or debug an n8n workflow
- **THEN** routing policy applies n8n skills before generic fallback

### Requirement: Validation coverage for n8n integration
The platform SHALL provide a validation check that fails when required n8n integration files are missing or misconfigured.

#### Scenario: n8n integration check detects missing assets
- **WHEN** required upstream or wrapper files are absent
- **THEN** the validation command exits non-zero with a clear error message
