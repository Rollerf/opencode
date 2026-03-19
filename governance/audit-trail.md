# Audit Trail for High-Impact Actions

High-impact actions require traceable records linked to an OpenSpec change.

## Mandatory Fields

- `timestamp`
- `actor`
- `change_id`
- `phase`
- `command`
- `target_files`
- `outcome`

## High-Impact Classification

Record an audit entry when an action:

1. modifies workflow contracts, routing policy, or evaluation thresholds,
2. updates stack pack safety constraints,
3. changes validation or promotion gate logic.

## Record Location

Store per-change entries under:

- `openspec/changes/<name>/evidence/audit-log.md`
