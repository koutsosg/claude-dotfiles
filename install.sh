#!/usr/bin/env bash
# claude-dotfiles/install.sh
# Installs Claude Code skills, agents, commands, and rules.
#
# Usage:
#   ./install.sh --global    # copies global/ → ~/.claude/
#   ./install.sh --project   # copies project/ → .claude/ (current working dir)
#   ./install.sh --all       # both

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE=""

# ── Parse args ────────────────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --global)  MODE="global" ;;
    --project) MODE="project" ;;
    --all)     MODE="all" ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $0 --global | --project | --all"
      exit 1
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  echo "Usage: $0 --global | --project | --all"
  exit 1
fi

# ── Detect OS ─────────────────────────────────────────────────────────────────
case "$(uname -s)" in
  Darwin)  OS="mac" ;;
  Linux)   OS="linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
  *)       OS="unknown" ;;
esac
echo "Detected OS: $OS"

# ── Helper: backup + copy ─────────────────────────────────────────────────────
backup_and_copy() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "  Backing up: $dst → $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  cp -r "$src" "$dst"
}

copy_dir_contents() {
  local src_dir="$1"
  local dst_dir="$2"

  if [[ ! -d "$src_dir" ]]; then
    echo "  Skipping (not found): $src_dir"
    return
  fi

  mkdir -p "$dst_dir"

  for item in "$src_dir"/*/; do
    [[ -d "$item" ]] || continue
    local name
    name="$(basename "$item")"
    local dst="$dst_dir/$name"
    echo "  → $name"
    if [[ -d "$dst" ]]; then
      local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
      echo "    Backing up existing: $backup"
      mv "$dst" "$backup"
    fi
    cp -r "$item" "$dst"
  done
}

copy_file() {
  local src="$1"
  local dst="$2"
  if [[ ! -f "$src" ]]; then
    echo "  Skipping (not found): $src"
    return
  fi
  if [[ -f "$dst" ]]; then
    local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "  Backing up: $dst → $backup"
    mv "$dst" "$backup"
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "  → $(basename "$dst")"
}

# ── Global install ─────────────────────────────────────────────────────────────
install_global() {
  local claude_home="$HOME/.claude"
  echo ""
  echo "=== Installing global → $claude_home ==="

  echo "Skills:"
  copy_dir_contents "$DOTFILES_DIR/global/skills" "$claude_home/skills"

  echo "CLAUDE.md:"
  copy_file "$DOTFILES_DIR/global/CLAUDE.md" "$claude_home/CLAUDE.md"

  echo ""
  echo "Global install complete."
  echo "Restart Claude Code to load updated skills."
}

# ── Project install ────────────────────────────────────────────────────────────
install_project() {
  local project_dir
  project_dir="$(pwd)"
  local claude_dir="$project_dir/.claude"

  echo ""
  echo "=== Installing project → $claude_dir ==="

  echo "Skills:"
  copy_dir_contents "$DOTFILES_DIR/project/skills" "$claude_dir/skills"

  echo "Agents:"
  copy_dir_contents "$DOTFILES_DIR/project/agents" "$claude_dir/agents"

  echo "Commands:"
  for f in "$DOTFILES_DIR/project/commands"/*.md; do
    [[ -f "$f" ]] || continue
    copy_file "$f" "$claude_dir/commands/$(basename "$f")"
  done

  echo "Rules:"
  for f in "$DOTFILES_DIR/project/rules"/*.md; do
    [[ -f "$f" ]] || continue
    copy_file "$f" "$claude_dir/rules/$(basename "$f")"
  done

  echo ".gitignore (multi-service template):"
  local gitignore="$project_dir/.gitignore"
  if [[ ! -f "$gitignore" ]]; then
    cp "$DOTFILES_DIR/project/templates/gitignore-multi-service" "$gitignore"
    echo "  → .gitignore (created — add your service folder names at the top)"
  else
    echo "  → .gitignore already exists, skipping"
  fi

  echo ""
  echo "Project install complete."
  echo "Restart Claude Code to load updated skills/agents/commands/rules."
  echo ""
  echo "Next steps:"
  echo "  1. Run ./project-init.sh to generate CLAUDE.md + project knowledge"
  echo "  2. Run ./plugins.sh to install Claude plugins"
}

# ── Dispatch ───────────────────────────────────────────────────────────────────
case "$MODE" in
  global)
    install_global
    ;;
  project)
    install_project
    ;;
  all)
    install_global
    install_project
    ;;
esac
