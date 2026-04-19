## Why

The shared platform still documents trunk-based development, but the intended operating model for consumer projects is gitflow. That mismatch makes the imported guidance inconsistent across repositories and leaves branch strategy to local interpretation.

We need a global gitflow policy in the reusable platform so every project that imports this repository as a submodule follows the same branch lifecycle. The policy must also make each OpenSpec change map to a dedicated feature branch created from `develop`.

## What Changes

- Replace trunk-based branching guidance with gitflow as the default branching strategy for all consumer projects.
- Define the standard lifecycle: `feature/*` from `develop`, reintegration into `develop`, `release/*` from `develop`, merge to `main`, then sync `main` back into `develop`.
- Require every OpenSpec change to be implemented on its own feature branch.
- Update shared documentation, workflow contract language, and agent guidance so the branch model is part of the reusable framework.

## Capabilities

### New Capabilities
- `gitflow-branching-policy`: reusable branching and release policy for repositories that consume this platform.

### Modified Capabilities
- `core-workflow-contracts`: include branch-strategy requirements for OpenSpec-driven delivery.

## Impact

- Updates shared branching guidance in repository docs and workflow contracts.
- Affects all consumer repositories that import this project as a submodule.
- Requires agents and maintainers to treat each OpenSpec change as a feature branch unit of work.
