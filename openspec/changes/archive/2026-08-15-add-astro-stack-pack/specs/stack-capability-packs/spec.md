## MODIFIED Requirements

### Requirement: Multi-stack pack catalog
The platform SHALL provide first-class pack definitions for `go-aws`, `java-onprem`, `angular`, `astro`, and `generic` contexts.

#### Scenario: Project selects matching pack
- **WHEN** a project configuration declares its technology context
- **THEN** the corresponding pack is selected and its constraints are applied during planning and implementation

#### Scenario: Astro project uses the first-class catalog entry
- **WHEN** an Astro project satisfies every required `astro` detection marker and no other non-generic pack fully matches
- **THEN** the platform selects `astro` without requiring confirmation of `generic`

## ADDED Requirements

### Requirement: Astro pack deterministic detection
The platform SHALL define `packs/astro/pack.yaml` with exactly these required detection markers: `path_exists` for `astro.config.mjs` and `file_contains` for the literal `"astro"` in `package.json`. The resolver SHALL continue to require every marker before inferring the pack.

#### Scenario: Astro project satisfies all markers
- **WHEN** `astro.config.mjs` exists and `package.json` contains the literal `"astro"`
- **THEN** the `astro` pack is a detection match
- **AND** the resolver reports both matching markers as evidence

#### Scenario: Astro configuration marker is absent
- **WHEN** `package.json` contains the literal `"astro"` but `astro.config.mjs` does not exist
- **THEN** the `astro` pack is not a detection match
- **AND** the resolver reports `astro.config.mjs` as missing evidence

#### Scenario: Astro dependency marker is absent
- **WHEN** `astro.config.mjs` exists but `package.json` does not contain the literal `"astro"`
- **THEN** the `astro` pack is not a detection match
- **AND** the resolver reports the package literal as missing evidence

### Requirement: Astro rendering profiles and TypeScript guidance
The `astro` pack SHALL identify TypeScript, HTML, and CSS as its languages and Astro as its framework. It SHALL use static output as the default profile, SHALL require public indexable routes to remain prerendered unless an observable route requirement makes SSG insufficient, and SHALL also support explicitly designed mixed prerendered/on-demand and fully server-rendered profiles. Before on-demand rendering is introduced, active OpenSpec artifacts SHALL define the adapter, compute runtime, route ownership, caching behavior, security controls, SEO behavior, and profile-specific verification. Every profile SHALL prevent unnecessary client-side JavaScript by preferring Astro components unless an interactive client island is required.

#### Scenario: Static Astro page is changed
- **WHEN** an implementation task changes a non-interactive Astro page under the `astro` pack
- **THEN** the implementation keeps the page statically generated
- **AND** it does not add a client hydration directive without an observable interaction requirement

#### Scenario: Mixed rendering is proposed
- **WHEN** selected routes need on-demand rendering while other routes remain prerendered
- **THEN** the design uses Astro's supported per-route prerender controls with an adapter-backed runtime
- **AND** records which routes are static, which routes execute on demand, how requests reach each origin, and how indexable HTML and status behavior remain crawlable

#### Scenario: Server output is proposed
- **WHEN** most or all routes need on-demand rendering using Astro `output: "server"`
- **THEN** the workflow requires an adapter-backed compute runtime and explicit prerender decisions for any static routes
- **AND** does not classify the server entry as an S3-hostable artifact

### Requirement: Astro public SEO-first contract
The `astro` pack SHALL be restricted to public websites with explicit technical SEO and AI-agent discovery intent. Its context SHALL identify public visibility, mandatory SEO, and mandatory AI discoverability, and its public-web skill overlay SHALL include `seo-expert`. Before implementation, every route SHALL be classified as indexable or non-indexable. Indexable routes SHALL render meaningful HTML without client execution and SHALL define a page-specific title, meta description, absolute canonical URL, indexing directive, sitemap membership, and expected success or not-found status behavior. Non-indexable routes SHALL keep HTML directives, HTTP headers where applicable, robots policy, and sitemap exclusion consistent.

#### Scenario: Indexable public route is generated
- **WHEN** an Astro route is classified as indexable
- **THEN** its rendered HTML contains page-specific title, description, absolute canonical, and indexable content without requiring client JavaScript
- **AND** its canonical URL is eligible for the generated sitemap

