#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installer — Symlink-based, idempotent, non-destructive
# Usage: ./install.sh [--dry-run]
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
CREATED_BACKUP=false

log()   { printf '\033[0;34m[INFO]\033[0m  %s\n' "$1"; }
warn()  { printf '\033[0;33m[WARN]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[0;32m[ OK ]\033[0m  %s\n' "$1"; }
skip()  { printf '\033[0;90m[SKIP]\033[0m  %s\n' "$1"; }

link_file() {
  local src="$1" dst="$2"

  if [[ -L "$dst" ]] && [[ "$(readlink -f "$dst")" == "$src" ]]; then
    skip "$dst → already linked"
    return
  fi

  if $DRY_RUN; then
    log "[DRY-RUN] Would link: $dst → $src"
    return
  fi

  # Backup existing file if it's not already a symlink to us
  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    if ! $CREATED_BACKUP; then
      mkdir -p "$BACKUP_DIR"
      CREATED_BACKUP=true
    fi
    local backup_path="$BACKUP_DIR/$(basename "$dst")"
    mv "$dst" "$backup_path"
    warn "Backed up: $dst → $backup_path"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  ok "$dst → $src"
}

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║       Dotfiles Installer v1.0        ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
$DRY_RUN && warn "Running in DRY-RUN mode (no changes will be made)"
echo ""

# --- Shell ---
log "Linking shell configs..."
link_file "$DOTFILES_DIR/shell/.zshrc"          "$HOME/.zshrc"
link_file "$DOTFILES_DIR/shell/.bashrc"         "$HOME/.bashrc"
link_file "$DOTFILES_DIR/shell/.bash_profile"   "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/shell/.shell_aliases"  "$HOME/.shell_aliases"
link_file "$DOTFILES_DIR/shell/.shell_env"      "$HOME/.shell_env"

# --- Git ---
log "Linking git configs..."
link_file "$DOTFILES_DIR/git/.gitconfig"        "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitmessage"       "$HOME/.gitmessage"

# --- App configs ---
log "Linking app configs..."
link_file "$DOTFILES_DIR/config/starship.toml"         "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/config/bat/config"            "$HOME/.config/bat/config"
link_file "$DOTFILES_DIR/config/ghostty/config"        "$HOME/.config/ghostty/config"
link_file "$DOTFILES_DIR/config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link_file "$DOTFILES_DIR/config/glow/glow.yml"         "$HOME/.config/glow/glow.yml"

# --- Systemd user units ---
log "Linking systemd user units..."
link_file "$DOTFILES_DIR/systemd/user/rclone-gdrive.service"   "$HOME/.config/systemd/user/rclone-gdrive.service"
link_file "$DOTFILES_DIR/systemd/user/restic-backup.service"   "$HOME/.config/systemd/user/restic-backup.service"
link_file "$DOTFILES_DIR/systemd/user/restic-backup.timer"     "$HOME/.config/systemd/user/restic-backup.timer"
link_file "$DOTFILES_DIR/systemd/user/gmail-maintenance.service" "$HOME/.config/systemd/user/gmail-maintenance.service"
link_file "$DOTFILES_DIR/systemd/user/gmail-maintenance.timer"   "$HOME/.config/systemd/user/gmail-maintenance.timer"

# --- Scripts ---
log "Linking scripts..."
link_file "$DOTFILES_DIR/scripts/backup-restic.sh"     "$HOME/.local/bin/backup-restic.sh"

echo ""
if $CREATED_BACKUP; then
  warn "Backups saved to: $BACKUP_DIR"
fi
ok "Dotfiles installation complete!"
echo ""
