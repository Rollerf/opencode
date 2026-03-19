# Security and Compliance Baseline

Every stack pack must include and document these minimum controls.

## Mandatory Controls

1. Secret handling
   - No secrets in source files, tests, or fixtures.
   - Use environment variables or local secret stores.

2. Dependency and license checks
   - Validate dependency health and approved licenses.
   - Record command used by each stack.

3. Vulnerability handling
   - High/Critical findings unresolved count must be zero before promotion.
   - Document mitigation for accepted residual risks.

4. Prohibited high-risk commands
   - Disallow deploy/release/infra apply commands in autonomous execution.
   - Enforce local-only action boundary.

## Verification Template

Each pack should expose a table like this:

| Control | Command/Check | Expected Result |
|---|---|---|
| Secret scan | `<stack-command>` | No secrets detected |
| Dependency/license check | `<stack-command>` | Allowed only |
| Vulnerability scan | `<stack-command>` | High/Critical = 0 |
| Prohibited commands policy | `pack.yaml` review | Explicit blocked list |
