## Why

Astro projects currently fall back to the confirmation-only `generic` pack, so the workflow cannot infer Astro or provide framework-specific rendering, TypeScript, test, build, UI, SEO, AI-agent discoverability, API-contract, analytics-consent, accessibility, and AWS hosting guidance. This organization uses Astro only for public websites whose information must be understandable by people, search systems, assistive technologies, and AI agents or tools. A reusable Astro pack is needed for sites such as `ames-web`, where static output is hosted from S3, CRM-backed public content remains statically generated, browser and build integrations consume Lambda APIs through OpenAPI-generated TypeScript clients, and Google Analytics is normally consent-gated, while still allowing explicitly designed on-demand rendering where SSG cannot satisfy route requirements.

## Goals

- Add deterministic first-class detection for Astro projects.
- Treat selection of the Astro pack as explicit public-website SEO intent and require technical SEO validation.
- Publish concise, current, machine-readable discovery information that helps AI agents locate and understand canonical public content.
- Generate a deterministic TypeScript API client from the backend-owned OpenAPI contract and reject contract drift.
- Make Google Analytics conditional on accessible, revocable consent and a project-owned cookie policy.
- Establish WCAG 2.2 AA as the continuous accessibility target, with EN 301 549 and applicable Spanish law assessed per project.
- Define implementation-ready guidance for Astro static, mixed prerendered/on-demand, and server-rendered modes with TypeScript and npm scripts.
- Keep public CRM-backed content on SSG and define build-time content, publication, freshness, failure, and runtime API boundaries.
- Make S3 static-hosting and Lambda runtime boundaries explicit so SSR output is never treated as S3-hostable content.
- Reuse shared frontend/UI guidance while keeping backend guidance excluded from frontend-only work.
- Preserve local-only execution, TDD, and security controls required of every stack pack.

## Non-goals

- Select or install a specific Astro AWS adapter, provision AWS infrastructure, or execute deployment commands.
- Treat existing backend API Lambdas as an Astro SSR runtime without an explicit adapter and request-routing design.
- Define CRM administration interfaces or require them to use Astro.
- Guarantee search ranking, traffic, rich-result eligibility, or project-specific search performance.
- Guarantee discovery, citation, retrieval, training inclusion, or answer selection by any AI provider.
- Expose private, draft, authenticated, or CRM-administration content to crawlers or agents.
- Select a universal OpenAPI generator, consent-management platform, legal interpretation, analytics event taxonomy, or assistive-technology test matrix.
- Claim WCAG or legal conformity from automated testing alone.
- Require a specific UI integration such as React, Vue, Svelte, or Solid.
- Modify the shared `web-ui-ux`, `playwright-cli`, or `seo-expert` skills.
- Change an Astro consumer project or deploy a generated site.

## What Changes

- Add `packs/astro/pack.yaml` with Astro detection markers; mandatory public SEO, AI-discoverability, and WCAG 2.2 AA context; rendering-profile and TypeScript constraints; OpenAPI client commands; consent-gated analytics and cookie-policy constraints; CRM SSG and AWS hosting boundaries; npm verification and TDD commands; SEO/frontend/full-stack skill overlays; AI discovery and accessibility commands/templates; and prohibited non-local actions.
- Add `packs/astro/README.md` with technical SEO; AI-agent discovery and `llms.txt`; OpenAPI client generation and drift checks; Google Analytics consent, cookie inventory, and policy requirements; continuous accessibility testing; CRM-backed SSG publication; static S3, mixed rendering, SSR compute, Lambda API integration, UI/browser validation, TDD, and security guidance.
- Extend stack-pack specifications and repository documentation to list Astro as a first-class pack.
- Add validation coverage proving the new pack is structurally valid and detected only when all required Astro markers match.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `stack-capability-packs`: Add public SEO-, AI-discovery-, API-contract-, privacy-, and accessibility-first Astro with TypeScript and explicit CRM-backed SSG, static S3, mixed rendering, SSR compute, and Lambda API boundaries to the first-class pack catalog.

## Scope Boundaries

The pack targets npm-based Astro projects containing `astro.config.mjs` and an `astro` dependency in `package.json`. It is restricted to public websites for which technical SEO, AI-agent discoverability, typed API-contract compliance, privacy-aware analytics, and WCAG 2.2 AA accessibility are mandatory quality attributes. Static output hosted from S3 is the default profile, and public content supplied by a CRM remains SSG. Machine-readable discovery surfaces expose only canonical published information and must remain synchronized with the human-visible site. Backend operations consumed by Astro use a generated TypeScript client from a validated OpenAPI document. Google Analytics remains disabled until the project-defined consent requirements are satisfied. Mixed or fully on-demand rendering is supported only when SSG cannot meet an observable route requirement and active OpenSpec artifacts define the adapter, compute runtime, route ownership, caching, security, SEO, AI-discovery, accessibility, privacy, and verification decisions. S3 stores only static/prerendered assets; server-rendered requests require a separate runtime such as a dedicated Lambda integration. Backend API Lambdas and CRM administration interfaces remain separate services unless explicitly designed otherwise.

## Open Decisions

None. Detection markers, mandatory public SEO and AI-discovery intent, OpenAPI client lifecycle, analytics-consent baseline, WCAG 2.2 AA target, CRM-backed SSG boundaries, rendering profiles, S3 and Lambda boundaries, package manager baseline, commands, and specialization composition are defined by this change. Canonical domain, locale strategy, route inventory, AI-crawler access policy, optional Markdown alternates, OpenAPI generator and artifact source, Google Analytics property and event taxonomy, consent platform, cookie inventory and legal owner, accessibility legal applicability and supported assistive-technology matrix, CRM publication trigger, freshness target, unavailable-backend policy, adapter, and infrastructure products remain mandatory project-level decisions rather than pack defaults.

## Impact

- Pack catalog: `packs/astro/pack.yaml` and `packs/astro/README.md`.
- Runtime validation and detection fixtures under `scripts/validate/` if existing self-tests need explicit Astro coverage.
- Documentation and specifications that enumerate supported packs.
- No production APIs, data models, infrastructure, deployments, or consumer-owned project files are changed; the pack adds architecture and handoff constraints only.
