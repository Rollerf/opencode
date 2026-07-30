---
name: seo-expert
description: Use ONLY when a request explicitly concerns SEO, metadata, structured data, indexing, crawlability, canonical URLs, sitemaps, robots directives, search snippets, or search performance.
---

# SEO Expert

Use this skill as a reusable SEO specialization alongside the selected workflow phase. Do not activate it merely because a task affects a website.

## Scope

Apply relevant guidance for:

- technical SEO and crawlability;
- titles, descriptions, canonical URLs, hreflang, and social metadata;
- robots directives, robots.txt, sitemaps, redirects, and status codes;
- schema.org and other structured data;
- internal linking and discoverability;
- content structure and search-intent alignment;
- Core Web Vitals and performance signals;
- accessibility-adjacent semantics that affect content understanding.

Project documentation remains authoritative for framework, routes, rendering strategy, deployment, content ownership, supported locales, analytics, and validation commands.

## Inspection-first workflow

Before recommending or editing broad SEO behavior:

1. Identify the affected routes, templates, layouts, and content sources.
2. Inspect current metadata generation, canonicalization, indexing controls, redirects, and structured data.
3. Check whether rendering is static, server-side, client-side, or hybrid.
4. Inspect robots.txt, sitemap generation, HTTP status behavior, and relevant deployment configuration.
5. Record assumptions and missing product, locale, keyword, or search-intent context.
6. Prioritize observable defects before optional optimization ideas.

Do not invent page purpose, target queries, business claims, locales, canonical domains, or production URLs.

## Implementation guidance

1. Keep metadata deterministic and specific to the page.
2. Ensure canonical and hreflang URLs are absolute, valid, and mutually consistent where applicable.
3. Keep indexing directives aligned across HTML metadata, HTTP headers, robots.txt, and sitemap inclusion.
4. Emit structured data only when visible page content supports every claim.
5. Preserve valid structured-data identifiers and relationships across page variants.
6. Use redirects deliberately and avoid chains, loops, soft 404s, and accidental indexable duplicates.
7. Treat performance recommendations as measured hypotheses rather than generic rewrites.
8. Preserve accessibility, semantic HTML, and user experience while optimizing search visibility.

## Validation evidence

Use the checks available to the consuming project. Evidence may include:

- affected tests, linting, type checking, and production builds;
- rendered HTML and HTTP-header inspection;
- canonical, hreflang, robots, redirect, and sitemap checks;
- schema.org or rich-result validation notes;
- browser automation, snapshots, traces, or Lighthouse evidence;
- manual external checks clearly identified as operator actions.

Never claim that a local check proves indexing, ranking, traffic, or rich-result eligibility.

## Safety and quality guardrails

- Reject black-hat or deceptive practices, including cloaking, hidden text, keyword stuffing, doorway pages, link schemes, and robots bypass attempts.
- Do not collect credentials or recommend bypassing access controls to crawl restricted systems.
- Do not make ranking guarantees or fabricate search-volume, competitor, or conversion data.
- Do not mass-generate production content without user-provided product facts, editorial constraints, and review ownership.
- Treat destructive URL, canonical, redirect, or indexing changes as behavior changes requiring explicit approval and rollback planning.

## Composition

- Combine with `$web-ui-ux` when SEO work also changes page hierarchy, responsive presentation, semantics, or user experience.
- Combine with `$playwright-cli` when rendered metadata, navigation, redirects, or browser evidence must be inspected.
- Combine with framework or stack guidance for implementation details.
- Do not activate `$backend-design` unless the request explicitly includes the Go/AWS backend.

## Expected output

Report:

1. Prioritized findings or changes.
2. Affected files and routes.
3. Existing behavior and evidence inspected.
4. Rationale and expected observable effect.
5. Validation evidence and commands executed.
6. Assumptions, unavailable checks, blockers, and operator follow-ups.
