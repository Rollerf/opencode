# Browser Session Management

Run multiple isolated browser sessions concurrently with state persistence.

## Named Browser Sessions

Use `-s` flag to isolate browser contexts:

```bash
playwright-cli -s=auth open https://app.example.com/login
playwright-cli -s=public open https://example.com
playwright-cli -s=auth fill e1 "user@example.com"
playwright-cli -s=public snapshot
```

## Browser Session Isolation Properties

Each browser session has independent:
- Cookies
- LocalStorage / SessionStorage
- IndexedDB
- Cache
- Browsing history
- Open tabs

## Browser Session Commands

```bash
playwright-cli list
playwright-cli close
playwright-cli -s=mysession close
playwright-cli close-all
playwright-cli kill-all
playwright-cli delete-data
playwright-cli -s=mysession delete-data
```

## Environment Variable

```bash
export PLAYWRIGHT_CLI_SESSION="mysession"
playwright-cli open example.com
```

## Attaching to a Running Browser

```bash
playwright-cli attach --cdp=chrome
playwright-cli attach --cdp=msedge
playwright-cli attach --cdp=http://localhost:9222
playwright-cli attach --extension
playwright-cli detach
playwright-cli -s=msedge detach
```

## Browser Session Configuration

```bash
playwright-cli open https://example.com --config=.playwright/my-cli.json
playwright-cli open https://example.com --browser=firefox
playwright-cli open https://example.com --headed
playwright-cli open https://example.com --persistent
```

## Best Practices

```bash
playwright-cli -s=github-auth open https://github.com
playwright-cli -s=docs-scrape open https://docs.example.com
playwright-cli close-all
playwright-cli -s=oldsession delete-data
```
