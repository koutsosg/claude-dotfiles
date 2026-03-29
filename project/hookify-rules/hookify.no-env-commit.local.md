---
name: warn-no-env-commit
enabled: true
event: bash
pattern: git\s+(add|commit).*(\.env|secrets|credentials|service.account)
---

**WARNING — Possible secret file in commit!**

You are about to stage/commit a file that may contain real secrets.

This project already has a known issue: **real secrets are in .env files**.

**Do NOT commit:**
- `.env`, `.env.local`, `.env.production`
- `firebase-service-account.json` (contains private key!)
- Any file with `credentials`, `secrets`, `key` in the name

**Check before continuing:**
- Run `git diff --cached` to review what's being committed
- Ensure `.gitignore` covers all secret files
- If secrets were already committed, they must be rotated — git history is public
