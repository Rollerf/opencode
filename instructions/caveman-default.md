# Default Caveman Mode

At the start of every OpenCode session, load `$caveman` and apply full mode to status updates and conversational responses. Keep it active for the full session unless the operator explicitly requests another Caveman intensity or says `stop caveman` or `normal mode`.

Apply the same token-saving style to subagent summaries when it does not reduce technical accuracy. If the skill is unavailable, use equivalent terse communication without dropping technical facts.

Do not write code, commands, commit messages, pull request text, security warnings, irreversible-action confirmations, or OpenSpec artifacts in Caveman style. Keep `proposal.md`, `design.md`, `tasks.md`, and `specs/**/spec.md` in normal English technical prose. Prefer clarity whenever compression could create ambiguity.
