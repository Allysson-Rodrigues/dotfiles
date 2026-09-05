#!/bin/bash
# Restic automated backup script with Google Drive offsite replication
set -euo pipefail

export RESTIC_REPOSITORY="$HOME/backups-restic"
export RESTIC_PASSWORD_FILE="$HOME/.config/restic/password"

# Verificar se o arquivo de senha existe
if [ ! -f "$RESTIC_PASSWORD_FILE" ]; then
  echo "ERROR: Password file not found at $RESTIC_PASSWORD_FILE"
  exit 1
fi

# Backup de diretórios importantes
restic backup \
  ~/Documentos \
  ~/.config ~/.ssh ~/.zshrc ~/.shell_aliases ~/.shell_env \
  /mnt/dados/Workspace/workspace \
  --exclude-caches \
  --exclude='*.cache' \
  --exclude='.var' \
  --exclude='node_modules' \
  --exclude='.next' \
  --exclude='.turbo' \
  --exclude='.tmp' \
  --exclude='dist' \
  --exclude='build' \
  --exclude='target' \
  --exclude='.venv' \
  --exclude='__pycache__' \
  --exclude='04-archives/temp' \
  --tag auto \
  --verbose

# Manter: 7 diários, 4 semanais, 6 mensais
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

echo "Local backup completed at $(date)"

# --- Offsite replication to Google Drive via Rclone ---
RCLONE_BIN="$HOME/.local/bin/rclone"
GDRIVE_DEST="gdrive:backups-restic"

if [ -x "$RCLONE_BIN" ] && "$RCLONE_BIN" listremotes 2>/dev/null | grep -q "^gdrive:"; then
  echo "Syncing backup repository to Google Drive..."
  "$RCLONE_BIN" sync \
    "$RESTIC_REPOSITORY" \
    "$GDRIVE_DEST" \
    --transfers 4 \
    --checkers 8 \
    --fast-list \
    --log-level INFO
  echo "Offsite sync completed at $(date)"
else
  echo "WARNING: Rclone 'gdrive:' remote not configured. Skipping offsite sync."
  echo "Run 'rclone config' to set up Google Drive, then re-run this script."
fi
