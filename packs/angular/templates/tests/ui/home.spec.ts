import { expect, test } from "@playwright/test";

test.describe("home page", () => {
  test("loads and shows main content", async ({ page }) => {
    await page.goto("/");

    await expect(page.locator("main")).toBeVisible();
    await expect(page).toHaveTitle(/.+/);
  });

  test("desktop and mobile screenshots", async ({ page }, testInfo) => {
    await page.goto("/");
    await expect(page.locator("body")).toBeVisible();

    await expect(page).toHaveScreenshot(`${testInfo.project.name}-home.png`, {
      fullPage: true,
    });
  });
});