#### Scenario: Non-indexable route is generated
- **WHEN** an Astro route is classified as non-indexable
- **THEN** its rendered output carries the project-defined noindex behavior
- **AND** the route is excluded from the sitemap and is not contradicted by robots or response-header directives

#### Scenario: Localized public routes exist
- **WHEN** a project declares more than one locale for equivalent indexable content
- **THEN** canonical and hreflang URLs are absolute, valid, and mutually consistent
- **AND** the project defines the fallback locale and locale-specific sitemap behavior

#### Scenario: Structured data is emitted
- **WHEN** a route emits schema.org or other structured data
- **THEN** every claim and entity relationship is supported by visible page content and project-owned facts
- **AND** validation records the rendered structured-data result without claiming rich-result eligibility

#### Scenario: Public SEO evidence is collected
- **WHEN** an Astro change reaches verification
- **THEN** the workflow builds the project, starts the defined local production preview, records the defined Lighthouse command output, and inspects rendered metadata, canonicals, robots directives, sitemap entries, redirects, status codes, and applicable structured data
- **AND** it does not claim that local evidence proves indexing, ranking, traffic, or Core Web Vitals field performance

### Requirement: Astro AI-agent discoverability contract
The `astro` pack SHALL require every consumer site to publish `/llms.txt` as a concise machine-readable guide to canonical public information and SHALL provide `packs/astro/templates/public/llms.txt` as a starter. The file SHALL contain one H1 site name, a factual summary, and curated absolute links grouped under H2 sections. It SHALL be generated or validated from the same published route and content inventory as the human-visible site. It SHALL NOT include private, draft, authenticated, personalized, secret-bearing, non-canonical, or otherwise unpublished information. The pack SHALL document llms.txt as an evolving discovery convention that complements, but does not replace, semantic HTML, structured data, sitemaps, feeds where applicable, canonical URLs, or robots policy.

#### Scenario: AI discovery guide is generated
- **WHEN** an Astro production build completes
- **THEN** `/llms.txt` contains the project-owned site name, factual summary, and absolute links to current canonical public resources
- **AND** every linked internal resource is present in the published route inventory

#### Scenario: CRM-backed content is advertised to agents
- **WHEN** `/llms.txt` or another machine-readable surface includes CRM-backed information
- **THEN** that information comes only from content in an allowed publishable state used by the same SSG build
- **AND** draft, private, expired, or unknown publication states are excluded

#### Scenario: Public route is removed or becomes non-indexable
- **WHEN** a previously advertised route is removed, redirected, or reclassified as non-indexable
- **THEN** the same build updates `/llms.txt`, sitemaps, and applicable alternates to remove or replace the stale reference
- **AND** validation fails if a non-canonical or unpublished URL remains advertised

#### Scenario: Markdown alternate is provided
- **WHEN** a project publishes a Markdown alternate for an agent-relevant page
- **THEN** the canonical HTML advertises it with `rel="alternate"` and `type="text/markdown"`
- **AND** the alternate preserves the visible page's factual meaning, canonical identity, locale, and publication state without adding hidden claims

#### Scenario: AI crawler access policy is defined
- **WHEN** a project prepares public crawling controls
- **THEN** active project artifacts distinguish search indexing, AI-assisted retrieval or inference, and model-training policy where user-agent controls permit that distinction
- **AND** `robots.txt` communicates allowed crawling while `/llms.txt` grants no access by itself

#### Scenario: AI discovery surface is requested for protected content
- **WHEN** content requires authentication or is private, personalized, draft, or secret-bearing
- **THEN** that content is absent from `/llms.txt`, Markdown alternates, sitemaps, feeds, structured data, and other public discovery surfaces
- **AND** access control does not depend on crawler compliance

#### Scenario: AI discovery evidence is collected
- **WHEN** an Astro change reaches verification
- **THEN** the workflow fetches `/llms.txt` from the local production preview, validates its required structure and internal links, and compares those links with canonical published routes
- **AND** it does not claim that local evidence proves external AI retrieval, indexing, citation, training inclusion, or answer selection

