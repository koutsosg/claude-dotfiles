# New Machine Setup Guide

Complete setup guide for Claude Code + dotfiles on a fresh machine.

---

## Prerequisites (manual — do this first)

| Tool | Install |
|------|---------|
| **Node.js 20+** | https://nodejs.org (LTS) |
| **Git** | https://git-scm.com |
| **Claude Code CLI** | `npm install -g @anthropic-ai/claude-code` |
| Python 3.10+ (optional, for NotebookLM) | https://python.org |

Verify:
```bash
node --version   # v20+
git --version
claude --version
```

---

## Step 1 — Clone dotfiles

```bash
git clone https://github.com/YOUR_USERNAME/claude-dotfiles.git ~/claude-dotfiles
cd ~/claude-dotfiles
chmod +x install.sh plugins.sh project-init.sh   # Mac/Linux only
```

> Windows (Git Bash): the `chmod` is ignored but the scripts run fine.

---

## Step 2 — Global install (CLAUDE.md + meta-skills)

```bash
./install.sh --global
```

Installs into `~/.claude/`:
- `CLAUDE.md` — global rules (Greek responses, npm, no auto-commit, etc.)
- `skills/skill-builder/`, `skills/skill-design-guide/`, `skills/ui-ux-pro-max/`

---

## Step 3 — Plugins + LSP servers + MCP

```bash
./plugins.sh
```

Installs:
- Claude plugins: `feature-dev`, `commit-commands`, `pr-review-toolkit`, `security-guidance`, `typescript-lsp`, `php-lsp`, `aws-skills`, `frontend-design`, `plugin-dev`, `hookify`
- DevOps plugins: `iac-terraform`, `aws-cost-optimization`, `ci-cd` (from `ahmedasmar/devops-claude-skills`), `sre-engineer`
- npm globals: `typescript-language-server`, `typescript`, `intelephense`
- MCP: `context7` (live library docs)

> If a plugin fails with "already installed", that's fine — continue.

---

## Step 4 — GSD (Get Shit Done)

Open Claude Code and run:

```
/gsd:update
```

This self-installs all `gsd:*` skills, agents, hooks, and commands. GSD is self-managed — never install it manually.

---

## Step 5 — Verify setup

Open Claude Code and paste this verification prompt:

```
Check my Claude Code setup. Verify:
1. ~/.claude/CLAUDE.md exists and has content
2. ~/.claude/skills/ contains: skill-builder, skill-design-guide, ui-ux-pro-max
3. Run `claude plugin list` and confirm these are installed:
   feature-dev, commit-commands, pr-review-toolkit, security-guidance,
   typescript-lsp, php-lsp, aws-skills, frontend-design, plugin-dev, hookify
4. Run `claude mcp list` and confirm context7 is present
5. Check that /gsd:help works (GSD installed)

Report what's missing or broken and suggest the exact command to fix each issue.
```

---

## Setting up a NEW project (from scratch)

### 1. Install project-level skills/agents/rules

```bash
cd /path/to/your-project
~/claude-dotfiles/install.sh --project
```

Copies into `.claude/`: 25 skills, agents (`fullstack-architect`), commands, rules.

### 2. Generate project documentation

```bash
~/claude-dotfiles/project-init.sh
```

Claude will analyze the codebase and create:
- `CLAUDE.md` — project guide
- `.claude/project-knowledge/` — deep docs (auth, API, DB, architecture, etc.)

> For a large codebase this takes 5-10 minutes.

### 3. Initialize GSD planning

Inside Claude Code, from the project root:

```
/gsd:new-project
```

Creates:
- `.planning/PROJECT.md` — vision, goals, constraints
- `.planning/ROADMAP.md` — milestones and phases
- `.planning/REQUIREMENTS.md`

### 4. Set up project hookify rules

```
/hookify:configure
```

Configure project-specific workflow guards (no .env commits, no console.log, API URL checks, etc.).

---

## Setting up an EXISTING project (already has CLAUDE.md + .planning/)

```bash
cd /path/to/your-project
~/claude-dotfiles/install.sh --project
```

That's it — skills/agents/rules are installed. GSD planning already exists in `.planning/`.

To resume work:
```
/gsd:resume-work
```

---

## Paste-and-run Claude prompt for new project bootstrap

After steps 1-4 above, paste this into Claude Code at the project root for a full bootstrap:

---

```
I'm setting up this project on a new machine. My claude-dotfiles are already installed globally.

Please do the following in order:

1. Read CLAUDE.md and all files in .claude/project-knowledge/ (if they exist).
   If they don't exist, analyze the codebase deeply and create them now
   (use the project-init.sh logic: CLAUDE.md + 8 knowledge files).

2. Read .planning/PROJECT.md, .planning/ROADMAP.md, and .planning/STATE.md
   (if they exist) to understand project status.
   If .planning/ doesn't exist, run /gsd:new-project to initialize planning.

3. Check .planning/phases/ for any in-progress phase.
   If found, read that phase's PLAN.md and report current status.

4. Summarize:
   - What this project does (2-3 sentences)
   - Current milestone and phase
   - Next action I should take
   - Any critical issues or blockers I should know about

Don't make any code changes yet — just report.
```

---

## Quick reference

| Task | Command |
|------|---------|
| Update dotfiles | `cd ~/claude-dotfiles && git pull && ./install.sh --all && ./plugins.sh` |
| Update GSD | `/gsd:update` inside Claude Code |
| Add project skills to new project | `~/claude-dotfiles/install.sh --project` |
| Generate project docs | `~/claude-dotfiles/project-init.sh` |
| Resume GSD work | `/gsd:resume-work` |
| Check GSD progress | `/gsd:progress` |
| Plan next phase | `/gsd:plan-phase` |
| Execute phase | `/gsd:execute-phase` |
