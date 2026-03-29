---
name: block-auto-commit
enabled: true
event: bash
pattern: git\s+commit
---

**STOP — Auto-commit blocked!**

This project has an explicit rule: **NEVER auto-commit**.

Commits must only happen when the user explicitly asks for one.

**Required workflow:**
1. Finish the work
2. Wait for user to say "commit" or "κάνε commit"
3. Provide the exact `git commit` command + message for user approval
4. User runs it themselves or approves it explicitly

Do NOT run `git commit` unless the user has explicitly requested it in this message.
