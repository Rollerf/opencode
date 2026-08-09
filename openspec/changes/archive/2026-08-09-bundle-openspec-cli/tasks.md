# Tasks: Bundle the OpenSpec CLI with the Platform

## 1. RED contracts

- [x] 1.1 Extend runner validation to require module-local OpenSpec path and version 1.1.1 from doctor.
- [x] 1.2 Extend distribution validation to require exact runtime dependency `@fission-ai/openspec@1.1.1`.
- [x] 1.3 Run affected contracts and record RED failures before dependency and resolver implementation.

## 2. GREEN implementation

- [x] 2.1 Add exact production dependency `@fission-ai/openspec@1.1.1` and regenerate `package-lock.json`.
- [x] 2.2 Update `opencode-runner.sh` with module, PATH, and project CLI resolution order.
- [x] 2.3 Add actionable missing-CLI diagnostics and selected path/version doctor evidence.
- [x] 2.4 Update `README.md` and `CONTRIBUTING.md` with platform-local installation guidance.

## 3. Verification

- [x] 3.1 Run affected contracts and confirm GREEN.
- [x] 3.2 Run `scripts/validate/run-all.sh` through RTK.
- [x] 3.3 Run `scripts/evals/run-all.sh` through RTK and confirm the promotion gate passes.
- [x] 3.4 Run `openspec validate "bundle-openspec-cli" --strict` with the bundled CLI.
- [x] 3.5 Run `git diff --check` and verify intended files.

## 4. Implementation closure

- [x] 4.1 Commit the verified feature implementation.
