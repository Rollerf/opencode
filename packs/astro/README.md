# astro Pack

This pack governs local development for public Astro websites. These sites are SEO-first, AI-discoverable, TypeScript-based, accessibility-targeted, and commonly published as static files to S3 while consuming AWS Lambda APIs.

## Required Project Scripts

Consumer projects provide these stable script interfaces:

```json
{
  "scripts": {
    "test": "vitest run",
    "check": "astro check",
    "build": "astro build",
    "preview": "astro preview",
    "api:generate": "<pinned OpenAPI generator command>",
    "api:check": "<deterministic OpenAPI drift command>",
    "audit:lighthouse": "<local Lighthouse command>",
    "audit:a11y": "<local automated accessibility command>"
  }
}
```

The project chooses the OpenAPI generator, analytics property, consent platform, and automated accessibility tool. Pin each selected tool and commit its configuration.

## Rendering Profiles and AWS Boundaries

### Static S3 — default

- Keep public indexable pages statically generated.
- Publish only generated static files to S3 through an external operator.
- Call backend Lambda APIs through documented public contracts and environment-provided base URLs.
- Do not put secrets in public Astro environment variables.

### Mixed rendering

Use Astro's current per-route prerender controls with a compatible adapter. Record which routes are static and which run on demand. Define request routing and caching between the S3 origin and compute origin.

### Server rendering

Use `output: "server"` only when most routes need on-demand rendering. A compatible adapter and compute runtime are mandatory. An Astro server entry is not an S3-hostable artifact.

Existing API Lambda handlers are not automatically Astro rendering functions. Treat static assets, Astro SSR compute, and backend Lambda operations as separate responsibilities.

## CRM-Backed SSG

Public CRM content remains SSG. Active project artifacts define:

- build-time content contract and authentication;
- explicitly allowed published content states;
- draft, private, expired, and unknown-state exclusion;
- rebuild trigger and freshness target;
- cache or invalidation ownership;
- failure alerting and publication ownership;
- fail-closed or explicitly approved last-known-good behavior.

Never silently build partial SEO pages when the content source fails. Runtime forms, search, account actions, or inventory checks use separate Lambda API contracts and do not make primary indexable content depend on client rendering.

## OpenAPI TypeScript Client

The backend owns the OpenAPI contract for available operations. The Astro project consumes a version-identifiable local artifact or an integrity-controlled fetch result.

Required flow:

1. Validate OpenAPI before generation.
2. Run `npm run api:generate` with a pinned generator and versioned configuration.
3. Keep generated code in an isolated directory with generated-file warnings.
4. Never edit generated code manually.
5. Inject API base URLs and authentication through typed runtime/build configuration.
6. Use handwritten adapters to map transport models into reusable component props when component reuse requires decoupling.
7. Run `npm run api:check` to regenerate deterministically, reject drift, type-check, and run affected tests.
8. Handle breaking operation, field, auth, status, and error changes explicitly.

Preserve RFC 7807 `application/problem+json` fields and status semantics when the OpenAPI contract declares them. Generated source must not contain credentials, account-specific values, or environment-specific URLs.

## Mandatory Technical SEO

Selection of this pack is explicit SEO intent and includes `seo-expert`.

Classify every route as indexable or non-indexable. For indexable routes verify:

- complete meaningful HTML without client execution;
- page-specific title and description;
- absolute canonical URL based on the project-owned production domain;
- consistent robots directives and sitemap inclusion;
- deliberate redirects and real success/not-found status behavior;
- valid hreflang relationships when multiple locales exist;
- structured data supported by visible content and project-owned facts;
- semantic heading and internal-link structure.

Non-indexable routes stay out of the sitemap and use consistent HTML/header/robots behavior. Local checks cannot prove indexing, ranking, traffic, rich-result eligibility, or field Core Web Vitals.

## AI-Agent Discovery

Publish `/llms.txt` from `public/llms.txt` or generate it during the same build as the site. Use `packs/astro/templates/public/llms.txt` as a starter.

The file is an evolving discovery convention. It complements semantic HTML, canonicals, structured data, sitemaps, feeds, and robots policy. It does not grant crawler access and is not a ranking or model-training standard.