### Requirement: CRM-backed public content remains SSG
When an Astro public website uses a CRM or backend as a content source, the `astro` pack SHALL keep primary indexable content statically generated. Active project artifacts SHALL define the build-time content contract, publishable-state filter, build authentication, rebuild trigger, freshness target, cache or invalidation ownership, and unavailable-backend policy. The unavailable-backend policy SHALL be either fail-closed or an explicitly approved last-known-good source; the build SHALL NOT silently publish partial content. CRM administration interfaces SHALL remain outside the Astro public-site pack unless separately scoped.

#### Scenario: Published CRM content builds successfully
- **WHEN** the build-time backend returns content in a publishable state under the documented contract
- **THEN** the Astro build renders that content into complete static HTML
- **AND** the generated route receives its required SEO metadata and sitemap classification

#### Scenario: Draft or private CRM content is returned
- **WHEN** the build-time source contains content not in an allowed publishable state
- **THEN** the build excludes that content from public HTML and sitemap output
- **AND** verification detects any attempted publication as a failure

#### Scenario: CRM or backend is unavailable during build
- **WHEN** the build-time source cannot satisfy its contract
- **THEN** the build follows the project-selected fail-closed or approved last-known-good policy
- **AND** it never emits an unapproved partial replacement for an indexable route

#### Scenario: Published CRM content changes
- **WHEN** an operator publishes content that must appear on the public site
- **THEN** the project-owned trigger starts the documented rebuild and publication handoff
- **AND** monitoring evaluates completion against the project-defined freshness target

#### Scenario: Public page needs a runtime backend action
- **WHEN** a statically generated page provides a form, search, account action, or other runtime interaction
- **THEN** that interaction uses a separate documented Lambda API contract
- **AND** primary indexable content and metadata remain available without the runtime API or client-side rendering

### Requirement: Astro AWS hosting and Lambda boundaries
The `astro` pack SHALL define S3 as a host for static and prerendered build artifacts only. It SHALL treat backend API Lambdas and any Astro on-demand rendering runtime as separate execution responsibilities. An Astro SSR or mixed-rendering design targeting Lambda SHALL use a compatible adapter, a dedicated compute entry, and explicit request routing between static and dynamic origins; it SHALL NOT assume that existing API Lambda handlers can execute Astro rendering.

#### Scenario: Static S3 profile is selected
- **WHEN** all Astro routes are prerendered at build time
- **THEN** the build produces static assets suitable for external-operator publication to S3
- **AND** browser calls to backend Lambda APIs use documented public API contracts, environment-provided base URLs, explicit allowed origins, and defined authentication semantics

#### Scenario: Mixed AWS profile is selected
- **WHEN** prerendered assets are hosted from S3 and one or more Astro routes render on demand
- **THEN** the design assigns static requests to the S3 origin and dynamic requests to the adapter-backed compute origin
- **AND** defines the routing and cache behavior that distinguishes those requests

#### Scenario: Existing backend Lambda APIs are reused
- **WHEN** Astro pages or client islands call existing AWS Lambda-backed APIs
- **THEN** the integration preserves the API contract, authentication semantics, and RFC 7807 errors when that backend contract uses them
- **AND** no backend secret is embedded in public Astro output or client-side environment variables

#### Scenario: Astro SSR is hosted on Lambda
- **WHEN** the selected adapter emits an Astro server entry for AWS Lambda
- **THEN** the deployment design assigns that server entry to a distinct runtime responsibility from S3 static assets and existing API handlers
- **AND** active OpenSpec artifacts define runtime compatibility, forwarded-host and origin handling, timeouts, observability, caching, and rollback

### Requirement: OpenAPI-generated TypeScript client
When an Astro project consumes backend operations, the `astro` pack SHALL require a backend-owned OpenAPI document and SHALL define `npm run api:generate` and `npm run api:check` as the stable client-generation interface. Each project SHALL pin its selected generator and configuration, validate a version-identifiable OpenAPI artifact before generation, isolate generated code from handwritten code, and prohibit manual edits to generated files. Runtime base URLs and authentication SHALL be injected through typed configuration and SHALL NOT be embedded in generated source. `api:check` SHALL fail on invalid contracts, nondeterministic output, uncommitted generated drift, TypeScript errors, or affected test failures.

