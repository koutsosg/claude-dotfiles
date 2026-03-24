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

**Windows (PowerShell):**
```powershell
git clone https://github.com/koutsosg/claude-dotfiles.git $HOME\claude-dotfiles
```

**Mac / Linux (Terminal):**
```bash
git clone https://github.com/koutsosg/claude-dotfiles.git ~/claude-dotfiles
chmod +x ~/claude-dotfiles/install.sh ~/claude-dotfiles/plugins.sh ~/claude-dotfiles/project-init.sh
```

---

## Step 2 — Global install (CLAUDE.md + meta-skills)

**Windows (PowerShell):**
```powershell
bash $HOME\claude-dotfiles\install.sh --global
```

**Mac / Linux:**
```bash
~/claude-dotfiles/install.sh --global
```

Installs into `~/.claude/`:
- `CLAUDE.md` — global rules (language, style, git behavior, etc.)
- `skills/skill-builder/`, `skills/skill-design-guide/`, `skills/ui-ux-pro-max/`

---

## Step 3 — Plugins + LSP servers + MCP

**Windows (PowerShell):**
```powershell
bash $HOME\claude-dotfiles\plugins.sh
```

**Mac / Linux:**
```bash
~/claude-dotfiles/plugins.sh
```

Installs:
- Claude plugins: `feature-dev`, `commit-commands`, `pr-review-toolkit`, `security-guidance`, `typescript-lsp`, `php-lsp`, `aws-skills`, `frontend-design`, `plugin-dev`, `hookify`
- DevOps plugins: `iac-terraform`, `aws-cost-optimization`, `ci-cd`, `sre-engineer`
- npm globals: `typescript-language-server`, `typescript`, `intelephense`
- MCP: `context7` (live library docs)

> If a plugin fails with "already installed" — fine, continue.

---

## Step 4 — GSD (Get Shit Done)

Open Claude Code and run:

```
/gsd:update
```

GSD is self-managed — never install it manually. This installs all `gsd:*` skills, agents, hooks, and commands.

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

### 1. Create project root + install skills

**Windows (PowerShell):**
```powershell
mkdir C:\projects\myproject
cd C:\projects\myproject
git init
bash $HOME\claude-dotfiles\install.sh --project
```

**Mac / Linux:**
```bash
mkdir ~/projects/myproject && cd ~/projects/myproject
git init
~/claude-dotfiles/install.sh --project
```

Copies into `.claude/`: 25 skills, agents, commands, rules + `.gitignore` template.

> Open `.gitignore` and uncomment your service folder names at the top.

### 2. Bootstrap with Claude

Open Claude Code at the project root and paste the contents of `NEW-PROJECT-PROMPT.md`.
Claude will analyze the codebase, create `CLAUDE.md` + knowledge files, initialize GSD, and set up hookify.

---

## Setting up an EXISTING project (already has CLAUDE.md + .planning/)

**Windows (PowerShell):**
```powershell
cd C:\projects\myproject
bash $HOME\claude-dotfiles\install.sh --project
```

**Mac / Linux:**
```bash
cd ~/projects/myproject
~/claude-dotfiles/install.sh --project
```

Then open Claude Code and paste:

```
I'm setting up this project on a new machine. My claude-dotfiles are already installed globally.

Please do the following in order:

1. Read CLAUDE.md and all files in .claude/project-knowledge/ (if they exist).
   If they don't exist, analyze the codebase deeply and create them now.

2. Read .planning/PROJECT.md, .planning/ROADMAP.md, and .planning/STATE.md
   to understand project status.
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

| Task | Windows (PowerShell) | Mac / Linux |
|------|----------------------|-------------|
| Update dotfiles | `cd $HOME\claude-dotfiles; git pull; bash install.sh --all; bash plugins.sh` | `cd ~/claude-dotfiles && git pull && ./install.sh --all && ./plugins.sh` |
| Update GSD | `/gsd:update` inside Claude Code | same |
| Install project skills | `bash $HOME\claude-dotfiles\install.sh --project` | `~/claude-dotfiles/install.sh --project` |
| Resume GSD work | `/gsd:resume-work` inside Claude Code | same |
| Check GSD progress | `/gsd:progress` inside Claude Code | same |
