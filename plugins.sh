#!/usr/bin/env bash
# claude-dotfiles/plugins.sh
# Installs Claude Code plugins and npm LSP packages.
#
# Usage:
#   ./plugins.sh             # installs all plugins
#   ./plugins.sh --npm-only  # only npm packages (LSP servers)
#   ./plugins.sh --plugins-only  # only Claude plugins

set -euo pipefail

MODE="all"

for arg in "$@"; do
  case "$arg" in
    --npm-only)     MODE="npm" ;;
    --plugins-only) MODE="plugins" ;;
    --all)          MODE="all" ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $0 [--npm-only | --plugins-only | --all]"
      exit 1
      ;;
  esac
done

# ── Claude plugins ─────────────────────────────────────────────────────────────
install_plugins() {
  echo ""
  echo "=== Installing Claude plugins ==="

  # Workflow & git
  claude plugin install feature-dev         # /feature-dev — 7-phase guided feature development
  claude plugin install commit-commands     # /commit, /commit-push-pr, /clean_gone
  claude plugin install pr-review-toolkit   # /review-pr — 6-agent PR review

  # Security
  claude plugin install security-guidance   # auto security hooks

  # LSP integration (requires LSP servers below)
  claude plugin install typescript-lsp      # TypeScript/JS IntelliSense
  claude plugin install php-lsp            # PHP IntelliSense (WordPress)

  # AWS (marketplace: zxkane/aws-skills — cdk, serverless, cost-ops, agentic-ai)
  claude plugin marketplace add zxkane/aws-skills
  claude plugin install aws-common@aws-skills
  claude plugin install aws-cdk@aws-skills
  claude plugin install aws-cost-ops@aws-skills
  claude plugin install serverless-eda@aws-skills
  claude plugin install aws-agentic-ai@aws-skills

  # Design & UI
  claude plugin install frontend-design    # production-grade UI skill για web components/pages

  # Plugin development
  claude plugin install plugin-dev         # /plugin-dev:create-plugin — δημιουργία custom plugins

  # Custom hooks
  claude plugin install hookify            # /hookify — custom hooks για workflow automation

  # DevOps (marketplace: ahmedasmar/devops-claude-skills — Terraform, AWS cost, CI/CD, SRE)
  claude plugin marketplace add https://github.com/ahmedasmar/devops-claude-skills
  claude plugin install iac-terraform@devops-skills      # Terraform + Terragrunt, modules, state
  claude plugin install aws-cost-optimization@devops-skills  # S3/Lambda FinOps
  claude plugin install ci-cd@devops-skills              # GitHub Actions, GitLab CI, pipeline security
  npx skills add https://github.com/jeffallan/claude-skills --skill sre-engineer  # SLO/monitoring/incident response

  echo ""
  echo "Plugin install complete. Run: claude plugin list"
}

# ── MCP Servers ────────────────────────────────────────────────────────────────
install_mcp() {
  echo ""
  echo "=== Installing MCP servers ==="

  # Context7 — live library documentation (Expo, Strapi, Next.js, etc.)
  claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp
  echo "  context7: live docs for any library (use 'use context7' in prompts)"

  echo ""
  echo "MCP install complete. Restart Claude Code to activate."
  echo ""
  echo "Optional (requires account):"
  echo "  Figma MCP: claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp"
  echo "  NotebookLM: python -m pip install 'notebooklm-py[browser]' --user && notebooklm login"
}

# ── npm LSP servers ────────────────────────────────────────────────────────────
install_npm() {
  echo ""
  echo "=== Installing npm LSP servers (global) ==="

  npm install -g typescript-language-server typescript
  npm install -g intelephense

  echo ""
  echo "npm install complete."
}

# ── GSD (Get Shit Done) ────────────────────────────────────────────────────────
install_gsd_note() {
  echo ""
  echo "=== GSD (Get Shit Done) ==="
  echo "GSD is self-managed — do NOT install manually."
  echo "Inside any Claude Code session, run: /gsd:update"
  echo "This installs/updates all gsd:* skills, agents, hooks, and commands."
}

# ── Dispatch ───────────────────────────────────────────────────────────────────
case "$MODE" in
  plugins)
    install_plugins
    install_mcp
    install_gsd_note
    ;;
  npm)
    install_npm
    ;;
  all)
    install_plugins
    install_npm
    install_mcp
    install_gsd_note
    ;;
esac
