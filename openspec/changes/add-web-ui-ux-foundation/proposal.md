## Why

Angular projects in this platform already have a UI validation loop through Playwright, but they still lack reusable visual and UX guidance. That gap makes the implementation agent produce generic frontend work because it has browser validation commands but no explicit web UI language, audit workflow, or polish checklist.

We need a shared web UI/UX foundation that improves Angular work now without locking the platform into Angular-only frontend guidance. The same base should remain reusable when an Astro pack is added later.

## What Changes

- Add a reusable `web-ui-ux` skill for web frontend work, focused on visual audits, component reuse, states, responsive behavior, accessibility, and evidence-driven UI iteration.
- Integrate that skill into Angular-first implementation guidance so Angular UI tasks activate shared web UI rules plus Angular-specific commands.
- Extend routing and session bundling so skill selection can account for stack pack + task intent, avoiding backend-only guidance and preventing `backend-design` from being applied to Angular UI work.
- Add validation and documentation to keep the new skill and Angular usage path discoverable and stable.

## Capabilities

### New Capabilities
- `web-ui-ux-guidance`: reusable UI/UX guidance for web frontend implementation across current and future web stacks.

### Modified Capabilities
- `agent-catalog-routing`: activate shared web UI guidance for Angular frontend/UI intent while preserving intent-first routing.
- `stack-capability-packs`: allow web-oriented packs to compose shared UI guidance with framework-specific commands and constraints.

## Impact

- Adds a new reusable skill under `skill/`.
- Updates Angular pack guidance and implementation/routing prompts.
- Requires pack-aware skill selection support in `opencode-runner.sh` or equivalent bundle logic, including exclusion of backend-specific skills for frontend/UI intent.
- Adds validation/docs coverage for the new frontend specialization path.
