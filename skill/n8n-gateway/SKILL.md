# n8n Gateway

Use this skill only when the user explicitly requests n8n support or the intent clearly references n8n workflows.

## Activation Criteria

Activate when requests include terms like:

- `n8n`
- `workflow automation`
- `n8n-mcp`
- `n8n node`
- `n8n expression`
- `n8n Code node`

Do not activate for general backend/frontend/OpenSpec requests.

## Gateway Behavior

1. Confirm n8n intent from the request context.
2. Load `$n8n-mcp-tools-expert` as the primary specialized skill.
3. Keep context scoped to the minimum required n8n guidance.
4. Fall back to standard repository workflow for non-n8n tasks.

## Upstream Source

The external source of truth is:

- `third_party/n8n_skills/skills/n8n-mcp-tools-expert/SKILL.md`

Use additional upstream n8n skills only when the task requires them.
