# Test Generation

Generate Playwright test code automatically as you interact with the browser.

## How It Works

Every action you perform with `playwright-cli` generates corresponding Playwright TypeScript code.
This code appears in the output and can be copied directly into your test files.

## Example Workflow

```bash
playwright-cli open https://example.com/login
playwright-cli snapshot
playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3
```

## Building a Test File

```typescript
import { test, expect } from '@playwright/test';

test('login flow', async ({ page }) => {
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
  await page.getByRole('textbox', { name: 'Password' }).fill('password123');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await expect(page).toHaveURL(/.*dashboard/);
});
```

## Best Practices

### 1. Use Semantic Locators

```typescript
await page.getByRole('button', { name: 'Submit' }).click();
```

### 2. Explore Before Recording

```bash
playwright-cli open https://example.com
playwright-cli snapshot
playwright-cli click e5
```

### 3. Add Assertions Manually

Generated code captures actions but not assertions. Add expectations manually, for example with:

- `toBeVisible()`
- `toHaveText(text)`
- `toHaveValue(value) / toBeEmpty()`
- `toBeChecked() / toBeUnchecked()`
- `toMatchAriaSnapshot(snapshot)`

Helpful commands:

```bash
playwright-cli --raw generate-locator e5
playwright-cli --raw eval "el => el.textContent" e5
playwright-cli --raw eval "el => el.value" e5
playwright-cli --raw snapshot
playwright-cli --raw snapshot e5
```
