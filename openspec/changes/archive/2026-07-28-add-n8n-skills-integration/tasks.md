## 1. Source Integration

- [x] 1.1 Add `https://github.com/czlonkowski/n8n-skills` as submodule at `third_party/n8n_skills`.
- [x] 1.2 Document submodule update procedure for maintainers.

## 2. Skill Wrappers

- [x] 2.1 Add local wrapper skills under `skill/` for the selected n8n skills with valid `manifest.yaml` metadata.
- [x] 2.2 Ensure wrappers reference upstream `SKILL.md` and key guides with stable paths.
- [x] 2.3 Verify n8n skills are listed by `./opencode-runner.sh list skills`.

## 3. Routing and Orchestration

- [x] 3.1 Update routing policy with explicit n8n intent triggers and fallback behavior.
- [x] 3.2 Update orchestrator guidance to apply n8n skills when user requests n8n workflows.

## 4. Validation and Documentation

- [x] 4.1 Add `scripts/validate/n8n-skills-contract.sh` to validate required source and wrapper files.
- [x] 4.2 Include n8n validation in `scripts/validate/run-all.sh`.
- [x] 4.3 Update `README.md` and `CONTRIBUTING.md` with n8n support and usage.

## 5. Verification

- [x] 5.1 Run `./scripts/validate/run-all.sh`.
- [x] 5.2 Run `openspec validate "add-n8n-skills-integration" --strict`.
