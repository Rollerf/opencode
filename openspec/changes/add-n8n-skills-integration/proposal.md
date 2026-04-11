## Why

Projects that consume this repository as a submodule need optional n8n workflow support without rebuilding guidance from scratch. Integrating the public `n8n-skills` library allows OpenCode agents to use proven n8n-specific guidance when the user requests n8n work.

## What Changes

- Add third-party n8n skills source at `third_party/n8n_skills`.
- Expose n8n skills through repository-native skill wrappers under `skill/` so they can be loaded consistently.
- Extend routing rules so n8n intent can activate n8n skills when requested by the user.
- Add validation checks to ensure n8n skill integration remains usable over time.

## Capabilities

### New Capabilities
- `n8n-skill-integration`: consume and expose external n8n skills through this repository.
- `n8n-intent-routing`: route n8n workflow requests to n8n skills as needed.

### Modified Capabilities
- `agent-catalog-routing`: include n8n-specific routing guidance as optional specialization.
- `stack-capability-packs`: optionally reference n8n automation support for projects that need it.

## Impact

- Adds an external skills source under `third_party/`.
- Adds new skill directories and manifests in `skill/`.
- Updates orchestrator/routing documentation to describe n8n intent handling.
- Adds validation coverage for n8n skill availability.
