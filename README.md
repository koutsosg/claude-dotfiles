# claude-dotfiles

Portable Claude Code setup — skills, agents, commands, rules, and install scripts.
Clone on any machine (Windows/Mac/Linux) and be productive in minutes.

## What's included

```
claude-dotfiles/
├── global/                      # → ~/.claude/
│   ├── CLAUDE.md                # Global rules (Greek, npm, functional TS, no auto-commit)
│   ├── settings-template.json   # Portable settings (enabledPlugins, alwaysThinkingEnabled)
│   └── skills/
│       ├── notebooklm/          # Google NotebookLM CLI skill
│       ├── skill-builder/       # Meta-skill: create new skills
│       ├── skill-design-guide/  # Meta-skill: skill design patterns
│       └── ui-ux-pro-max/       # UI/UX design (50 styles, React/RN/Flutter)
│
└── project/                     # → .claude/ in any project
    ├── skills/                  # 24 generic skills (manually managed)
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
| GSD (Get Shit Done) — 30+ gsd:* skills | `npx get-shit-done-cc@latest --claude --global` (first install — auto-run by `./install.sh --global`) |
| feature-dev, commit-commands, pr-review-toolkit | `./plugins.sh` |
| security-guidance, typescript-lsp, php-lsp | `./plugins.sh` |
| aws-skills (CDK, serverless, cost-ops, AgentCore) | `./plugins.sh` |
| devops-claude-skills (Terraform, AWS cost, CI/CD) | `./plugins.sh` |
| sre-engineer (SLO, monitoring, incident response) | `./plugins.sh` |
| frontend-design — production UI skill | `./plugins.sh` |
| plugin-dev — create custom plugins | `./plugins.sh` |
| hookify — custom workflow hooks | `./plugins.sh` |
| npm LSP servers (typescript-language-server, intelephense) | `./plugins.sh` |
| **Context7 MCP** — live library docs (auto-installed by plugins.sh) | `./plugins.sh` |
| **NotebookLM** (optional) — Google NotebookLM CLI | `pip install notebooklm-py[browser]` + `notebooklm login` |
| **Figma MCP** (optional) — Figma → code (requires paid Figma seat) | `claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp` |

## Quick install

```bash
git clone https://github.com/YOUR_USERNAME/claude-dotfiles.git
cd claude-dotfiles
chmod +x install.sh plugins.sh project-init.sh

# Install global skills + CLAUDE.md + settings.json + GSD (auto)
./install.sh --global

# Install Claude plugins + LSP servers
./plugins.sh
```

## Installing into a project

```bash
# From the project root:
/path/to/claude-dotfiles/install.sh --project
```

This copies skills, agents, commands, and rules into `.claude/` in the current directory.

Then generate project-specific documentation:

```bash
/path/to/claude-dotfiles/project-init.sh
```

This launches Claude to analyze the codebase and create:
- `CLAUDE.md` — project guide (tech stack, commands, conventions)
- `.claude/project-knowledge/` — deep architecture docs (auth, API, DB, media pipeline, etc.)

## Global vs project install

| | `--global` | `--project` |
|--|--|--|
| Destination | `~/.claude/` | `./.claude/` |
| Available in | All projects | This project only |
| Content | CLAUDE.md + 3 meta-skills | 25 skills + agents + commands + rules |

`./install.sh --all` does both.

## project-init.sh — what it generates

When run in a new project, Claude will create:

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

Only creates files relevant to the actual project. Use `--dry-run` to preview the prompt.

## Adding new skills

```bash
# Create the skill in project/skills/my-skill/
mkdir project/skills/my-skill
# Add SKILL.md with frontmatter (name, description)
# Commit and push
```

## Updating

```bash
git pull
./install.sh --all   # re-installs everything
# For plugins:
./plugins.sh
# For GSD inside Claude:
# /gsd:update
```
