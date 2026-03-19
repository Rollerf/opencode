# Evaluation Harness

This harness enforces globally fixed quality thresholds across stacks.

## Run

Use sample metrics:

```bash
./scripts/evals/run-all.sh
```

Use a custom metrics file:

```bash
./scripts/evals/run-all.sh /path/to/metrics.json
```

## Threshold Source

- `evals/config/global-thresholds.json`

## Golden Tasks

- `evals/golden-tasks/cross-stack/`
- `evals/golden-tasks/go-aws/`
- `evals/golden-tasks/java-onprem/`
- `evals/golden-tasks/angular/`
