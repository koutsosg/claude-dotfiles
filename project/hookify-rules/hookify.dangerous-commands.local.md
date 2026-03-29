---
name: warn-dangerous-commands
enabled: true
event: bash
pattern: rm\s+-rf|git\s+reset\s+--hard|git\s+push\s+--force|git\s+push\s+-f|git\s+clean\s+-f
---

**STOP — Destructive command detected!**

This command is irreversible and can cause data loss:
- `rm -rf` — permanently deletes files, no recycle bin
- `git reset --hard` — discards all uncommitted changes
- `git push --force` / `-f` — overwrites remote history
- `git clean -f` — permanently deletes untracked files

**Before proceeding:**
- Are you 100% sure this is intentional?
- Have you checked what will be deleted/overwritten?
- Is there a safer alternative (e.g., `git stash` instead of `reset --hard`)?

Only continue if the user has explicitly confirmed this action.
