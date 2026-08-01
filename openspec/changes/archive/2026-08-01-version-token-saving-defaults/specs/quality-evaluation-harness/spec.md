# Quality Evaluation Harness Delta

## ADDED Requirements

### Requirement: Token-saving defaults contract integration

The main validation runner SHALL execute a dedicated contract for versioned Caveman and RTK defaults.

#### Scenario: Full validation runs

- **WHEN** `scripts/validate/run-all.sh` executes
- **THEN** it runs `scripts/validate/token-savings-defaults-contract.sh`
- **AND** any token-saving contract failure fails the full validation run
