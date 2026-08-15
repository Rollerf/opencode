## Context

The repository currently provides Angular web guidance but no Astro pack. Astro projects therefore fail stack inference and require confirmation of `generic`, losing framework-specific rendering, TypeScript, UI, SEO, AI-agent discovery, AWS-boundary, and verification guidance. The organization reserves Astro for public websites where technical SEO and machine understanding are mandatory. `ames-web` provides the target baseline: npm, `astro.config.mjs`, Astro's default static output, TypeScript, Vitest through `npm test`, `astro check` through `npm run check`, Lighthouse through `npm run audit:lighthouse`, and `astro build` through `npm run build`. Its expected production shape places static frontend assets in S3 and normally exposes backend capabilities through AWS Lambda APIs. When public content is managed through a CRM, the public pages remain statically generated from published backend data.

Astro supports `output: "static"` and `output: "server"`. Static is the default. Mixed rendering is achieved with an adapter and per-route prerender controls, not a separate current `hybrid` output value. S3 can host static/prerendered artifacts but cannot execute an Astro server entry. True on-demand rendering therefore needs a separate compute runtime and request-routing design. Existing backend API Lambdas are separate from an Astro rendering runtime unless an adapter and architecture explicitly make them part of that runtime.

The existing pack resolver accepts only conjunctive `path_exists` and literal `file_contains` markers. Pack definitions must remain local-only, satisfy the shared security baseline, and keep shared frontend and Go/AWS concerns in specialization skills instead of duplicating them in framework constraints.

## Goals / Non-Goals

**Goals:**

- Add an automatically detectable `astro` pack for Astro projects using TypeScript and npm.
- Establish mandatory technical SEO behavior for every Astro consumer because pack selection represents explicit public-web SEO intent.
- Establish mandatory, content-parity-safe discovery surfaces for AI agents and tools.
- Generate and verify a reusable TypeScript client from the backend-owned OpenAPI contract.
- Gate Google Analytics behind an accessible consent experience and project-owned cookie policy.
- Make WCAG 2.2 AA accessibility a continuous quality gate rather than a launch-only audit.
- Keep CRM-backed public content on SSG while defining build-time and runtime backend boundaries.
- Support a static S3 default plus explicitly designed mixed and server-rendered profiles.
- Define boundaries among S3 assets, Astro rendering compute, and backend Lambda APIs.
- Make commands and architecture boundaries concrete enough for implementation and verification without operator interpretation.
- Compose Astro-specific constraints with shared UI and optional browser guidance.
- Validate the pack through existing runtime-definition, TDD-contract, and pack-resolution paths.

**Non-Goals:**

- Select a specific AWS adapter or infrastructure framework as a universal default.
- Provision S3, CloudFront, API Gateway, Lambda, IAM, DNS, certificates, or deployment pipelines.
- Reuse backend API Lambda handlers as Astro rendering functions without a project-specific design.
- Add framework integrations, runtime dependencies, or consumer application code.
- Make Playwright active for every Astro task.
- Define business keywords, canonical production domains, locales, editorial claims, CRM products, or ranking guarantees.
- Guarantee AI retrieval, citation, model-training inclusion, answer selection, or provider-specific behavior.
- Treat `llms.txt` as an access-control mechanism or a replacement for robots, sitemaps, canonical HTML, or structured data.
- Select one OpenAPI generator, consent-management platform, analytics property, screen reader, or legal interpretation for every consumer.
- Treat Google Analytics as a substitute for measured Core Web Vitals or operational monitoring.
- Claim legal or WCAG conformity solely because automated checks pass.
- Expand the resolver with negated or alternative detection markers.

## Decisions

### 1. Use the framework-level name `astro`

The pack will be `packs/astro`, matching the naming style of `packs/angular`. It will be static-first rather than named `astro-ssg`: Astro's default output is static, the requested consumer uses that default, and the same framework pack can safely govern explicitly selected on-demand profiles.

Alternative considered: separate `astro-ssg` and `astro-ssr-aws` packs. Rejected because both would share the same deterministic framework markers and cause ambiguous automatic detection. One pack with explicit project-level rendering profiles preserves one-pack resolution.

### 2. Detect the target project shape with two conjunctive markers

Detection will require both `astro.config.mjs` and the literal `"astro"` in `package.json`. This avoids matching a package that merely mentions Astro without having the expected project configuration and exactly matches `ames-web`.

Alternative considered: require `output: 'static'` in `astro.config.mjs`. Rejected because Astro static output is the default and valid projects, including `ames-web`, omit that redundant setting.

