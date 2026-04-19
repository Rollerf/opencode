# angular Pack

This pack is for local development in Angular projects.

## Skill Overlay

- For Angular frontend/UI work, load `$web-ui-ux` alongside the Angular pack.
- Do not use `$backend-design` for Angular frontend-only work.
- Only include `$backend-design` when the request explicitly combines Angular UI work with backend scope.

## UI/UX Iteration Loop

1. Start the app locally with `npm start -- --host 0.0.0.0 --port 4200`.
2. Run browser validation with `npx playwright test --config=playwright.config.ts`.
3. For visual work, use `npx playwright test tests/ui --config=playwright.config.ts` to capture desktop/mobile evidence.
4. Iterate UI changes and rerun Playwright checks before closing the task.
5. If interactive review is available locally, run `npx playwright test tests/ui --config=playwright.config.ts --headed`.

Before major UI edits, summarize the current visual language (components, spacing, typography, density, states) and identify what will be reused.

If Playwright is not installed in the target project, add it first and create a minimal `playwright.config.ts` plus UI tests under `tests/ui`.

### Bootstrap Templates

Use these starter templates from this repository:

- `packs/angular/templates/playwright.config.ts`
- `packs/angular/templates/tests/ui/home.spec.ts`

Suggested setup in the target Angular project:

```bash
npm i -D @playwright/test
npx playwright install chromium
cp /path/to/opencode/packs/angular/templates/playwright.config.ts ./playwright.config.ts
mkdir -p tests/ui
cp /path/to/opencode/packs/angular/templates/tests/ui/home.spec.ts ./tests/ui/home.spec.ts
```

## TDD Flow

1. RED: add failing unit/component tests and run `npm test -- --watch=false --browsers=ChromeHeadless`.
2. GREEN: apply minimal code changes and rerun the same test command.
3. REFACTOR: cleanup and run `npm test -- --watch=false`, `npm run lint`, and `npm run build`.

For UI-heavy work, use Playwright evidence as an additional verification layer after GREEN and REFACTOR.

## Baseline Checks

- `npm test -- --watch=false`
- `npm run lint`
- `npm run build`
