## 1. Skill Definition

- [ ] 1.1 Add `skill/seo-expert/manifest.yaml` with name, display name, description, default prompt, compatibility metadata, and explicit `$seo-expert` invocation tag.
- [ ] 1.2 Add `skill/seo-expert/SKILL.md` with scope, trigger rules, inspection-first workflow, SEO checklist, safety guardrails, composition guidance, and expected output.
- [ ] 1.3 Verify the skill is discoverable through the repository skill listing command.

## 2. Routing and Orchestration

- [ ] 2.1 Update `agents/orchestrator.md` to load or apply `$seo-expert` for explicit SEO intent while preserving phase-first routing.
- [ ] 2.2 Update `core/routing-policy.md` with SEO intent examples, composition guidance, and fallback behavior when the runtime skill is unavailable but the repository-local skill exists.
- [ ] 2.3 Ensure SEO guidance is not activated for unrelated frontend-only, backend-only, or documentation-only requests unless SEO intent is explicit.

## 3. Validation and Documentation

- [ ] 3.1 Add `scripts/validate/seo-expert-contract.sh` to check required skill files, manifest invocation metadata, routing references, and required SEO guidance text.
- [ ] 3.2 Include the SEO validation script in `scripts/validate/run-all.sh`.
- [ ] 3.3 Update `README.md` and `CONTRIBUTING.md` with SEO skill usage and validation guidance.

## 4. Verification

- [ ] 4.1 Run `./opencode-runner.sh list skills` and confirm `seo-expert` is listed.
- [ ] 4.2 Run `./scripts/validate/seo-expert-contract.sh`.
- [ ] 4.3 Run `./scripts/validate/run-all.sh`.
- [ ] 4.4 Run `openspec validate "add-seo-expert-skill" --strict`.
