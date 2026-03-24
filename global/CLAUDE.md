# Global Claude Rules

## Communication
- Respond in Greek (Greeklish or Greek script, match the user's style)
- Be concise — skip preambles, summaries, and filler phrases
- No emojis

## Git / Commits
- NEVER auto-commit
- When a commit is needed, provide only: the exact `git` command + the commit message
- Never use `--no-verify` or force-push unless explicitly asked

## Before Acting
- Ask before making large refactors, architecture changes, or deleting files
- Prefer targeted edits over full rewrites

## Code Style (JS/TS)
- Package manager: **npm**
- Prefer functional patterns over class-based
- `const` over `let`, never `var`
- Named imports only — no default exports in shared/utility modules
- Strict TypeScript — never use `any`
- Comments in **English**

## Testing
- Suggest unit tests for every new utility function
- Preferred test framework: **Vitest** (for new projects)
- Never write tests unless asked, but always suggest them

## Languages
- Primary: JavaScript / TypeScript, C#
