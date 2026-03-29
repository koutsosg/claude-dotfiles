---
name: warn-no-console-log
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.(ts|tsx|js|jsx)$
  - field: new_text
    operator: regex_match
    pattern: console\.(log|warn|error|debug|info)\(
---

**`console.log` in production code detected!**

Debug logs should not ship to production.

**Risks:**
- Can expose sensitive data (tokens, user info, API responses)
- Performance overhead in hot paths
- Clutters browser/server logs

**Alternatives:**
- Remove before committing
- Use a proper logger (e.g., `pino`, `winston`) with log levels
- Use React Native's `__DEV__` guard: `if (__DEV__) console.log(...)`

If this is intentional debug code, add a `// TODO: remove` comment.
