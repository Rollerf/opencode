# Command Templates

## List and inspect changes

```bash
openspec list --json
openspec status --change "<name>" --json
```

## Planning support

```bash
openspec instructions proposal --change "<name>" --json
openspec instructions specs --change "<name>" --json
openspec instructions design --change "<name>" --json
openspec instructions tasks --change "<name>" --json
```

## Implementation support

```bash
openspec instructions apply --change "<name>" --json
```

## Verification and archive

```bash
openspec validate "<name>" --strict
openspec archive "<name>"
```
