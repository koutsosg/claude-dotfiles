#!/usr/bin/env bash
# claude-dotfiles/project-init.sh
#
# Drop this script into any project root and run it.
# It launches Claude Code with a prompt that:
#   1. Analyzes the codebase deeply
#   2. Creates a tailored CLAUDE.md
#   3. Creates .claude/project-knowledge/ files (architecture, auth, API, etc.)
#
# Usage:
#   ./project-init.sh
#   ./project-init.sh --dry-run    # prints the prompt without running Claude
#
# Requirements:
#   - Claude Code CLI installed (`claude` in PATH)
#   - Run from project root

set -euo pipefail

DRY_RUN=false
for arg in "$@"; do
  [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

# ── Build the prompt ──────────────────────────────────────────────────────────
read -r -d '' PROMPT << 'PROMPT_EOF'
You are a senior software architect. Your task is to deeply analyze this codebase and produce structured documentation that will serve as persistent context for Claude Code in future sessions.

## Step 1: Codebase Exploration

Explore the entire project thoroughly:
- Read the root directory structure
- Identify all top-level packages/services/apps
- Read package.json / pyproject.toml / Cargo.toml / go.mod / etc. to understand dependencies
- Read existing README files, docs, and any architecture diagrams
- Identify the tech stack (frameworks, databases, cloud services, auth providers)
- Understand the build system, dev commands, and deployment approach
- Map out the authentication/authorization architecture
- Identify API contracts and communication patterns between services
- Note any known issues, TODOs, or areas of technical debt in the code

Do NOT skip any service or package. Read deeply — at minimum scan every directory and read key files.

## Step 2: Create CLAUDE.md

Create `CLAUDE.md` in the project root (if it doesn't exist, or update it carefully if it does).

The CLAUDE.md must include:

```markdown
# {Project Name} Project Guide

## Tech Stack
<!-- List every service/app with its framework, key dependencies, purpose -->

## Build & Run Commands
<!-- Table: System | Dev Command | Build Command | Deploy Command -->

## Authentication Architecture
<!-- How auth works end-to-end: tokens, sessions, SSO, mobile vs web -->

## API Conventions
<!-- Base URLs, auth headers, response format, pagination, error format -->

## Critical Conventions
<!-- Naming quirks, workflow states, non-obvious patterns developers must know -->

## Important Rules
<!-- Security rules, never-do-this, file handling, env var policy -->

## When to Load Knowledge Files
<!-- Table: Working on... | Load this file -->
<!-- Only include rows for files you actually create below -->
```

Adapt sections to the actual project. Skip sections that don't apply. Add project-specific sections if needed.

## Step 3: Create .claude/project-knowledge/ files

Create `.claude/project-knowledge/` directory and populate it with focused knowledge files. Only create files that are relevant to this specific project.

**Standard files to create if applicable:**

### 01-project-structure.md
- Full directory tree (key files annotated)
- All packages and their purposes
- Shared libraries and how they're imported
- Key config files and what they control
- External services and integrations

### 02-auth-flow.md (if auth exists)
- Auth providers used (OAuth2, JWT, sessions, API keys)
- Complete auth flow diagram (step-by-step, numbered)
- Token storage locations (cookies, localStorage, SecureStore, etc.)
- Session management and refresh strategy
- Role/permission model
- Known auth edge cases or bugs

### 03-api-contract.md (if REST/GraphQL/RPC APIs exist)
- Base URLs per environment
- Auth header format
- Key endpoints with request/response shapes
- Pagination pattern
- Error format
- Rate limiting / webhook secrets

### 04-mobile-architecture.md (if React Native / Flutter / Swift / Kotlin app exists)
- App structure and navigation
- State management approach
- API client and auth integration
- Push notification setup
- Build/distribution process

### 05-media-pipeline.md (if video/audio/file processing exists)
- Upload flow
- Processing pipeline (Lambda, workers, queues)
- Storage strategy (S3, CDN)
- Playback architecture

### 06-database-schema.md (if database exists)
- All content types / tables / collections
- Key relations and foreign keys
- Naming conventions
- Migration strategy
- Known schema issues

### 07-problems-found.md
- Security vulnerabilities discovered during analysis
- Technical debt and known bugs
- Inconsistencies and anti-patterns
- Missing validations or auth gaps
- Hardcoded values that should be env vars
- TODOs left in code

### 08-architecture-overview.md
- System architecture diagram (ASCII or description)
- Service interaction map
- Data flow for key user journeys
- Deployment topology
- External dependencies

**Rules for knowledge files:**
- Each file must be self-contained and scannable
- Use headers, bullet points, code blocks
- Be specific — include actual file paths, env var names, endpoint paths
- Flag anything that's a known issue or needs attention
- Do NOT duplicate content from CLAUDE.md — go deeper here

## Step 4: Verify and report

After creating all files:
1. List every file created with a one-line description
2. Summarize the 3 most important architectural facts about this project
3. List any critical issues or security concerns found
4. Suggest what `.claude/project-knowledge/` files were skipped and why

Begin analysis now. Be thorough — the goal is that another developer (or Claude in a future session) can understand this entire codebase just from CLAUDE.md + the knowledge files.
PROMPT_EOF

# ── Execute ───────────────────────────────────────────────────────────────────
if [[ "$DRY_RUN" == true ]]; then
  echo "=== DRY RUN — prompt that would be sent to Claude ==="
  echo ""
  echo "$PROMPT"
  echo ""
  echo "=== Run without --dry-run to execute ==="
  exit 0
fi

echo "=== Claude Project Initializer ==="
echo "Project: $PROJECT_NAME"
echo "Directory: $PROJECT_DIR"
echo ""
echo "This will:"
echo "  1. Analyze the entire codebase"
echo "  2. Create/update CLAUDE.md"
echo "  3. Create .claude/project-knowledge/ files"
echo ""
read -rp "Proceed? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

echo ""
echo "Launching Claude Code analysis..."
echo "(This may take a few minutes for large codebases)"
echo ""

# Run claude with the prompt piped as input
# --print: non-interactive mode, outputs response to stdout
claude --print "$PROMPT"
