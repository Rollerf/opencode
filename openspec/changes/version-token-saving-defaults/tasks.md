# Tasks: Version Global Token-Saving Defaults

## 1. Contract-first validation

- [x] 1.1 Add `scripts/validate/token-savings-defaults-contract.sh` with checks for the Caveman instruction, RTK plugin, global config template, orchestrator default, and validation-runner integration.
- [x] 1.2 Add the contract invocation to `scripts/validate/run-all.sh`.
- [x] 1.3 Run the contract before adding runtime assets and record the expected RED failure.

## 2. Version portable runtime defaults

- [x] 2.1 Add `instructions/caveman-default.md` with default full-mode behavior, explicit opt-out, fallback behavior, and protected-output boundaries.
- [x] 2.2 Add `plugins/rtk.ts` with RTK availability detection, Bash/shell interception, delegated rewriting, and pass-through fallback.
- [x] 2.3 Add `core/templates/opencode.global.json` with relative instruction and skill paths and no machine-specific settings.
- [x] 2.4 Change `agents/orchestrator.md` from opt-in Caveman activation to Caveman full mode by default.

## 3. Document pull-based consumption

- [x] 3.1 Update `README.md` with installation, pull, restart, RTK prerequisite, and machine-owned config guidance.
- [x] 3.2 Update `CONTRIBUTING.md` with the versioned-versus-machine-owned boundary for global runtime defaults.

## 4. Green and refactor verification

- [x] 4.1 Run the dedicated token-saving contract and confirm GREEN.
- [x] 4.2 Run `scripts/validate/run-all.sh` and resolve regressions without weakening existing tests.
- [x] 4.3 Run `scripts/evals/run-all.sh` and confirm the promotion gate passes.
- [x] 4.4 Run `openspec validate "version-token-saving-defaults" --strict` and resolve all critical findings.
- [x] 4.5 Run `git diff --check` and verify the intended tracked-file set.

## 5. Distribution closure

- [ ] 5.1 Commit the verified implementation on `feature/version-token-saving-defaults`.
- [ ] 5.2 Archive the completed OpenSpec change and validate synchronized specs.
- [ ] 5.3 Merge locally through `develop`, `release/*`, and `main`.
- [ ] 5.4 Reconcile ignored global copies, update `~/.config/opencode` to released `main`, and verify effective Caveman and RTK discovery.
- [ ] 5.5 Provide operator handoff for remote pushes and restart OpenCode.
