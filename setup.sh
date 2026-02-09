#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dev-env-backup"
MANIFEST="$BACKUP_DIR/manifest.txt"

# Map: repo path -> target path
declare -a CONFIG_SOURCES=(
  "configs/zsh/.zshrc"
  "configs/zsh/.zprofile"
  "configs/zsh/.bashrc"
  "configs/starship/starship.toml"
  "configs/ghostty/config"
  "configs/git/.gitconfig"
  "configs/git/ignore"
  "configs/launchagents/com.ollama.server.plist"
)
declare -a CONFIG_TARGETS=(
  "$HOME/.zshrc"
  "$HOME/.zprofile"
  "$HOME/.bashrc"
  "$HOME/.config/starship.toml"
  "$HOME/.config/ghostty/config"
  "$HOME/.gitconfig"
  "$HOME/.config/git/ignore"
  "$HOME/Library/LaunchAgents/com.ollama.server.plist"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

usage() {
  echo "Usage: ./setup.sh <command>"
  echo ""
  echo "Commands:"
  echo "  install [--with-vimzap]   Link config files (+ optional VimZap)"
  echo "  uninstall                 Remove symlinks, restore backups, zero traces"
  echo "  status                    Show what's linked and what's not"
}

log_manifest() {
  echo "$1" >> "$MANIFEST"
}

do_install() {
  local with_vimzap=false
  if [[ "${1:-}" == "--with-vimzap" ]]; then
    with_vimzap=true
  fi

  mkdir -p "$BACKUP_DIR"
  : > "$MANIFEST" # reset manifest

  echo "Installing dev-env configs..."
  echo ""

  for i in "${!CONFIG_SOURCES[@]}"; do
    local src="$REPO_DIR/${CONFIG_SOURCES[$i]}"
    local target="${CONFIG_TARGETS[$i]}"

    # Check source exists
    if [[ ! -f "$src" ]]; then
      echo -e "  ${YELLOW}SKIP${NC} ${CONFIG_SOURCES[$i]} (source not found)"
      continue
    fi

    # Already correct symlink
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$src" ]]; then
      echo -e "  ${GREEN}OK${NC}   $target (already linked)"
      log_manifest "link:$target"
      continue
    fi

    # Create parent dir if needed
    mkdir -p "$(dirname "$target")"

    # Back up existing file (not symlink)
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
      local backup_path="$BACKUP_DIR/$(basename "$target").$(date +%s)"
      cp "$target" "$backup_path"
      log_manifest "backup:$target:$backup_path"
      echo -e "  ${YELLOW}BACKUP${NC} $target -> $backup_path"
      rm "$target"
    elif [[ -L "$target" ]]; then
      # Remove stale symlink
      rm "$target"
    fi

    ln -s "$src" "$target"
    log_manifest "link:$target"
    echo -e "  ${GREEN}LINK${NC}  $target -> $src"
  done

  echo ""

  # Load LaunchAgents
  echo "Loading LaunchAgents..."
  local plist_path="$HOME/Library/LaunchAgents/com.ollama.server.plist"
  if [[ -L "$plist_path" ]]; then
    launchctl load "$plist_path" 2>/dev/null || true
    echo -e "  ${GREEN}LOADED${NC} Ollama service"
  fi

  echo ""
  echo "Done."

  if $with_vimzap; then
    echo ""
    echo "Installing VimZap..."
    curl -fsSL https://raw.githubusercontent.com/IFAKA/VimZap/main/install.sh | bash
  fi
}

do_uninstall() {
  if [[ ! -f "$MANIFEST" ]]; then
    echo "Nothing to uninstall (no manifest found at $MANIFEST)."
    return
  fi

  echo "Uninstalling dev-env configs..."
  echo ""

  # Unload LaunchAgents first
  local plist_path="$HOME/Library/LaunchAgents/com.ollama.server.plist"
  if [[ -L "$plist_path" ]]; then
    launchctl unload "$plist_path" 2>/dev/null || true
    echo -e "  ${RED}UNLOAD${NC} Ollama service"
  fi

  local restored=0
  local removed=0

  # Process manifest in reverse so we undo in order
  while IFS= read -r line; do
    case "$line" in
      link:*)
        local target="${line#link:}"
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$REPO_DIR/"* ]]; then
          rm "$target"
          ((removed++))
          echo -e "  ${RED}UNLINK${NC} $target"
        fi
        ;;
    esac
  done < "$MANIFEST"

  # Restore backups
  while IFS= read -r line; do
    case "$line" in
      backup:*)
        local rest="${line#backup:}"
        local target="${rest%%:*}"
        local backup_path="${rest#*:}"
        if [[ -f "$backup_path" ]] && [[ ! -e "$target" ]]; then
          mkdir -p "$(dirname "$target")"
          cp "$backup_path" "$target"
          ((restored++))
          echo -e "  ${GREEN}RESTORE${NC} $target (from $backup_path)"
        fi
        ;;
    esac
  done < "$MANIFEST"

  # Clean up backup dir
  rm -rf "$BACKUP_DIR"

  echo ""
  echo "Done. Removed $removed symlinks, restored $restored backups."
  echo "Backup directory cleaned up."
}

do_status() {
  echo "dev-env status:"
  echo ""

  for i in "${!CONFIG_SOURCES[@]}"; do
    local src="$REPO_DIR/${CONFIG_SOURCES[$i]}"
    local target="${CONFIG_TARGETS[$i]}"

    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$src" ]]; then
      echo -e "  ${GREEN}LINKED${NC}     $target"
    elif [[ -L "$target" ]]; then
      echo -e "  ${RED}CONFLICT${NC}   $target (symlink to $(readlink "$target"))"
    elif [[ -e "$target" ]]; then
      echo -e "  ${YELLOW}NOT LINKED${NC} $target (file exists, not managed)"
    else
      echo -e "  ${YELLOW}NOT LINKED${NC} $target (missing)"
    fi
  done
}

case "${1:-}" in
  install)
    do_install "${2:-}"
    ;;
  uninstall)
    do_uninstall
    ;;
  status)
    do_status
    ;;
  *)
    usage
    exit 1
    ;;
esac
