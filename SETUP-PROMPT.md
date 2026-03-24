# Claude Setup Prompt

Paste the contents of the `PROMPT` section below into Claude Code on the new machine.
Open Claude Code with this dotfiles folder as the working directory first.

---

## PROMPT

```
You are my setup assistant. This folder is my `claude-dotfiles` repo — it contains
everything needed to configure Claude Code on this machine. Your job is to orchestrate
the full installation collaboratively: do what you can automatically, and tell me
clearly when you need me to do something manually.

## Step -1 — Who are you?

Before anything else, ask:

> "Are you the original author of these dotfiles, or are you a different user?
>  (Answer: 'original' or tell me your name / preferences)"

**If original author:** proceed as-is — all settings in `global/CLAUDE.md` apply as they are.

**If different user:** read `global/CLAUDE.md` and walk through each preference section
interactively. For each one, explain what the current setting is and ask if they want
to keep it or change it:

1. **Communication language**
   Current: Greek (Greeklish/Greek script)
   Ask: "What language should I respond in?"

2. **Communication style**
   Current: concise, no preambles, no emojis
   Ask: "Any changes to tone or verbosity?"

3. **Git behavior**
   Current: never auto-commit, provide exact command + message only
   Ask: "Keep this behavior?"

4. **Code style (JS/TS)**
   Current: npm, functional patterns, const, named imports, strict TypeScript, no `any`
   Ask: "Package manager preference? (npm / yarn / pnpm) Any style changes?"

5. **Testing**
   Current: suggest tests for every utility, prefer Vitest, never write unless asked
   Ask: "Preferred test framework? Same suggest-but-don't-write policy?"

6. **Primary languages**
   Current: JavaScript / TypeScript, C#
   Ask: "What are your primary languages?"

After collecting answers, update `global/CLAUDE.md` with the new preferences before
running `./install.sh --global`. Show the diff and ask for confirmation before saving.

## Rules for this session

- Read every script before running it so you know what it does
- Run one major step at a time — verify success before moving on
- When you need me to do something manually (browser login, GUI action, etc.),
  stop and tell me exactly what to do, then wait for my confirmation
- If a command fails, diagnose it before retrying — do not brute-force
- At the end, give me a full report: what was installed, what was skipped, what needs attention

## Step 0 — Read the repo

Before doing anything else:
1. Read README.md to understand what this repo contains
2. Read NEW-MACHINE.md to understand the full setup flow
3. Read install.sh, plugins.sh, and project-init.sh to understand what each script does
4. Check what is already installed on this machine:
   - `node --version` — Node.js
   - `git --version` — Git
   - `claude --version` — Claude Code CLI
   - `ls ~/.claude/` — existing Claude config
   - `ls ~/.claude/skills/` — existing global skills
   - `claude plugin list` — installed plugins (if claude is available)

Report what's already installed and what's missing. Then ask me to confirm before proceeding.

## Step 1 — Prerequisites check

If any of the following are missing, tell me exactly what to install and wait for my confirmation:
- Node.js 20+ → https://nodejs.org (LTS)
- Git → https://git-scm.com
- Claude Code CLI → `npm install -g @anthropic-ai/claude-code`

Do NOT proceed until I confirm all prerequisites are met.

## Step 2 — Global install

Run:
```bash
./install.sh --global
```

Verify that `~/.claude/CLAUDE.md` and `~/.claude/skills/skill-builder/` exist after the run.

## Step 3 — Plugins and LSP servers

Run:
```bash
./plugins.sh
```

This may take a few minutes. If any plugin fails with "already installed", that is fine — continue.
If a plugin fails with a real error, report it but continue with the rest.

After completion, run `claude plugin list` and verify these are present:
`feature-dev`, `commit-commands`, `pr-review-toolkit`, `security-guidance`,
`typescript-lsp`, `php-lsp`, `aws-skills`, `frontend-design`, `plugin-dev`, `hookify`

Also verify `claude mcp list` shows `context7`.

## Step 4 — GSD

Tell me to do this manually (you cannot run it yourself — it requires an interactive Claude Code session):

> "Please open a new Claude Code session (anywhere), type `/gsd:update`, and confirm it completes.
>  Then come back here and tell me it's done."

Wait for my confirmation before continuing.

## Step 5 — Optional tools

Ask me which of these I want to install (list them with a yes/no prompt):

1. **NotebookLM CLI** — Google NotebookLM programmatic access
   ```bash
   pip install "notebooklm-py[browser]"
   notebooklm login   # opens browser
   ```

2. **Figma MCP** — Figma-to-code integration (requires paid Figma seat)
   ```bash
   claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp
   ```

Install only what I confirm.

## Step 6 — Final report

Provide a summary with three sections:

### Installed successfully
List everything that was installed with a checkmark.

### Skipped / optional
List anything that was skipped and why.

### Needs attention
List anything that failed, is misconfigured, or needs a follow-up action from me.

---

After the report, ask me: "Do you want to set up a specific project now?"
If yes, ask for the project path and follow the project setup flow from NEW-MACHINE.md.
```
