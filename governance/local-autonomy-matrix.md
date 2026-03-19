# Local-Only Autonomy Matrix

OpenCode automation is restricted to local development workflows.

| Action Category | Local | Dev/Integration | Staging | Production |
|---|---|---|---|---|
| Edit code/spec/docs | Allowed | Blocked | Blocked | Blocked |
| Run local tests/lint/build | Allowed | Blocked | Blocked | Blocked |
| Create OpenSpec artifacts | Allowed | Blocked | Blocked | Blocked |
| Validate OpenSpec (`--strict`) | Allowed | Blocked | Blocked | Blocked |
| Deploy or release actions | Blocked | Blocked | Blocked | Blocked |
| Infra apply/mutation | Blocked | Blocked | Blocked | Blocked |
| Approval workflow actions | Blocked | Blocked | Blocked | Blocked |

Non-local lifecycle actions must be transferred to the external operator through the handoff artifact.
