## Context

This repository already provides core workflow skills and stack packs. n8n requests are currently unsupported as a first-class specialization. We need a low-maintenance integration that allows projects using this repository as a submodule to leverage n8n skills only when requested.

## Goals / Non-Goals

**Goals:**
- Integrate `https://github.com/czlonkowski/n8n-skills` at `third_party/n8n_skills`.
- Expose selected n8n skills in the local `skill/` catalog with invocation tags.
- Add clear routing guidance so n8n tasks load n8n skills intentionally.
- Keep integration optional and non-invasive for non-n8n projects.

**Non-Goals:**
- Rewriting upstream n8n skill content.
- Implementing n8n runtime deployment or credential management.
- Forcing n8n skills for every workflow request.

## Decisions

1. Third-party source as submodule.
   - Decision: track upstream n8n skills in `third_party/n8n_skills`.
   - Rationale: keeps source provenance and update path explicit.
   - Alternative considered: copy files directly. Rejected due to drift risk.

2. Local wrappers in `skill/`.
   - Decision: create repository-native manifests and wrapper instructions that point to upstream skill content.
   - Rationale: keeps compatibility with current loader behavior (`opencode-runner.sh list skills`).
   - Alternative considered: loading upstream skills directly from `third_party/`. Rejected due to missing local manifest contract.

3. Explicit n8n intent routing.
   - Decision: update routing/orchestrator guidance so n8n skills are used when user intent references n8n workflows, nodes, expressions, validation, or code nodes.
   - Rationale: prevents accidental activation and keeps behavior predictable.
   - Alternative considered: always preload n8n skills. Rejected as noisy for non-n8n projects.

## Risks / Trade-offs

- [Upstream submodule drift] -> Mitigation: add validation script that checks required n8n skill files exist.
- [Wrapper/upstream mismatch] -> Mitigation: keep wrappers thin and reference upstream paths explicitly.
- [Routing ambiguity] -> Mitigation: add concrete n8n intent keywords and examples in routing policy.

## Migration Plan

1. Create OpenSpec artifacts for this change.
2. Add `third_party/n8n_skills` submodule.
3. Add wrapper skills and manifests under `skill/`.
4. Update routing/orchestrator docs for n8n intent.
5. Add validation script and docs updates.
6. Validate with contract scripts and strict OpenSpec validation.

## Open Questions

- None at this stage. Initial rollout uses gateway + `n8n-mcp-tools-expert` to minimize context load.
