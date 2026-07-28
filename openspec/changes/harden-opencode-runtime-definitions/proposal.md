## Why

The repository's validated source definitions can diverge from what OpenCode actually loads: the repository embeds a stale copy of itself at `.opencode`, several repository-owned skills are invisible to the native loader, consumer-mode bundles resolve the wrong project root, and current routing and bundling can duplicate work and context. These gaps create correctness, maintenance, and token-cost risks even though the existing string-based validators pass.

## What Changes

- **BREAKING** Remove the repository's self-referential `.opencode` submodule and replace recursive self-consumption with an isolated consumer fixture and documented installation contract.
- Separate the runner's platform module directory from the consuming project root so agents, skills, and packs come from the module while OpenSpec artifacts and project commands come from the consumer.
- Add valid native OpenCode frontmatter to every repository-owned skill. Keep `third_party/n8n_skills` immutable as an external submodule and fix only the repository-owned n8n wrapper skills.
- **BREAKING** Replace phase agents (`planner`, `spec-hardener`, `implementer`, `verifier`, and `archiver`) with loadable phase-contract skills used by the single primary orchestrator.
- Define deterministic routing precedence: phase first, stack second, skill overlays third, and bounded subagent delegation last.
- Assign `openai/gpt-5.6-sol` to the orchestrator and code-changing/high-risk specialists, and `openai/gpt-5.6-luna` to bounded documentation and design helpers. Add role-specific step limits and deny nested delegation from leaf subagents.
- **BREAKING** Make bundle references opt-in, place the user goal before bundled context, include the selected pack contract, select phase-relevant OpenSpec artifacts, and use safe content boundaries. Report bundle size without enforcing a maximum token budget.
- Make shared subagents stack-neutral and move Go/AWS assumptions into the `go-aws` pack and `$backend-design` overlay.
- Make `core/agent-catalog.yaml` match runtime names and paths, include the orchestrator, and become an input to routing and validation instead of documentation-only metadata.
- Replace string-presence validation with structured checks plus a disposable consumer fixture that verifies native agent/skill discovery, runner path resolution, pack inclusion, model/step policy, routing references, bundle behavior, and self-submodule absence.
- Keep the migration from deprecated broad `tools` declarations to least-privilege `permission` rules outside this change, as explicitly deferred by the operator. Validators may report the deprecation but SHALL NOT fail this change for it.

## Goals

- Make validated definitions match runtime-discovered definitions.
- Prevent recursive/stale self-installation and consumer path confusion.
- Reduce unnecessary context and subagent cost without imposing an arbitrary token ceiling.
- Preserve a single orchestrator entrypoint with explicit, loadable phase contracts.
- Make stack and specialization behavior deterministic and testable.

## Non-Goals

- Selecting or enforcing a maximum bundle token count.
- Migrating agent tool access to least-privilege `permission` rules in this change.
- Modifying files owned by the `third_party/n8n_skills` submodule.
- Changing application repositories that consume this module, except through documented migration steps and fixture coverage.
- Changing OpenSpec artifact semantics, Gitflow policy, or local-only lifecycle policy.

## Capabilities

### New Capabilities

- `runtime-definition-integrity`: Native discovery, module/consumer path separation, owned-skill metadata, bundle composition, model/step policy, and distribution integrity.

### Modified Capabilities

- `agent-catalog-routing`: Make routing precedence deterministic, convert phase ownership to skill-based contracts, bound specialist delegation, and align catalog IDs with runtime names.
- `core-workflow-contracts`: Preserve phase completion criteria through loadable phase skills under the single orchestrator entrypoint.
- `stack-capability-packs`: Ensure selected pack constraints and commands reach the runtime and shared subagents remain stack-neutral.
- `quality-evaluation-harness`: Add structured validation and consumer-fixture checks that exercise actual runtime definitions instead of raw text presence.

## Impact

- Distribution and repository structure: `.gitmodules`, the `.opencode` gitlink, README installation guidance, and a new consumer fixture.
- Runtime definitions: `agents/`, `skill/`, `core/agent-catalog.yaml`, and `core/routing-policy.md`.
- Bundling and phase execution: `opencode-runner.sh` and its validation fixtures.
- Stack behavior: `packs/*/pack.yaml`, especially moving Go/AWS-only guidance out of shared subagents.
- Validation: `scripts/validate/`, package metadata for structured parsing if required, and evaluation fixtures.
- External source boundary: `third_party/n8n_skills` remains unchanged; repository-owned wrappers under `skill/n8n-*` are updated.
- Security: no live deployment behavior changes; the known broad/deprecated agent tool declarations remain a documented follow-up risk.
- API/data/Pulumi: no application API, data model, migration, or Pulumi resource changes.
