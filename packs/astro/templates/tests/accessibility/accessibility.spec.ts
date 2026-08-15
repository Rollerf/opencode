import { expect, test } from '@playwright/test';

test('page exposes basic document semantics', async ({ page }) => {
  await page.goto('/');

  await expect(page).toHaveTitle(/\S+/);
  await expect(page.locator('html')).toHaveAttribute('lang', /\S+/);
  await expect(page.getByRole('main')).toHaveCount(1);
  await expect(page.getByRole('heading', { level: 1 })).toHaveCount(1);
});

test('first keyboard target receives visible focus', async ({ page }) => {
  await page.goto('/');
  await page.keyboard.press('Tab');

  const focused = page.locator(':focus');
  await expect(focused).toBeVisible();
  const hasVisibleIndicator = await focused.evaluate((element) => {
    const style = getComputedStyle(element);
    return (
      (style.outlineStyle !== 'none' && Number.parseFloat(style.outlineWidth) > 0) ||
      style.boxShadow !== 'none'
    );
  });
  expect(hasVisibleIndicator).toBe(true);
});

test('content reflows at 320 CSS pixels', async ({ page }) => {
  await page.setViewportSize({ width: 320, height: 800 });
  await page.goto('/');

  const dimensions = await page.evaluate(() => ({
    clientWidth: document.documentElement.clientWidth,
    scrollWidth: document.documentElement.scrollWidth,
  }));
  expect(dimensions.scrollWidth).toBeLessThanOrEqual(dimensions.clientWidth + 1);
});

test('dialogs expose accessible names when present', async ({ page }) => {
  await page.goto('/');
  const dialogs = page.getByRole('dialog');

  for (let index = 0; index < (await dialogs.count()); index += 1) {
    const dialog = dialogs.nth(index);
    await expect(dialog).toHaveAccessibleName(/\S+/);
  }
});
