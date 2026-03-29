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

# ── Merge settings-template.json → ~/.claude/settings.json ───────────────────
merge_settings() {
  local claude_home="$HOME/.claude"
  local template="$DOTFILES_DIR/global/settings-template.json"
  local target="$claude_home/settings.json"

  if [[ ! -f "$template" ]]; then
    echo "  Skipping (not found): $template"
    return
  fi

  mkdir -p "$claude_home"

  if [[ ! -f "$target" ]]; then
    cp "$template" "$target"
    echo "  → settings.json (created from template)"
    return
  fi

  # Merge: inject portable keys (enabledPlugins, alwaysThinkingEnabled) into
  # existing settings.json without touching GSD hooks or other runtime state.
  SETTINGS_TARGET="$target" SETTINGS_TEMPLATE="$template" node - <<'NODEEOF'
const fs = require('fs');
const target = process.env.SETTINGS_TARGET;
const template = process.env.SETTINGS_TEMPLATE;
const existing = JSON.parse(fs.readFileSync(target, 'utf8'));
const tmpl = JSON.parse(fs.readFileSync(template, 'utf8'));
if (tmpl.enabledPlugins)            existing.enabledPlugins = tmpl.enabledPlugins;
if (tmpl.alwaysThinkingEnabled !== undefined) existing.alwaysThinkingEnabled = tmpl.alwaysThinkingEnabled;
fs.writeFileSync(target, JSON.stringify(existing, null, 2) + '\n');
console.log('  → settings.json (merged portable settings)');
NODEEOF
}

# ── GSD install ────────────────────────────────────────────────────────────────
install_gsd() {
  echo ""
  echo "=== Installing GSD (Get Shit Done) ==="
  if command -v npx &>/dev/null; then
    npx get-shit-done-cc@latest --claude --global
    echo "  GSD installed globally."
  else
    echo "  npx not found — install Node.js first, then run:"
    echo "  npx get-shit-done-cc@latest --claude --global"
  fi
}

# ── Skill installer ────────────────────────────────────────────────────────────
install_skill() {
  local skill="$1"
  local src_dir="$2"
  local dst_dir="$3"
  local src="$src_dir/$skill"
  local dst="$dst_dir/$skill"
  [[ -d "$src" ]] || return
  mkdir -p "$dst_dir"
  echo "    → $skill"
  if [[ -d "$dst" ]]; then
    mv "$dst" "${dst}.bak.$(date +%Y%m%d_%H%M%S)"
  fi
  cp -r "$src" "$dst"
}

