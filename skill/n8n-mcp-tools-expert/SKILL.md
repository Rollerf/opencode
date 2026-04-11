# n8n MCP Tools Expert (Wrapper)

This wrapper exposes the upstream n8n MCP tools skill in a way that is compatible with this repository's skill loader and routing model.

## Scope

Use this skill when the task requires:

- n8n workflow creation or debugging
- n8n node/tool discovery
- n8n workflow validation loops
- n8n-mcp tool usage patterns

## Source of Truth

Primary upstream skill file:

- `third_party/n8n_skills/skills/n8n-mcp-tools-expert/SKILL.md`

Recommended upstream references:

- `third_party/n8n_skills/skills/n8n-mcp-tools-expert/WORKFLOW_GUIDE.md`
- `third_party/n8n_skills/skills/n8n-mcp-tools-expert/VALIDATION_GUIDE.md`
- `third_party/n8n_skills/skills/n8n-mcp-tools-expert/SEARCH_GUIDE.md`

## Usage Rules

1. Keep this skill opt-in via explicit n8n intent or `$n8n-gateway`.
2. Prefer n8n-mcp validation loops before finalizing workflow changes.
3. Keep non-n8n tasks on the default OpenSpec workflow.
