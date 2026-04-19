## 1. Shared Gitflow Policy

- [x] 1.1 Update `README.md` to replace trunk-based wording with gitflow as the default workflow for consumer projects.
- [x] 1.2 Update `CONTRIBUTING.md` with the standard gitflow lifecycle: feature from `develop`, merge to `develop`, release from `develop`, merge to `main`, then sync `main` back to `develop`.

## 2. OpenSpec-to-Branch Traceability

- [x] 2.1 Update shared guidance so each OpenSpec change is implemented on its own `feature/*` branch created from `develop`.
- [x] 2.2 Update agent-facing workflow guidance and/or core contracts so this expectation is visible to consumers and agents.

## 3. Verification and Consistency

- [x] 3.1 Add or update validation coverage if needed for the branching-policy documentation contract.
- [x] 3.2 Run affected validation scripts.
- [x] 3.3 Run `openspec validate "adopt-gitflow-branching-policy" --strict`.