Trade-off: Astro projects using `astro.config.ts` or another supported config filename will not be inferred automatically. They can explicitly select the pack; support for alternative markers requires a future resolver capability because current required markers have AND semantics only.

### 3. Use npm scripts as the stable command interface

The pack will use:

- Test: `npm test`
- Build: `npm run build`
- Lint/static analysis: `npm run check`
- RED: `npm test`
- GREEN: `npm test`
- REFACTOR: `npm test && npm run check && npm run build`

`npm run check` maps the required pack lint gate to Astro's framework-aware TypeScript and template diagnostics. The README will state that consumer projects must provide these scripts. Direct `npx` framework commands are avoided for baseline checks so projects retain control over pinned local versions.

### 4. Model three rendering profiles with static as the default

The README and pack constraints will define:

1. **Static S3:** Astro's default static output; every public SEO route is prerendered, generated assets are S3-compatible, and Lambda APIs are called through explicit public contracts.
2. **Mixed:** static output remains the default, selected routes opt out with `prerender = false`, and an adapter-backed compute runtime serves those routes. Static and dynamic request ownership must be documented.
3. **Server:** `output: "server"` renders routes on demand by default, selected routes may opt into prerendering, and an adapter-backed compute runtime is mandatory.

All profiles preserve strict TypeScript, semantic and accessible markup, and minimal client JavaScript. Astro components remain non-hydrated by default; client hydration is introduced only for explicit interaction needs.

Alternative considered: use an `output: "hybrid"` example. Rejected because current Astro exposes `static` and `server`; mixed behavior uses per-route prerender controls.

### 5. Separate S3, Astro SSR compute, and backend Lambda APIs

S3 will be documented as an origin for static/prerendered files only. A mixed or server profile targeting AWS requires an adapter that emits a compatible server entry, a dedicated compute deployment, and routing such as a CDN or gateway behavior that directs each route to the correct origin. The pack will not select the adapter because official Astro adapters do not provide a universal direct-to-Lambda choice and community/AWS solutions have different output and operational contracts.

Backend Lambda APIs remain independent services. Static pages, client islands, or Astro server code may call them through documented API endpoints. Browser-facing integrations must define allowed origins and authentication semantics for the S3 or delivery-layer origin. Public client configuration may expose a non-secret API base URL; credentials and private service values must remain server-side. Existing API handlers are not repackaged as Astro SSR handlers.

For Go/AWS backend changes, `backend-design` supplies Handler to UseCase to Storage, RFC 7807, security, and test constraints. Those constraints apply only when the request explicitly includes that backend or when working in its separately resolved project.

### 6. Reuse shared SEO, frontend, and backend specializations

Pack selection itself establishes explicit SEO intent because this pack is restricted to public SEO-dependent websites. A `public_web` overlay will include `seo-expert`; `skill_overlays.ui_frontend` will include both `seo-expert` and `web-ui-ux` while excluding `backend-design`. An explicit Go/AWS full-stack overlay will allow `seo-expert`, `web-ui-ux`, and `backend-design` together only when one request changes both sides. A backend in another project resolves its own stack pack. The README will direct browser-evidence work to `playwright-cli`. Astro internals and commands stay in the pack.

### 7. Make technical SEO a pack invariant

Every Astro project will classify routes as indexable or non-indexable before implementation. Indexable routes must emit useful HTML without client execution and define deterministic titles, descriptions, absolute canonicals, crawl directives, sitemap inclusion, and successful status behavior. Locale variants require consistent hreflang only when the project declares multiple locales. Structured data is optional and emitted only when visible content supports it. Non-indexable routes must keep HTML directives, response headers where applicable, robots policy, and sitemap membership consistent.

The pack will require `npm run audit:lighthouse` in addition to test, check, and build evidence. After `npm run build`, local evidence uses `npm run preview -- --host 0.0.0.0 --port 4321` and `AUDIT_URL=http://127.0.0.1:4321 npm run audit:lighthouse`. Lighthouse is supporting technical evidence, not proof of indexing, ranking, traffic, rich-result eligibility, or AI discovery. Each project must still inspect rendered HTML, `robots.txt`, sitemap output, canonical relationships, redirects, status codes, structured data, and machine-readable discovery output. Core Web Vitals work must use measured evidence and project-owned thresholds rather than universal invented scores.

### 8. Publish synchronized AI-agent discovery surfaces