Rules:

- Include only factual summaries and absolute links to current canonical published content.
- Generate or validate it against the same route/content inventory as the human site.
- Remove stale, redirected, non-indexable, draft, private, authenticated, personalized, or secret-bearing references.
- Keep machine-readable content factually equivalent to visible public content; no cloaking.
- Define separate project policy for search indexing, AI retrieval/inference, and model training where user-agent controls allow it.
- Treat `robots.txt` as the crawler-policy surface; `llms.txt` only describes content.
- Make no guarantee of external AI discovery, retrieval, citation, training inclusion, or answer selection.

Optional Markdown page variants must preserve factual meaning, canonical identity, locale, and publication state. Advertise them from canonical HTML with `rel="alternate"` and `type="text/markdown"`.

## Google Analytics, Consent, and Cookies

Google Analytics is expected but conditional. Default profile is default-denied basic consent:

- Do not load the Analytics tag, write optional storage, or send measurement requests before relevant consent.
- Set analytics and advertising consent states to denied before any measurement command.
- Advanced or cookieless pre-consent measurement requires an explicit project privacy decision; it is not the pack default.
- Accept, reject, and configure actions must have equivalent accessibility and no deceptive emphasis.
- Do not preselect optional categories or infer consent from silence or scrolling.
- Let users reopen preferences and revoke consent as easily as granting it.
- Remove project-controlled optional storage where technically possible after revocation and explain remaining provider behavior.

Maintain a concrete cookie inventory and policy using `packs/astro/templates/cookie-policy-checklist.md`. Record provider, key, purpose, category, duration, first/third-party status, recipients or transfers where applicable, withdrawal method, owner, and policy version.

Apply data minimization to analytics events. Never send secrets, direct identifiers, sensitive data, form values, or uncontrolled URLs/query parameters. Browser tests inspect network and storage before consent, after acceptance, after rejection, and after revocation.

Consent controls and cookie policy content must satisfy the same accessibility requirements as the rest of the site. Technical controls do not replace qualified privacy/legal review.

## Continuous Accessibility

Target WCAG 2.2 Level AA. Use EN 301 549 as the European ICT accessibility reference. Each project records qualified ownership and whether Real Decreto 193/2023 and Ley 11/2023 apply. Pack checks provide technical evidence, not a legal conformity claim.

Implementation rules:

- Prefer semantic HTML and native controls.
- Use ARIA only when native semantics are insufficient; validate name, role, value, state, and relationships.
- Preserve complete keyboard operation, logical order, visible/unobscured focus, and no traps.
- Expose labels, instructions, errors, and dynamic status to assistive technology.
- Meet applicable WCAG contrast and color-independent meaning requirements.
- Support 200 percent text resize and reflow at 320 CSS pixels without loss or two-dimensional scrolling except where WCAG permits it.
- Keep forms and validation programmatically labelled, understandable, announced, and correctable.
- Provide applicable captions, transcripts, audio descriptions, controls, and motion alternatives for multimedia.
- Test galleries, filters, modals, consent dialogs, menus, carousels, and dynamic content for focus lifecycle, keyboard behavior, states, and announcements.
- Give maps and plans an equivalent accessible text, list, table, directions, search, or assisted-contact path.

Run automated checks plus manual keyboard review after every affected change. Complete or assistive-technology-sensitive flows also require a project-declared screen reader/browser check and relevant zoom/reflow review. Automated checks alone do not demonstrate WCAG conformity.

Use `packs/astro/templates/accessibility-checklist.md` to record evidence and unresolved barriers.

## Browser Validation

Starter files:

- `packs/astro/templates/playwright.config.ts`
- `packs/astro/templates/tests/privacy/consent.spec.ts`
- `packs/astro/templates/tests/accessibility/accessibility.spec.ts`

Suggested setup:

```bash
npm i -D @playwright/test
npx playwright install chromium
cp /path/to/opencode/packs/astro/templates/playwright.config.ts ./playwright.config.ts
mkdir -p tests/privacy tests/accessibility
cp /path/to/opencode/packs/astro/templates/tests/privacy/consent.spec.ts ./tests/privacy/consent.spec.ts
cp /path/to/opencode/packs/astro/templates/tests/accessibility/accessibility.spec.ts ./tests/accessibility/accessibility.spec.ts
```

Adapt documented `data-consent-*` selectors to the project implementation. Review privacy and accessibility flows in desktop and mobile projects. Use headed mode or `$playwright-cli` for interactive evidence when needed.

## TDD and Verification

1. RED: add a failing behavior or contract test and run `npm test`.
2. GREEN: implement the minimum change and rerun `npm test`.
3. REFACTOR: run `npm test && npm run check && npm run build`.
4. For backend consumers, run `npm run api:check`.
5. Start local production preview with `npm run preview -- --host 0.0.0.0 --port 4321`.
6. Run `AUDIT_URL=http://127.0.0.1:4321 npm run audit:lighthouse`.
7. Run `curl --fail --silent --show-error http://127.0.0.1:4321/llms.txt` and validate its internal links.
8. Run `npm run audit:a11y` plus privacy and accessibility Playwright suites.
9. Record required manual accessibility evidence.

## Security and Compliance

| Control | Command/Check | Expected Result |
|---|---|---|
| Secret scan | Project-approved local secret scanner | No secrets in source, generated clients, tests, or static output |
| Dependency health | `npm audit --audit-level=high` | No unresolved High/Critical findings |
| License review | Project-approved npm license inventory | Only approved licenses |
| OpenAPI drift | `npm run api:check` | Deterministic client matches validated contract |
| Cookie/privacy parity | Privacy Playwright suite plus policy review | Requests/storage match consent and inventory |
| Accessibility | Automated plus manual checklist | No unresolved blocking accessibility regression |
| Prohibited actions | `pack.yaml` review | Deploy, release, production changes, legal approval, and conformity claims remain external |

Do not execute deploy, release, production changes, cookie-policy approval, or accessibility-conformity claims autonomously.

## Traceability

| Contract area | Pack guidance | Executable/template evidence |
|---|---|---|
| Rendering and AWS boundaries | Rendering Profiles and AWS Boundaries | `astro build`, resolver/pack contract |
| Public SEO | Mandatory Technical SEO | Lighthouse command, rendered-output review |
| AI discovery | AI-Agent Discovery | `public/llms.txt`, fetch command, Astro pack contract |
| CRM-backed SSG | CRM-Backed SSG | publishable-state and failure-policy acceptance checks |
| OpenAPI client | OpenAPI TypeScript Client | `api:generate`, `api:check`, typecheck and affected tests |
| Analytics and cookies | Google Analytics, Consent, and Cookies | privacy Playwright template and cookie-policy checklist |
| Accessibility | Continuous Accessibility | `audit:a11y`, accessibility Playwright template, manual checklist |
| Security and local-only operation | Security and Compliance | runtime definition validator and prohibited-actions review |

## Reference Sources

- Astro output configuration (`static` default and `server` mode): https://docs.astro.build/en/reference/configuration-reference/#output
- Astro on-demand and per-route rendering: https://docs.astro.build/en/guides/on-demand-rendering/
- Astro deployment on AWS: https://docs.astro.build/en/guides/deploy/aws/
- llms.txt v2 proposal: https://llmstxt.org/
- WCAG 2.2 W3C Recommendation: https://www.w3.org/TR/WCAG22/
- EN 301 549 v3.2.1: https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf
- Real Decreto 193/2023: https://www.boe.es/buscar/act.php?id=BOE-A-2023-7417
- Ley 11/2023: https://www.boe.es/buscar/act.php?id=BOE-A-2023-11022
- AEPD cookie guidance: https://www.aepd.es/guias/guia-cookies.pdf
- Google consent mode guidance: https://developers.google.com/tag-platform/security/guides/consent

Project-specific legal applicability and conformity require qualified ownership and review. Pack checks, Lighthouse, automated accessibility tools, and browser templates do not prove legal, WCAG, search-ranking, or provider behavior outcomes.