#### Scenario: Valid OpenAPI contract generates a client
- **WHEN** the project receives a valid version-identifiable OpenAPI document from the backend
- **THEN** `npm run api:generate` deterministically generates typed operations, request and response schemas, authentication hooks, and declared error models
- **AND** generated files are isolated, marked as generated, and compile without manual modification

#### Scenario: Backend contract and generated client drift
- **WHEN** the OpenAPI document changes but the checked-in or expected generated client is stale
- **THEN** `npm run api:check` exits unsuccessfully and reports generated drift
- **AND** implementation cannot complete until regeneration, TypeScript checking, and affected tests pass

#### Scenario: OpenAPI document is invalid or incompatible
- **WHEN** validation or generation encounters an invalid schema, unresolved reference, unsupported construct, or incompatible generator change
- **THEN** generation fails without replacing the last valid client with partial output
- **AND** the failure identifies the contract or generator issue for backend/frontend resolution

#### Scenario: OpenAPI breaking change is introduced
- **WHEN** an operation, field, authentication requirement, status response, or error schema changes incompatibly
- **THEN** the Astro project updates its handwritten adapters and affected behavior tests explicitly
- **AND** TypeScript compilation and tests demonstrate that no stale operation shape remains in use

#### Scenario: Reusable component consumes backend data
- **WHEN** an Astro page or reusable component needs data from a backend operation
- **THEN** handwritten application code invokes the generated client and maps transport models into stable component-facing props where decoupling is needed
- **AND** the component does not manually duplicate the OpenAPI request or response type

#### Scenario: OpenAPI contract declares RFC 7807 errors
- **WHEN** the backend operation declares `application/problem+json` responses
- **THEN** the generated client or its handwritten adapter preserves the declared problem fields and status semantics
- **AND** UI error states are tested against typed problem responses

### Requirement: Consent-gated Google Analytics and cookie policy
When Google Analytics is enabled, the `astro` pack SHALL require an accessible consent banner and preferences interface, a concrete project-owned cookie policy, and default-denied optional consent. Under the default basic-consent profile, no Google Analytics tag, analytics or advertising cookie/storage write, or measurement request SHALL occur before the user grants the relevant category. Any advanced or cookieless pre-consent measurement SHALL require an explicit project privacy decision and validation outside the default profile. Analytics events SHALL NOT contain secrets, direct identifiers, sensitive data, form values, or uncontrolled URLs or query parameters.

#### Scenario: Visitor has not made a consent choice
- **WHEN** a visitor opens the site without stored consent
- **THEN** the banner offers accept, reject, and configure actions without preselected optional categories or deceptive visual priority
- **AND** analytics and advertising consent remain denied and no Google Analytics measurement request or optional storage occurs

#### Scenario: Visitor accepts analytics
- **WHEN** the visitor explicitly grants the analytics category
- **THEN** the consent state is persisted with the project-defined policy version and Google consent state is updated before measurement
- **AND** only approved analytics tags and documented event fields may run

#### Scenario: Visitor rejects analytics
- **WHEN** the visitor rejects optional cookies or saves preferences without analytics consent
- **THEN** the site remains fully usable except for functionality that is strictly and transparently dependent on that optional category
- **AND** no Google Analytics measurement request or optional analytics storage occurs

#### Scenario: Visitor revokes prior consent
- **WHEN** the visitor reopens preferences and revokes analytics consent
- **THEN** later measurement is disabled, Google consent state is updated immediately, and project-controlled optional analytics storage is removed where technically possible
- **AND** the interface and cookie policy explain any remaining provider-controlled storage behavior

#### Scenario: Cookie policy is reviewed
- **WHEN** Google Analytics or another storage technology is configured or changed
- **THEN** the cookie inventory and policy identify provider, key, purpose, category, duration, first- or third-party status, applicable recipients or transfers, withdrawal method, owner, and policy date/version
- **AND** browser evidence confirms that actual storage and requests match the documented inventory

#### Scenario: Analytics event is emitted
- **WHEN** application code records a page view, interaction, conversion, performance measurement, or custom event
- **THEN** the event uses the approved project taxonomy and data-minimization rules
- **AND** tests reject direct identifiers, sensitive/form data, secrets, and uncontrolled URL or query values