Every Astro site will publish `/llms.txt` as the organizational default for concise AI-agent discovery. The file follows the current llms.txt proposal, but the pack will document that this remains a convention rather than an access-control or ranking standard. It contains the site name, a factual summary, and curated absolute links to canonical public resources. A repository template under `packs/astro/templates/public/llms.txt` provides structure without inventing project facts.

`llms.txt`, sitemaps, structured data, feeds when applicable, and optional Markdown alternates must be generated or validated against the same published route/content inventory as the human site. Machine-readable text cannot contain claims, instructions, URLs, or content unavailable from canonical public pages; this prevents cloaking and stale alternate truth. When Markdown alternates exist, HTML advertises them with `rel="alternate"` and `type="text/markdown"`, and the alternate preserves the source page's meaning, canonical identity, publication state, and locale.

Each project must define crawler policy separately for search indexing, AI-assisted retrieval/inference, and model training where user-agent controls permit that distinction. `robots.txt` communicates the selected access policy; `/llms.txt` describes allowed public content and never grants access. Authenticated, draft, private, personalized, or secret-bearing material is excluded from all discovery artifacts.

The same build that produces public SSG output must refresh `/llms.txt` and any alternates. Local verification fetches `/llms.txt`, validates its format and absolute links, rejects non-canonical or non-published entries, and checks that removed routes do not remain advertised. This evidence cannot prove that any external agent fetched, indexed, cited, or used the content.

### 9. Keep CRM-backed public content on SSG

A CRM in this architecture is a content or business-data backend, not the public rendering runtime and not necessarily an Astro administration UI. The Astro build reads only publishable data through a documented build-time contract and generates complete indexable HTML. Active project artifacts must define the publication-state filter, build authentication, build trigger, freshness target, cache/invalidation ownership, and behavior when the CRM or backend is unavailable. Allowed failure policies are project-selected fail-closed or an explicitly approved last-known-good input; silently producing partial pages is not allowed.

CRM publication does not mutate S3 pages directly. A project-owned trigger starts the build/publish lifecycle, and the external operator owns non-local publication. Runtime interactions such as forms, search, account actions, or inventory checks may call Lambda APIs through separate typed contracts, but they must not make the primary SEO content dependent on client-side rendering.

### 10. Generate TypeScript clients from backend OpenAPI contracts

The backend owns an OpenAPI document describing available operations, schemas, authentication, and errors. Each Astro project must expose `npm run api:generate` and `npm run api:check`. The selected generator and configuration are pinned in project dependencies or another versioned tool declaration. Generation consumes a validated, version-identifiable OpenAPI artifact supplied through a project-owned local path or integrity-controlled fetch step; it must not depend on an unversioned production endpoint during normal local verification.

Generated TypeScript code is isolated from handwritten application code, carries a generated-file warning, and is never edited manually. Runtime base URLs and authentication are injected through typed configuration. Reusable UI components remain transport-agnostic where practical: pages, use cases, or application adapters call the generated client and map transport models into component-facing props. This preserves component reuse while retaining compile-time contract coverage.

`api:check` regenerates into a deterministic comparison target, fails on uncommitted drift or invalid generation, and runs TypeScript checking plus affected tests. A backend contract change is not accepted until generation succeeds, expected breaking changes are handled explicitly, and wrappers/components compile against the new client. RFC 7807 semantics remain preserved when declared by the backend contract. Secrets, credentials, and environment-specific URLs never enter generated source.

### 11. Gate Google Analytics behind accessible consent

Google Analytics is an expected but conditional integration. When enabled, the organizational default is basic consent behavior: analytics and advertising consent values start denied, and no analytics tag, cookie, storage write, or measurement request occurs before the user grants the relevant category. Advanced or cookieless measurement before consent requires an explicit project privacy decision and evidence that it matches the applicable policy; it is not the pack default.

The consent interface provides equally accessible accept, reject, and configure choices without preselected optional categories or deceptive emphasis. Users can reopen settings and revoke consent as easily as granting it. Consent state and policy version persist according to the project policy, and revocation updates Google consent state before later measurements. The banner, preferences interface, and cookie policy must themselves meet the accessibility contract.

Each project owns a concrete cookie inventory and policy covering provider, cookie or storage key, purpose, category, duration, first/third party status, recipients or transfers where applicable, how to withdraw consent, and policy date/version. Analytics events use an approved taxonomy and must not send secrets, direct identifiers, sensitive data, form values, or uncontrolled URL/query content. The Analytics identifier is non-secret environment configuration. Local browser evidence inspects storage and network traffic before consent, after acceptance, after rejection, and after revocation. Analytics loading must not block rendering or silently regress project performance budgets.

