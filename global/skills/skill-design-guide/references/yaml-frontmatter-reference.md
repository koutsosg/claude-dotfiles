# YAML Frontmatter Reference

## Required Fields

### name
- Type: string
- Format: kebab-case only (lowercase, hyphens)
- Must match the skill folder name
- No spaces, underscores, or capitals
- Cannot contain "claude" or "anthropic" (reserved)

```yaml
# Correct
name: notion-project-setup

# Wrong
name: My Cool Skill        # spaces and capitals
name: notion_project_setup  # underscores
name: NotionProjectSetup    # PascalCase
name: claude-helper         # reserved prefix
```

### description
- Type: string
- Maximum: 1024 characters
- No XML angle brackets (security restriction)
- Must include BOTH what the skill does AND when to use it

Structure: `[What it does] + [When to use it] + [Key capabilities]`

```yaml
# Good — specific, includes trigger phrases
description: Analyzes Figma design files and generates developer handoff
  documentation. Use when user uploads .fig files, asks for "design specs",
  "component documentation", or "design-to-code handoff".

# Good — clear value proposition with triggers
description: End-to-end customer onboarding workflow for PayFlow. Handles
  account creation, payment setup, and subscription management. Use when
  user says "onboard new customer", "set up subscription", or "create
  PayFlow account".

# Bad — too vague
description: Helps with projects.

# Bad — missing triggers
description: Creates sophisticated multi-page documentation systems.
```

## Optional Fields

### license
- Type: string
- Use for open-source skills
- Common values: MIT, Apache-2.0

```yaml
license: MIT
```

### compatibility
- Type: string
- Length: 1-500 characters
- Indicates environment requirements

```yaml
compatibility: Requires Claude Code with Bash access. Needs Python 3.10+.
```

### allowed-tools
- Type: string
- Restricts which tools the skill can use

```yaml
allowed-tools: "Bash(python:*) Bash(npm:*) WebFetch"
```

### metadata
- Type: object (key-value pairs)
- Any custom fields

```yaml
metadata:
  author: Company Name
  version: 1.0.0
  mcp-server: server-name
  category: productivity
  tags: [project-management, automation]
  documentation: https://example.com/docs
  support: support@example.com
```

## Complete Annotated Example

```yaml
---
name: linear-sprint-planner
description: >-
  Plans and manages sprints in Linear. Creates tasks, assigns team members,
  sets priorities, and tracks capacity. Use when user says "plan this sprint",
  "create sprint tasks", "set up sprint", or mentions Linear sprint workflows.
  Do NOT use for general project management unrelated to Linear.
license: MIT
compatibility: Requires Linear MCP server connection
metadata:
  author: DevTools Team
  version: 2.1.0
  mcp-server: linear
  category: project-management
  tags: [sprints, linear, agile]
---
```

## Security Rules

**Forbidden in frontmatter:**
- XML angle brackets (< >) — could inject instructions into system prompt
- Skills named with "claude" or "anthropic" prefix — reserved by Anthropic
- Code execution in YAML — uses safe YAML parsing

**Why these restrictions exist:** Frontmatter appears in Claude's system prompt.
Malicious content could inject instructions that override intended behavior.
