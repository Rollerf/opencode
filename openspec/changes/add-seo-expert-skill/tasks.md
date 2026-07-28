## 1. Skill Definition

- [x] 1.1 Add `skill/seo-expert/manifest.yaml` with name, display name, description, default prompt, compatibility metadata, and explicit `$seo-expert` invocation tag.
- [x] 1.2 Add `skill/seo-expert/SKILL.md` with scope, trigger rules, inspection-first workflow, SEO checklist, safety guardrails, composition guidance, and expected output.
- [x] 1.3 Verify the skill is discoverable through the repository skill listing command.

## 2. Routing and Orchestration

- [x] 2.1 Update `agents/orchestrator.md` to load or apply `$seo-expert` for explicit SEO intent while preserving phase-first routing.
- [x] 2.2 Update `core/routing-policy.md` with SEO intent examples, composition guidance, and fallback behavior when the runtime skill is unavailable but the repository-local skill exists.
- [x] 2.3 Ensure SEO guidance is not activated for unrelated frontend-only, backend-only, or documentation-only requests unless SEO intent is explicit.

## 3. Validation and Documentation

- [x] 3.1 Add `scripts/validate/seo-expert-contract.sh` to check required skill files, manifest invocation metadata, routing references, and required SEO guidance text.
- [x] 3.2 Include the SEO validation script in `scripts/validate/run-all.sh`.
- [x] 3.3 Update `README.md` and `CONTRIBUTING.md` with SEO skill usage and validation guidance.

## 4. Verification

- [x] 4.1 Run `./opencode-runner.sh list skills` and confirm `seo-expert` is listed.
- [x] 4.2 Run `./scripts/validate/seo-expert-contract.sh`.
- [x] 4.3 Run `./scripts/validate/run-all.sh`.
- [x] 4.4 Run `openspec validate "add-seo-expert-skill" --strict`.