#### Scenario: Consent interface is used accessibly
- **WHEN** a user operates the banner or preferences with keyboard or assistive technology
- **THEN** focus order, visible focus, labels, grouping, status, contrast, zoom/reflow, acceptance, rejection, configuration, and revocation remain perceivable and operable
- **AND** consent is not inferred from silence, scrolling, or inaccessible interaction

### Requirement: Continuous WCAG 2.2 AA accessibility
The `astro` pack SHALL set WCAG 2.2 Level AA as the accessibility target and SHALL reference EN 301 549. Each consumer SHALL record qualified ownership and an applicability assessment for Real Decreto 193/2023 and Ley 11/2023 when the service may enter their scope. The pack SHALL prefer semantic HTML and native controls, use ARIA only where native semantics are insufficient, and require accessibility verification after every affected change or feature rather than only at launch. Technical evidence SHALL NOT be presented as a legal-conformity claim.

#### Scenario: Semantic implementation is available
- **WHEN** native HTML can provide the required structure or behavior
- **THEN** the implementation uses semantic elements and native controls before custom roles or scripted widgets
- **AND** any ARIA added has a documented necessity and valid name, role, value, state, and relationship behavior

#### Scenario: Keyboard and assistive technology operate the site
- **WHEN** a user navigates or completes a process without a pointer
- **THEN** all functionality is keyboard operable with logical order, visible and unobscured focus, no trap, and correct focus management
- **AND** names, roles, values, labels, instructions, errors, and dynamic status messages are exposed to assistive technology

#### Scenario: Visual presentation is reviewed
- **WHEN** colors, typography, spacing, controls, responsive layout, animation, or overlays change
- **THEN** applicable WCAG 2.2 AA contrast, color-independence, reflow, orientation, text resize/spacing, target-size, focus, and reduced-motion requirements are verified
- **AND** text remains usable at 200 percent resize and content reflows at 320 CSS pixels, equivalent to 400 percent zoom on a 1280-pixel-wide viewport, without loss or two-dimensional scrolling except where WCAG permits it

#### Scenario: Accessible form validation is used
- **WHEN** a form is displayed or validation fails
- **THEN** every control has a programmatic label and necessary instructions, required state, error identification, and correction guidance
- **AND** errors are associated with controls, announced appropriately, and not communicated by color alone

#### Scenario: Multimedia is published
- **WHEN** audio, video, animation, or time-based media conveys information
- **THEN** the project supplies the captions, transcripts, audio descriptions, controls, and alternatives required by applicable WCAG 2.2 AA criteria
- **AND** autoplay or motion does not interfere with access

#### Scenario: Complex or dynamic UI is changed
- **WHEN** a gallery, filter, modal, consent dialog, menu, carousel, live region, or dynamically updated result is added or changed
- **THEN** reading order, keyboard interaction, focus lifecycle, escape behavior, names, roles, states, and announcements are tested
- **AND** equivalent information and operations remain available to assistive technologies

#### Scenario: Map or plan conveys information or enables a task
- **WHEN** a public page contains a map, floor plan, site plan, or other spatial interface
- **THEN** an equivalent accessible text, list, table, directions, search, or assisted-contact alternative conveys the relevant information or completes the task
- **AND** the visual interface itself has appropriate keyboard, label, contrast, and zoom behavior where it remains interactive

#### Scenario: Accessibility evidence is collected after change
- **WHEN** a behavior, component, visual design, content type, or complete user flow changes
- **THEN** `npm run audit:a11y` and relevant automated/browser checks pass for affected pages
- **AND** manual keyboard testing is recorded
- **AND** complete or assistive-technology-sensitive flows record testing with at least one project-declared screen-reader/browser combination plus relevant zoom and reflow checks

#### Scenario: Automated accessibility check passes
- **WHEN** automated tools report no detected violations
- **THEN** the result is treated as supporting evidence only
- **AND** WCAG 2.2 AA or legal conformity is not claimed without the required manual evaluation and scope assessment

