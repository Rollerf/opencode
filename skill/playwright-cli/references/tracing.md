# Tracing

Capture detailed execution traces for debugging and analysis. Traces include DOM snapshots, screenshots, network activity, and console logs.

## Basic Usage

```bash
playwright-cli tracing-start
playwright-cli open https://example.com
playwright-cli click e1
playwright-cli fill e2 "test"
playwright-cli tracing-stop
```

## What Traces Capture

| Category | Details |
|----------|---------|
| **Actions** | Clicks, fills, hovers, keyboard input, navigations |
| **DOM** | Full DOM snapshot before/after each action |
| **Screenshots** | Visual state at each step |
| **Network** | All requests, responses, headers, bodies, timing |
| **Console** | All console.log, warn, error messages |
| **Timing** | Precise timing for each operation |

## Use Cases

### Debugging Failed Actions

```bash
playwright-cli tracing-start
playwright-cli open https://app.example.com
playwright-cli click e5
playwright-cli tracing-stop
```

### Analyzing Performance

```bash
playwright-cli tracing-start
playwright-cli open https://slow-site.com
playwright-cli tracing-stop
```

### Capturing Evidence

```bash
playwright-cli tracing-start
playwright-cli open https://app.example.com/checkout
playwright-cli fill e1 "4111111111111111"
playwright-cli fill e2 "12/25"
playwright-cli fill e3 "123"
playwright-cli click e4
playwright-cli tracing-stop
```

## Best Practices

```bash
playwright-cli tracing-start
playwright-cli open https://example.com
playwright-cli tracing-stop
```

Traces add overhead and may consume disk space.
