## Context

This repository is not just local documentation; it is a reusable platform imported by other projects. Because of that, the branch strategy documented here becomes an operational default for consumers. Right now the platform still states trunk-based development, while the intended process is gitflow with `develop` as the integration branch.

The missing piece is not only naming gitflow as the preferred branching model, but connecting it directly to OpenSpec execution. If each OpenSpec change is not explicitly tied to its own feature branch, planning artifacts and branch lifecycle can drift apart and teams will apply the workflow inconsistently.

## Goals / Non-Goals

**Goals:**
- Establish gitflow as the default branching policy for all repositories consuming this platform.
- Define that each OpenSpec change is developed on its own `feature/*` branch created from `develop`.
- Document the full release loop, including syncing `main` back into `develop` after release merges.
- Update shared contracts and guidance so agents can enforce or remind this workflow.

**Non-Goals:**
- Automating release creation or release branch promotion in git.
- Enforcing branch naming through CI hooks in this change.
- Changing the TDD, validation, or local-only execution policies.

## Decisions

1. Gitflow becomes the shared default.
   - Decision: replace trunk-based wording in reusable docs and workflow guidance with gitflow.
   - Rationale: consumer projects should inherit one consistent branching model from the platform instead of redefining it locally.
   - Alternative considered: keep branch strategy as project-local policy. Rejected because it defeats the value of a shared workflow platform.

2. One OpenSpec change equals one feature branch.
   - Decision: require each OpenSpec change to be implemented from its own `feature/*` branch starting from `develop`.
   - Rationale: this keeps planning artifacts, branch scope, and merge boundaries aligned.
   - Alternative considered: allow multiple OpenSpec changes per feature branch. Rejected because it weakens traceability and complicates release selection.

3. Release loop is part of the reusable policy.
   - Decision: document the full sequence `develop -> feature -> develop -> release -> main -> develop`.
   - Rationale: consumer projects need the whole loop, not just feature branch creation, to keep `develop` and `main` synchronized after release.
   - Alternative considered: document only feature branches. Rejected because it leaves the post-release sync undefined.

4. Workflow contracts and docs both carry the policy.
   - Decision: update both high-level docs and core workflow contract language.
   - Rationale: docs help humans, while contracts give agents a stable source of truth.
   - Alternative considered: docs-only update. Rejected because agents would still lack explicit global guidance.

## Risks / Trade-offs

- [Consumer projects already use trunk-based flow] -> Mitigation: document the new default clearly and note that importing the updated submodule opts them into gitflow.
- [Teams create OpenSpec changes without matching feature branches] -> Mitigation: add explicit guidance in workflow docs and agent instructions.
- [Branching policy drifts again across docs and contracts] -> Mitigation: include validation/doc update tasks in the change.

## Migration Plan

1. Create OpenSpec artifacts for the gitflow policy update.
2. Update shared docs and core workflow contract wording from trunk-based to gitflow.
3. Update agent guidance to reflect feature-per-change expectations.
4. Add any validation/docs coverage needed to keep the policy visible.
5. Validate with `openspec validate "adopt-gitflow-branching-policy" --strict`.

## Open Questions

- None at this stage.
