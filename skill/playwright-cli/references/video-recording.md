# Video Recording

Capture browser automation sessions as video for debugging, documentation, or verification. Produces WebM (VP8/VP9 codec).

## Basic Recording

```bash
playwright-cli open
playwright-cli video-start demo.webm
playwright-cli video-chapter "Getting Started" --description="Opening the homepage" --duration=2000
playwright-cli goto https://example.com
playwright-cli snapshot
playwright-cli click e1
playwright-cli video-chapter "Filling Form" --description="Entering test data" --duration=2000
playwright-cli fill e2 "test input"
playwright-cli video-stop
```

## Best Practices

### Use Descriptive Filenames

```bash
playwright-cli video-start recordings/login-flow-2024-01-15.webm
playwright-cli video-start recordings/checkout-test-run-42.webm
```

### Record Entire Hero Scripts

Prefer a `run-code` script when you want polished demo-style recordings with pauses and overlays.

```js
async page => {
  await page.screencast.start({ path: 'video.webm', size: { width: 1280, height: 800 } });
  await page.goto('https://demo.playwright.dev/todomvc');
  await page.screencast.showChapter('Adding Todo Items', {
    description: 'We will add several items to the todo list.',
    duration: 2000,
  });
  await page.getByRole('textbox', { name: 'What needs to be done?' }).pressSequentially('Walk the dog', { delay: 60 });
  await page.getByRole('textbox', { name: 'What needs to be done?' }).press('Enter');
  await page.waitForTimeout(1000);
  await page.screencast.stop();
}
```

## Tracing vs Video

| Feature | Video | Tracing |
|---------|-------|---------|
| Output | WebM file | Trace file |
| Shows | Visual recording | DOM snapshots, network, console, actions |
| Use case | Demos, documentation | Debugging, analysis |

## Limitations

- Recording adds slight overhead to automation
- Large recordings can consume significant disk space
