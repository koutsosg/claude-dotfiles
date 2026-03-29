---
name: warn-protect-secrets
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.env(\.|$)|firebase-service-account\.json|credentials\.json|\.pem$|\.key$
---

**STOP — Sensitive file!**

You are about to edit a file that contains real secrets for this project.

**Known secret files in this project:**
- `.env` files — contain AWS keys, DB passwords, SMTP, WooCommerce secrets
- `firebase-service-account.json` — contains Firebase private key
- Any `.pem` / `.key` files — SSL/SSH private keys

**Rules:**
1. NEVER commit these files to git
2. NEVER log their contents
3. NEVER expose them in API responses or error messages
4. If a secret was exposed, rotate it immediately

**Before editing:** Confirm with the user that this change is intentional and that the file will NOT be committed.
