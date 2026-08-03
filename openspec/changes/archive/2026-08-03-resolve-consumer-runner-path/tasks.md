# Tasks: Resolve the Runner from Consumer Projects

## 1. Consumer integration RED

- [x] 1.1 Extend `scripts/validate/runtime-runner-contract.sh` with an external consumer fixture that invokes the platform runner by absolute path.
- [x] 1.2 Assert module and project roots plus consumer-owned change content in the generated bundle.
- [x] 1.3 Run the contract and record the expected RED failure against current project-root inference.

## 2. Runner and policy GREEN

- [x] 2.1 Update `opencode-runner.sh` to infer an external invocation working directory as `PROJECT_ROOT` while preserving source and `.opencode` layouts.
- [x] 2.2 Update `agents/orchestrator.md` with source, vendored, and global runner discovery order.
- [x] 2.3 Update `skill/openspec-workflow/SKILL.md`, `skill/openspec-planning/SKILL.md`, and archive guidance to use the resolved runner path.
- [x] 2.4 Update workflow contract validation for the portable discovery policy.
- [x] 2.5 Update `README.md` and `CONTRIBUTING.md` with global consumer invocation examples.

## 3. Verification

- [x] 3.1 Run the runner contract and confirm GREEN.
- [x] 3.2 Run `scripts/validate/run-all.sh` through RTK and resolve regressions.
- [x] 3.3 Run `scripts/evals/run-all.sh` through RTK and confirm the promotion gate passes.
- [x] 3.4 Run `openspec validate "resolve-consumer-runner-path" --strict`.
- [x] 3.5 Run `git diff --check` and verify intended files.

## 4. Implementation closure

- [x] 4.1 Commit the verified feature implementation.