This design provides technical controls, not legal advice. Each consumer records policy ownership and applicable privacy/ePrivacy decisions, using current regulatory and provider guidance before production handoff.

### 12. Enforce continuous WCAG 2.2 AA accessibility

WCAG 2.2 Level AA is the technical conformance target for every Astro consumer. EN 301 549 is the European reference. Each project must record whether and how Real Decreto 193/2023 and Ley 11/2023 apply to its service, with qualified legal or compliance ownership; the pack does not make that applicability determination or a legal conformity claim.

Implementation starts with semantic HTML and native controls. ARIA supplements semantics only when no suitable native behavior exists, and custom widgets implement correct name, role, value, state, focus, and keyboard interaction. The contract covers keyboard-only operation, visible and unobscured focus, logical focus order, no keyboard traps, assistive-technology announcements, text and non-text contrast, color-independent meaning, responsive reflow, text zoom, target size, forms and validation, status messages, accessible authentication, reduced-motion behavior, and alternatives for non-text content.

Media provides the captions, transcripts, and audio-description alternatives required by the applicable WCAG criteria. Galleries, filters, modals, consent dialogs, maps, plans, and dynamically updated content preserve reading order, focus, keyboard access, and programmatic status. Maps and plans provide an equivalent text, list, table, directions, or assisted-contact path for the information or task they convey.

Every behavior or visual change receives automated checks plus manual keyboard review. Changes affecting complete user flows also receive manual testing with at least one project-declared screen reader/browser combination and relevant zoom/reflow checks. `npm run audit:a11y` is required supporting evidence, but automated tooling alone never establishes WCAG conformity. Accessibility regressions block completion and the checks repeat after new features and changes, not only before launch. A repository checklist template records scope, automated results, keyboard findings, screen-reader findings, zoom/reflow, media, maps/plans, unresolved barriers, owners, and retest date.

### 13. Extend existing contracts instead of changing resolver code

Implementation will add the pack and documentation, update enumerated pack catalogs, and add `astro` to the TDD contract's required pack list. Existing runtime-definition validation already scans every `packs/*/pack.yaml`. Resolver evidence will be verified against a local fixture and `ames-web`; no resolver behavior change is needed.

## Security, Data, API, and Infrastructure Impact

- Security: the pack remains local-only, prohibits deploy/release/production actions, and documents secret, dependency, license, and vulnerability checks. High or Critical vulnerability findings block promotion. Build-time CRM credentials remain server-side and never enter generated HTML, generated clients, analytics events, or public client variables. On-demand profiles must preserve Astro origin/forwarded-host protections, authentication boundaries, least-privilege runtime access, and secret isolation.
- Data: no data model, storage, migration, or content-schema changes.
- API: the pack documents typed build-time CRM and runtime Lambda API boundaries, requires deterministic TypeScript generation from OpenAPI, and preserves existing error/auth contracts but changes no endpoint.
- Infrastructure: the pack defines architectural responsibilities for S3, optional CDN/gateway routing, and optional Lambda compute but creates no resource, adapter selection, deployment command, or remote lifecycle action.

## Risks / Trade-offs

