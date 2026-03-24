# New Project Prompt

Paste the contents of the `PROMPT` section below into Claude Code.
Open Claude Code with the **project root folder** as the working directory.

Prerequisites before pasting:
- `claude-dotfiles` machine setup already done (`install.sh --global` + `plugins.sh` + `/gsd:update`)
- Project root folder exists with a `git init` (parent repo)
- Service folders are inside (each may have their own `.git` — that is fine)
- `~/claude-dotfiles/install.sh --project` already run from this root

---

## PROMPT

```
You are my project setup assistant. I have just initialized a new project root folder.
This folder contains multiple services/apps, each potentially with their own git repo.
The parent git repo tracks ONLY: `.planning/`, `CLAUDE.md`, `.claude/` — nothing else.

Your job is to analyze the entire codebase and bootstrap this project for productive work.

## Important git rules for this session

- The parent repo tracks ONLY: `.planning/`, `CLAUDE.md`, `.claude/`, root config files
- Each service subfolder may have its own `.git` — do NOT touch those
- When you need to commit anything, commit only to the parent repo
- Never `git add` service folders — they are independent repos
- If `.gitignore` doesn't exist at root, create one that ignores service folders' build artifacts

## Step 0 — Read the dotfiles setup

Read `.claude/` to understand what skills, agents, rules, and commands are available.
Read `CLAUDE.md` if it already exists.

Then check the project structure:
- `ls -la` at root to see all services/folders
- For each service folder: identify the tech stack (read package.json, go.mod, requirements.txt, etc.)
- Note which folders have their own `.git`

Report the structure and ask me to confirm before proceeding.

## Step 1 — Deep codebase analysis

Analyze every service thoroughly:
- Read key source files, configs, and entry points
- Understand how services communicate (REST, events, shared DB, etc.)
- Map the authentication architecture end-to-end
- Identify databases, cloud services, external APIs
- Note any security issues, TODOs, or technical debt in the code
- Understand the deployment approach (Docker, cloud, CI/CD)

Do NOT skip any service. Read deeply.

## Step 2 — Create CLAUDE.md

Create `CLAUDE.md` at the project root.

It must include:

### Tech Stack
One entry per service/app — framework, key dependencies, purpose.

### Build & Run Commands
Table: Service | Dev command | Build command | Deploy command

### Authentication Architecture
End-to-end auth flow. Tokens, sessions, SSO, mobile vs web (if applicable).

### API Conventions
Base URLs, auth headers, response format, pagination, error format.

### Critical Conventions
Non-obvious patterns, naming quirks, workflow states, anything a new developer must know.

### Important Rules
Security rules, never-do-this list, env var policy, webhook handling.

### When to Load Knowledge Files
Table: Working on... | Load this file
(fill in after creating knowledge files below)

## Step 3 — Create .claude/project-knowledge/ files

Create only the files relevant to this project:

- `01-project-structure.md` — directory tree, packages, config files, external integrations
- `02-auth-flow.md` — auth providers, token flow, roles, storage locations (if auth exists)
- `03-api-contract.md` — endpoints, request/response shapes, errors (if APIs exist)
- `04-mobile-architecture.md` — app structure, navigation, state, build (if mobile app exists)
- `05-media-pipeline.md` — upload, processing, storage, playback (if media pipeline exists)
- `06-database-schema.md` — tables/collections, relations, naming conventions (if DB exists)
- `07-problems-found.md` — security issues, bugs, tech debt, hardcoded values, missing auth
- `08-architecture-overview.md` — system map, service interactions, data flows, deployment

Rules:
- Each file must be self-contained and scannable
- Include actual file paths, env var names, endpoint paths
- Flag known issues clearly
- Do NOT duplicate CLAUDE.md content — go deeper here

## Step 4 — Initialize GSD planning

Run:
```
/gsd:new-project
```

This will ask me questions about the project vision, goals, constraints, and milestones.
Answer together with me — use what you learned from the codebase analysis to inform the answers.

After GSD initialization, `.planning/PROJECT.md`, `.planning/ROADMAP.md`, and `.planning/REQUIREMENTS.md` will exist.

## Step 5 — Set up hookify rules

Run:
```
/hookify:configure
```

Based on the codebase analysis, suggest project-specific rules. Common ones:
- No `.env` file commits
- No hardcoded API keys or secrets
- No `console.log` in production code (if applicable)
- Warn before touching auth middleware
- Warn before touching webhook endpoints (if unauthenticated)

Ask me which rules I want to enable.

## Step 6 — First commit to parent repo

Stage and commit only the project scaffold files:

```bash
git add CLAUDE.md .claude/project-knowledge/ .planning/ .gitignore
git commit -m "chore: initialize project scaffold — CLAUDE.md, knowledge files, GSD planning"
```

Do NOT add service folders.

## Step 7 — Final report

Provide a summary:

### Project overview
2-3 sentences on what this project does.

### Services mapped
List each service with its tech stack.

### Knowledge files created
List each file with a one-line description.

### Critical issues found
Any security vulnerabilities, missing configs, or blockers I should address first.

### Suggested first milestone
Based on the codebase state, what should the first GSD milestone focus on?

---

Ready? Start with Step 0 — read `.claude/` and map the project structure.
```
