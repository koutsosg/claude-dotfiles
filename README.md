# claude-dotfiles

Portable Claude Code setup — skills, agents, commands, rules, and install scripts.
Clone on any machine (Windows/Mac/Linux) and be productive in minutes.

## What's included

```
claude-dotfiles/
├── global/                      # → ~/.claude/
│   ├── CLAUDE.md                # Global rules (Greek, npm, functional TS, no auto-commit)
│   ├── settings-template.json   # Portable settings (enabledPlugins, alwaysThinkingEnabled)
│   └── skills/                  # Organized in 4 categories (interactive install)
│       ├── [General]            # notebooklm, skill-builder, skill-design-guide, ui-ux-pro-max
│       ├── [Swift / Apple]      # swift, swiftui, swiftui-pro, ios, macos, watchos, visionos,
│       │                        # core-ml, apple-intelligence, app-store, appstore-readiness,
│       │                        # swiftdata, mapkit, developing-with-swift, memory-leak-diagnosis,
│       │                        # swift-best-practices, swift-modern-architecture,
│       │                        # swift-performance-optimization, swift-speech-analyzer,
│       │                        # swift-unit-testing
│       ├── [Mobile / Product]   # design, generators, growth, monetization, legal,
│       │                        # release-review, performance, testing, product,
│       │                        # shared, foundation, security
│       └── [Android / Kotlin]   # android-kotlin, android-clean-architecture,
│                                # android-jetpack-compose, kotlin-specialist,
│                                # kotlin-coroutines-flows, kotlin-patterns
│
└── project/                     # → .claude/ in any project
    ├── skills/                  # Organized in 5 categories (interactive install)
    │   ├── [Backend / API]      # api-design, database-migrations, postgres, docker-patterns
    │   ├── [Security]           # security-review, owasp-security, insecure-defaults,
    │   │                        # codeql, semgrep, sarif-parsing, sharp-edges
    │   ├── [Testing]            # test-driven-development, e2e-testing, playwright-skill,
    │   │                        # verification-before-completion
    │   ├── [Code Quality]       # coding-standards, systematic-debugging, second-opinion,
    │   │                        # finishing-a-development-branch, using-git-worktrees,
    │   │                        # changelog-generator, app-store-specialist
    │   └── [Agents / Meta]      # dispatching-parallel-agents, subagent-driven-development
    ├── agents/
    │   └── fullstack-architect.md
    ├── commands/
    │   ├── build-fix.md
    │   ├── code-review.md
    │   ├── e2e.md
    │   └── tdd.md
    ├── rules/
    │   ├── common-security.md
    │   ├── git-workflow.md
    │   ├── typescript-security.md
    │   └── typescript-style.md
    └── hookify-rules/           # Generic hookify rule templates
        ├── hookify.dangerous-commands.local.md
        ├── hookify.no-auto-commit.local.md
        ├── hookify.no-console-log.local.md
        ├── hookify.no-env-commit.local.md
        ├── hookify.no-typescript-any.local.md
        └── hookify.protect-secrets.local.md
```

### Not in this repo (installed separately)

| What | How to install |
|------|---------------|
| GSD (Get Shit Done) — 30+ gsd:* skills | auto-run by `./install.sh --global` |
| feature-dev, commit-commands, pr-review-toolkit | `./plugins.sh` |
| security-guidance, typescript-lsp, php-lsp | `./plugins.sh` |
| aws-skills (CDK, serverless, cost-ops, AgentCore) | `./plugins.sh` |
| devops-claude-skills (Terraform, AWS cost, CI/CD) | `./plugins.sh` |
| sre-engineer (SLO, monitoring, incident response) | `./plugins.sh` |
| frontend-design — production UI skill | `./plugins.sh` |
| plugin-dev — create custom plugins | `./plugins.sh` |
| hookify — custom workflow hooks | `./plugins.sh` |
| npm LSP servers (typescript-language-server, intelephense) | `./plugins.sh` |
| **Context7 MCP** — live library docs | `./plugins.sh` |
| **NotebookLM** (optional) | `pip install notebooklm-py[browser]` + `notebooklm login` |
| **Figma MCP** (optional) | `claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp` |

## Quick install

```bash
git clone https://github.com/YOUR_USERNAME/claude-dotfiles.git ~/claude-dotfiles
chmod +x ~/claude-dotfiles/install.sh ~/claude-dotfiles/plugins.sh ~/claude-dotfiles/project-init.sh

# Install global skills + CLAUDE.md + settings.json + GSD (auto)
~/claude-dotfiles/install.sh --global

# Install Claude plugins + LSP servers + MCP
~/claude-dotfiles/plugins.sh
```

## Interactive skill selection

Both `--global` and `--project` show an interactive menu — you pick categories, then individual skills within each category.

**Global example:**
```
Select categories:
  [1] General
  [2] Swift / Apple
  [3] Mobile / Product
  [4] Android / Kotlin
  [A] All categories (pick individually)
  [X] Install everything

  ── Swift / Apple ──
    [ 1] swift
    [ 2] swift-best-practices
    ...
    [ A] All
    [ S] Skip
```

**Project example:**
```
Select categories:
  [1] Backend / API
  [2] Security
  [3] Testing
  [4] Code Quality
  [5] Agents / Meta
  [A] All categories
  [X] Install everything
```

## Installing into a project

```bash
# From the project root:
/path/to/claude-dotfiles/install.sh --project
```

Copies selected skills, agents, commands, and rules into `.claude/` in the current directory.

Then generate project-specific documentation:

```bash
/path/to/claude-dotfiles/project-init.sh
```

This launches Claude to analyze the codebase and create:
- `CLAUDE.md` — project guide (tech stack, commands, conventions)
- `.claude/project-knowledge/` — deep architecture docs (auth, API, DB, etc.)

## Global vs project install

| | `--global` | `--project` |
|--|--|--|
| Destination | `~/.claude/` | `./.claude/` |
| Available in | All projects | This project only |
| Content | CLAUDE.md + skill categories (interactive) | Skill categories + agents + commands + rules |

`./install.sh --all` does both.

## project-init.sh — what it generates

| File | Contents |
|------|----------|
| `CLAUDE.md` | Tech stack, build commands, auth arch, conventions |
| `01-project-structure.md` | Directory tree, packages, config files |
| `02-auth-flow.md` | Auth providers, token flow, roles |
| `03-api-contract.md` | Endpoints, request/response shapes, errors |
| `04-mobile-architecture.md` | RN/Flutter app structure (if applicable) |
| `05-media-pipeline.md` | Upload/processing/playback (if applicable) |
| `06-database-schema.md` | Tables, relations, naming conventions |
| `07-problems-found.md` | Security issues, bugs, tech debt found |
| `08-architecture-overview.md` | System map, service interactions, data flows |

Only creates files relevant to the actual project.

## Adding new skills

```bash
# Global skill (available everywhere):
mkdir global/skills/my-skill
# Add SKILL.md, commit and push

# Project skill (available per-project):
mkdir project/skills/my-skill
# Add SKILL.md
# Add the skill name to the appropriate category in PROJECT_CAT_SKILLS in install.sh
```

## Updating

```bash
git pull
./install.sh --all   # re-runs interactive selection
./plugins.sh
# GSD update inside Claude Code:
# /gsd:update
```