- [Astro project uses a non-`.mjs` config filename] -> It will not auto-match; use explicit `--pack astro` and consider future OR-marker support.
- [Consumer lacks `test` or `check` scripts] -> Baseline commands fail visibly; README documents required npm scripts instead of guessing project-specific alternatives.
- [SSR is assumed to run from S3] -> Hard requirements state that S3 hosts only static/prerendered artifacts and require a separate adapter-backed compute origin.
- [Existing API Lambdas are mistaken for Astro SSR compute] -> The pack requires distinct runtime responsibility and explicit route ownership; reuse requires a project-specific adapter/runtime design.
- [Community AWS adapter behavior changes] -> The pack does not prescribe an adapter and requires current adapter documentation plus runtime compatibility evidence in each project.
- [Mixed routes are cached incorrectly] -> Active design must classify static and dynamic routes and define cache behavior before implementation.
- [Public Astro output leaks AWS secrets] -> Only non-secret public configuration may enter client bundles; credentials remain in server-side/runtime configuration.
- [CRM draft or private content reaches public pages] -> Build contracts filter explicitly publishable states and tests cover exclusion before static output is accepted.
- [CRM is unavailable during build] -> Each project chooses fail-closed or an approved last-known-good source; partial output is prohibited.
- [CRM content changes but S3 remains stale] -> Project artifacts define the build trigger, freshness target, publication ownership, and failure alerting.
- [SEO metadata conflicts across routes] -> Route classification and rendered-output checks cover canonicals, indexing directives, sitemap membership, status codes, and locale relationships.
- [Lighthouse is treated as ranking proof] -> Reports are supporting local evidence only; no indexing or ranking claim is permitted.
- [`llms.txt` is treated as a universal standard or permission file] -> Documentation labels it an evolving discovery convention and keeps robots policy authoritative for allowed crawling.
- [AI-facing text diverges from visible content] -> Discovery artifacts derive from the published route inventory and must preserve factual and canonical parity.
- [Draft CRM content leaks through AI discovery] -> Generation filters the same publishable states used by public SSG and fails validation on private or unknown URLs.
- [An agent ignores published discovery controls] -> The pack makes no provider-behavior guarantee and requires no sensitive content to rely on crawler directives for protection.
- [OpenAPI client silently drifts from the backend] -> Pinned deterministic generation plus `api:check`, TypeScript compilation, and affected tests fail before completion.
- [Generated transport models leak into every component] -> Handwritten adapters map generated operations and models into stable component-facing contracts where reuse requires decoupling.
- [Analytics fires before valid consent] -> Default-denied state and browser network/storage tests cover initial load, acceptance, rejection, and revocation.
- [Cookie policy diverges from actual tracking] -> Project-owned inventory and automated/manual network inspection are updated with every analytics change.
- [Cookie banner itself blocks disabled users] -> It follows the same keyboard, focus, semantics, contrast, zoom, and screen-reader requirements as the rest of the site.
- [Automated accessibility checks create false confidence] -> Manual keyboard, screen-reader, zoom/reflow, media, and complex-widget evidence remains mandatory.
- [A legal standard is declared applicable or satisfied without review] -> Project artifacts record applicability and qualified ownership; pack evidence is technical and makes no legal-conformity claim.
- [Playwright is absent] -> Browser checks remain conditional and are not part of baseline verification commands.
- [Static generation succeeds but produces incorrect pages] -> Behavior tests and optional browser evidence supplement `astro build`; build success alone is not treated as UI correctness.

## Migration Plan

1. Add `astro` to the TDD contract's required pack list and record the expected RED failure while the pack is absent.
2. Add `packs/astro/pack.yaml`, `packs/astro/README.md`, `packs/astro/templates/public/llms.txt`, and `packs/astro/templates/accessibility-checklist.md` with mandatory SEO, AI-agent discovery, OpenAPI client, analytics-consent, accessibility, CRM-backed SSG, static S3, mixed, server, and Lambda API boundaries.
3. Update the stack-capability specification and repository documentation that enumerate packs.
4. Run runtime-definition validation, TDD-contract validation, strict OpenSpec validation, and resolver checks against complete and incomplete Astro project evidence.
5. After release, a consumer such as `ames-web` may optionally persist `default_pack: astro` in its own `.opencode-project.yaml`; this repository change will not modify that consumer-owned file.

Rollback removes the Astro pack and catalog references together. Consumers then return to explicit `generic` confirmation; no application or production migration is required.

## Open Questions

None.

## Reference Basis

- Astro configuration reference (`output` supports `static` and `server`, with `static` as default): https://docs.astro.build/en/reference/configuration-reference/#output
- Astro on-demand rendering guide (adapters and per-route prerender controls): https://docs.astro.build/en/guides/on-demand-rendering/
- Astro AWS deployment guide (static S3 hosting and separate adapter-based on-demand options): https://docs.astro.build/en/guides/deploy/aws/
- llms.txt v2 proposal (agent-oriented discovery format that complements robots and sitemaps): https://llmstxt.org/
- WCAG 2.2 W3C Recommendation: https://www.w3.org/TR/WCAG22/
- EN 301 549 v3.2.1 accessibility requirements for ICT products and services: https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf
- Real Decreto 193/2023 consolidated reference: https://www.boe.es/buscar/act.php?id=BOE-A-2023-7417
- Ley 11/2023 consolidated reference: https://www.boe.es/buscar/act.php?id=BOE-A-2023-11022
- AEPD cookie guidance: https://www.aepd.es/guias/guia-cookies.pdf
- Google consent mode implementation guidance: https://developers.google.com/tag-platform/security/guides/consent
