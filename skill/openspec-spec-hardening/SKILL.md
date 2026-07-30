---
name: openspec-spec-hardening
description: Use when reviewing drafted OpenSpec artifacts for ambiguity, missing decisions, weak scenarios, or implementation readiness.
---

# OpenSpec Spec-Hardening Contract

Apply this planning sub-phase after the stack pack has been resolved and before implementation.

## Entry criteria

- One active change has drafted proposal, design, specs, and tasks.
- The request asks to harden, clarify, de-risk, or make the change implementation-ready.

## Workflow

1. Read all artifacts and classify findings as CRITICAL, IMPORTANT, or OPTIONAL.
2. Ask targeted clarification questions before editing when decisions are missing.
3. Do not invent product behavior, architecture, compatibility, security, or operational decisions.
4. After the operator answers or explicitly authorizes edits, update all affected artifacts consistently in English.
5. Require observable SHALL requirements, deterministic WHEN/THEN scenarios, failure modes, edge cases, and traceable tasks.
6. Validate the change strictly.

## Completion criteria

- No unresolved CRITICAL ambiguity remains, or the operator explicitly accepts a documented non-critical residual risk.
- Proposal, design, specs, and tasks agree.
- Strict validation passes.
- The response reports findings, decisions, touched files, commands, blockers, and remaining questions.
