## Task Refinement Gate

- Status: <READY|BLOCKED>
- Strict validation command: `<exact command>`
- Decision gaps: <None|exact unresolved decisions>
- Default executor: `<runtime>` using `<model>` with variant `<variant>`
- Executor boundary: Execute blocks and tasks in dependency order; stop on any unplanned product or technical choice.

## Execution Blocks

### Block <ID> — <Bounded block outcome>

- Block ID: `<ID>`
- Ordered tasks: `<task IDs in dependency order>`
- Executor: `<runtime>` using `<model>` with variant `<variant>`
- Requirements: `<requirement and scenario references>`
- External dependencies: `<satisfied task or block IDs|None>`
- Allowed targets: `<exact paths and symbols>`
- Forbidden scope: `<explicit exclusions>`
- Commands: `<exact block-level commands and expected results>`
- Stop conditions: `<decision, scope, security, verification, and non-local action stops>`
- Completion: `<objective block completion conditions>`
- Single-task reason: `<required only for bootstrap, final integration, or indivisible work>`

## 1. <Task Group>

- [ ] 1.1 <One bounded, verifiable outcome>
  - Outcome: `<observable result>`
  - Requirements: `<capability requirement names>`
  - Scenarios: `<scenario names>`
  - Dependencies: `<task IDs|None>`
  - Execution block: `<Block ID>`
  - Executor: `<runtime>` using `<model>` with variant `<variant>`
  - Targets: `<exact file paths and symbols; exact paths for new files>`
  - RED: `<test/assertion edit, exact command, expected failure>`
  - GREEN: `<ordered implementation edits, exact command, expected pass>`
  - REFACTOR: `<bounded cleanup, exact regression command, expected pass>`
  - Evidence: `<required command results and changed-file evidence>`
  - Completion: `<objective conditions requiring no implementation choice>`

- [ ] 1.2 <Non-behavior outcome>
  - Outcome: `<observable result>`
  - Requirements: `<capability requirement names>`
  - Scenarios: `<scenario names>`
  - Dependencies: `<task IDs|None>`
  - Execution block: `<Block ID>`
  - Executor: `<runtime>` using `<model>` with variant `<variant>`
  - Targets: `<exact file paths and sections>`
  - TDD: Not applicable — <reason>
  - Steps: `<ordered edit steps without optional branches>`
  - Verification: `<exact local commands and expected results>`
  - Evidence: `<required command results and changed-file evidence>`
  - Completion: `<objective conditions requiring no implementation choice>`
