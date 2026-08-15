import { expect, test, type Page } from '@playwright/test';

const analyticsHosts = ['googletagmanager.com', 'google-analytics.com'];
const analyticsCookiePrefixes = ['_ga', '_gid', '_gat'];

function collectAnalyticsRequests(page: Page): string[] {
  const requests: string[] = [];
  page.on('request', (request) => {
    if (analyticsHosts.some((host) => request.url().includes(host))) requests.push(request.url());
  });
  return requests;
}

async function expectNoAnalyticsCookies(page: Page): Promise<void> {
  const cookies = await page.context().cookies();
  expect(cookies.filter((cookie) => analyticsCookiePrefixes.some((prefix) => cookie.name.startsWith(prefix)))).toEqual([]);
}

test.beforeEach(async ({ context }) => {
  await context.clearCookies();
});

test('default-denied state sends no analytics before a choice', async ({ page }) => {
  const requests = collectAnalyticsRequests(page);
  await page.goto('/');

  await expect(page.locator('[data-consent-banner]')).toBeVisible();
  await expect(page.getByRole('button', { name: 'Accept all' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'Reject all' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'Configure' })).toBeVisible();
  await expectNoAnalyticsCookies(page);
  expect(requests).toEqual([]);
});

test('Accept all enables only documented analytics behavior', async ({ page }) => {
  const requests = collectAnalyticsRequests(page);
  await page.goto('/');
  await page.getByRole('button', { name: 'Accept all' }).click();

  await expect(page.locator('[data-consent-banner]')).toBeHidden();
  await expect.poll(() => requests.length).toBeGreaterThan(0);
});

test('Reject all persists denial without analytics traffic or storage', async ({ page }) => {
  const requests = collectAnalyticsRequests(page);
  await page.goto('/');
  await page.getByRole('button', { name: 'Reject all' }).click();
  await page.reload();

  await expect(page.locator('[data-consent-banner]')).toBeHidden();
  await expectNoAnalyticsCookies(page);
  expect(requests).toEqual([]);
});

test('Configure saves granular analytics denial', async ({ page }) => {
  const requests = collectAnalyticsRequests(page);
  await page.goto('/');
  await page.getByRole('button', { name: 'Configure' }).click();
  await page.getByRole('checkbox', { name: /analytics/i }).uncheck();
  await page.getByRole('button', { name: /save preferences/i }).click();

  await expectNoAnalyticsCookies(page);
  expect(requests).toEqual([]);
});

test('Revoke consent disables later measurement', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Accept all' }).click();
  await page.getByRole('button', { name: /cookie preferences/i }).click();
  await page.getByRole('button', { name: 'Revoke consent' }).click();

  const requestsAfterRevocation = collectAnalyticsRequests(page);
  await page.reload();
  await expectNoAnalyticsCookies(page);
  expect(requestsAfterRevocation).toEqual([]);
});
