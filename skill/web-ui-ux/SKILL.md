# Web UI UX Guidance

Use this skill for web frontend implementation work when the request involves UI, UX, responsive behavior, layout, visual polish, component composition, design-system usage, or screen/page refinement.

## Scope

Apply this skill when the task requires:

- implementing or refining web UI screens or sections
- improving visual hierarchy, spacing, density, or states
- reusing design-system or component-library patterns
- validating responsive behavior or accessibility on frontend work
- iterating Angular UI today, with future reuse for other web stacks such as Astro

Do not use this skill as a substitute for framework-specific architecture rules. Keep framework internals in the active stack pack.

## Required Workflow

1. Inspect existing components, styles, tokens, layout primitives, and page patterns before editing code.
2. Summarize the current visual language in concrete terms: typography, spacing, density, color usage, radius, and component reuse opportunities.
3. Reuse existing components and patterns before inventing new ones.
4. Define the target structure of the screen or section before broad UI edits.
5. Cover key UI states: loading, empty, error, hover, focus, disabled, and responsive breakpoints when relevant.
6. Verify accessibility basics: semantic structure, labels, keyboard focus, and contrast-sensitive decisions when applicable.
7. Close the task with explicit visual verification evidence, not only code completion.

## Design Guardrails

- Avoid generic SaaS-style filler layouts when the repository already has established UI patterns.
- Prefer measurable constraints over vague style language.
- Keep spacing and hierarchy consistent across related sections.
- Preserve or improve responsive behavior.
- Prefer small, reviewable UI changes over broad visual rewrites unless explicitly requested.

## Expected Output

- Current visual-language summary.
- Reused components/patterns and any new UI primitives introduced.
- Covered states and responsive/accessibility considerations.
- Verification commands or evidence used for UI review.