### Requirement: Astro verification and TDD commands
The `astro` pack SHALL define `npm test` as its test command, `npm run build` as its build command, `npm run check` as its lint/static-analysis command, `npm run api:generate` as its OpenAPI client-generation command, `npm run api:check` as its API-drift command, `npm run audit:lighthouse` as its SEO audit command, and `npm run audit:a11y` as its automated accessibility command. It SHALL define `npm run preview -- --host 0.0.0.0 --port 4321` as the local production-preview command, `AUDIT_URL=http://127.0.0.1:4321 npm run audit:lighthouse` as the local Lighthouse command, `curl --fail --silent --show-error http://127.0.0.1:4321/llms.txt` as the AI discovery fetch command, `npx playwright test tests/privacy --config=playwright.config.ts` as the consent/privacy browser command, and `npx playwright test tests/accessibility --config=playwright.config.ts` as the accessibility browser command. Its RED and GREEN commands SHALL run `npm test`, and its REFACTOR command SHALL run `npm test && npm run check && npm run build`.

#### Scenario: Astro behavior change follows TDD
- **WHEN** an agent implements a behavior change under the `astro` pack
- **THEN** it records a failing `npm test` result before implementation
- **AND** records a passing `npm test` result after the minimal implementation
- **AND** runs `npm test && npm run check && npm run build` after refactoring

#### Scenario: Astro change is ready for verification
- **WHEN** implementation tasks under the `astro` pack are complete
- **THEN** `npm test`, `npm run api:check` when a backend contract is consumed, `npm run check`, `npm run build`, and `npm run audit:a11y` complete successfully
- **AND** `npm run audit:lighthouse` produces a reviewable report
- **AND** the AI discovery fetch command returns the generated `/llms.txt` successfully
- **AND** applicable privacy and accessibility browser commands pass with required manual accessibility evidence recorded
- **AND** the produced artifacts match the selected static, mixed, or server-rendered profile without executing a deployment action

### Requirement: Astro specialization boundaries
Selection of the `astro` pack SHALL count as explicit SEO intent because the pack is restricted to public SEO-dependent websites, so Astro work SHALL include `seo-expert`. For Astro frontend/UI work, the pack SHALL additionally include `web-ui-ux` and exclude `backend-design`. When a request explicitly spans the Astro frontend and a Go/AWS Lambda backend, the workflow SHALL compose `seo-expert` and `web-ui-ux` with `backend-design`; a separately rooted backend project SHALL resolve its own stack pack. Browser automation SHALL compose with `playwright-cli` only when browser evidence, interactive inspection, snapshots, or traces are required.

#### Scenario: Astro public-web work is routed
- **WHEN** any request is handled under the `astro` pack
- **THEN** the workflow applies `seo-expert` as an explicit pack invariant
- **AND** keeps framework-specific rendering guidance in the pack

#### Scenario: Astro frontend-only work is routed
- **WHEN** a request changes Astro layout, styling, responsive behavior, accessibility, or component composition without backend scope
- **THEN** the workflow applies `seo-expert` and `web-ui-ux`
- **AND** does not apply `backend-design`

#### Scenario: Astro browser evidence is required
- **WHEN** an Astro UI task requires executable browser validation
- **THEN** the workflow composes `playwright-cli` with `web-ui-ux`
- **AND** keeps Astro framework constraints in the active pack

#### Scenario: Astro and Go Lambda work share one request
- **WHEN** a request explicitly changes both the Astro frontend and a Go/AWS Lambda backend
- **THEN** the workflow composes `seo-expert` and `web-ui-ux` with `backend-design`
- **AND** preserves frontend and Handler to UseCase to Storage boundaries independently

### Requirement: Astro local safety and security controls
The `astro` pack SHALL set `local_only: true`, assign deployment ownership to an external operator, prohibit deploy, release, and production-change actions, and document local secret, dependency, license, and vulnerability checks.

#### Scenario: Non-local Astro action is requested
- **WHEN** an autonomous workflow reaches deployment, release, or a production change
- **THEN** it stops before executing that action
- **AND** reports the required external-operator handoff

#### Scenario: Astro pack security readiness is reviewed
- **WHEN** the `astro` pack is validated for contribution readiness
- **THEN** its documentation identifies checks for secrets, dependency health, licenses, and High or Critical vulnerabilities
- **AND** unresolved High or Critical findings block promotion