# ── Interactive picker for a single category ──────────────────────────────────
pick_category() {
  local category="$1"
  local skills_list="$2"
  local src_dir="$3"
  local dst_dir="$4"

  local available=()
  for skill in $skills_list; do
    [[ -d "$src_dir/$skill" ]] && available+=("$skill")
  done
  [[ ${#available[@]} -eq 0 ]] && return

  echo ""
  echo "  ── $category ──"
  local i=1
  for skill in "${available[@]}"; do
    printf "    [%2d] %s\n" "$i" "$skill"
    ((i++))
  done
  echo "    [ A] All"
  echo "    [ S] Skip"
  echo ""
  read -rp "  Select (e.g. 1 3 5 or A or S): " choices
  choices="${choices^^}"

  [[ "$choices" == *"S"* ]] && return

  if [[ "$choices" == *"A"* ]]; then
    for skill in "${available[@]}"; do
      install_skill "$skill" "$src_dir" "$dst_dir"
    done
    return
  fi

  for num in $choices; do
    if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#available[@]} )); then
      install_skill "${available[$((num-1))]}" "$src_dir" "$dst_dir"
    fi
  done
}

# ── Category selector ──────────────────────────────────────────────────────────
# Usage: select_skills_interactive "cat_names_varname" "cat_skills_varname" src dst
select_skills_interactive() {
  local -n _names="$1"
  local -n _skills="$2"
  local src_dir="$3"
  local dst_dir="$4"

  echo ""
  echo "  Select categories:"
  local i=1
  for name in "${_names[@]}"; do
    printf "  [%d] %s\n" "$i" "$name"
    ((i++))
  done
  echo "  [A] All categories (pick skills individually per category)"
  echo "  [X] Install everything (no prompts)"
  echo ""
  read -rp "  Enter choices (e.g. 1 3 or A or X): " cat_choices
  cat_choices="${cat_choices^^}"

  if [[ "$cat_choices" == *"X"* ]]; then
    copy_dir_contents "$src_dir" "$dst_dir"
    return
  fi

  local selected_idxs=()
  if [[ "$cat_choices" == *"A"* ]]; then
    for j in "${!_names[@]}"; do selected_idxs+=("$j"); done
  else
    for num in $cat_choices; do
      if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#_names[@]} )); then
        selected_idxs+=($((num - 1)))
      fi
    done
  fi

  for idx in "${selected_idxs[@]}"; do
    pick_category "${_names[$idx]}" "${_skills[$idx]}" "$src_dir" "$dst_dir"
  done
}

# ── Global skill categories ────────────────────────────────────────────────────
GLOBAL_CAT_NAMES=(
  "General"
  "Swift / Apple"
  "Mobile / Product"
  "Android / Kotlin"
)
GLOBAL_CAT_SKILLS=(
  "notebooklm skill-builder skill-design-guide ui-ux-pro-max"
  "swift swift-best-practices swift-modern-architecture swift-performance-optimization swift-speech-analyzer swift-unit-testing swiftui swiftui-pro swiftdata ios macos watchos visionos core-ml apple-intelligence app-store appstore-readiness developing-with-swift mapkit memory-leak-diagnosis"
  "design generators growth monetization legal release-review performance testing product shared foundation security"
  "android-kotlin android-clean-architecture android-jetpack-compose kotlin-specialist kotlin-coroutines-flows kotlin-patterns"
)

# ── Project skill categories ───────────────────────────────────────────────────
PROJECT_CAT_NAMES=(
  "Backend / API"
  "Security"
  "Testing"
  "Code Quality"
  "Agents / Meta"
)
PROJECT_CAT_SKILLS=(
  "api-design database-migrations postgres docker-patterns"
  "security-review owasp-security insecure-defaults codeql semgrep sarif-parsing sharp-edges"
  "test-driven-development e2e-testing playwright-skill verification-before-completion"
  "coding-standards systematic-debugging second-opinion finishing-a-development-branch using-git-worktrees changelog-generator app-store-specialist"
  "dispatching-parallel-agents subagent-driven-development"
)

# ── Global install ─────────────────────────────────────────────────────────────
install_global() {
  local claude_home="$HOME/.claude"
  echo ""
  echo "=== Installing global → $claude_home ==="

  echo "Skills:"
  select_skills_interactive GLOBAL_CAT_NAMES GLOBAL_CAT_SKILLS \
    "$DOTFILES_DIR/global/skills" "$claude_home/skills"

  echo "CLAUDE.md:"
  copy_file "$DOTFILES_DIR/global/CLAUDE.md" "$claude_home/CLAUDE.md"

  echo "settings.json:"
  merge_settings

  echo ""
  install_gsd

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
  select_skills_interactive PROJECT_CAT_NAMES PROJECT_CAT_SKILLS \
    "$DOTFILES_DIR/project/skills" "$claude_dir/skills"

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

  echo "Hookify rules:"
  for f in "$DOTFILES_DIR/project/hookify-rules"/hookify.*.local.md; do
    [[ -f "$f" ]] || continue
    copy_file "$f" "$claude_dir/$(basename "$f")"
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
  echo "  1. Run ./plugins.sh to install Claude plugins + GSD"
  echo "  2. Run ./project-init.sh to generate CLAUDE.md + project knowledge"
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
