#!/bin/bash
# Restic automated backup script with Google Drive offsite replication
set -euo pipefail

export RESTIC_REPOSITORY="$HOME/backups-restic"
export RESTIC_PASSWORD_FILE="$HOME/.config/restic/password"

# Notification helper for desktop alerts
notify() {
  local urgency="$1"
  local title="$2"
  local msg="$3"
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -u "$urgency" -a "Restic Backup" "$title" "$msg" 2>/dev/null || true
  fi
}

on_error() {
  local exit_code=$?
  local line_no=$1
  echo "ERROR: Backup failed at line $line_no with exit code $exit_code"
  notify "critical" "⚠️ Backup Restic Falhou!" "Falha na linha $line_no (código: $exit_code). Verifique os logs."
}

trap 'on_error $LINENO' ERR

# Verificar se o arquivo de senha existe
if [ ! -f "$RESTIC_PASSWORD_FILE" ]; then
  echo "ERROR: Password file not found at $RESTIC_PASSWORD_FILE"
  notify "critical" "⚠️ Backup Restic Falhou!" "Arquivo de senha não encontrado: $RESTIC_PASSWORD_FILE"
  exit 1
fi

# Backup de diretórios e configs importantes
BACKUP_TARGETS=(
  "$HOME/Documentos"
  "$HOME/dotfiles"
  "$HOME/gmail-organizer"
  "$HOME/.config"
  "$HOME/.ssh"
  "$HOME/.zshrc"
  "$HOME/.shell_aliases"
  "$HOME/.shell_env"
)

# Configurações de agentes de IA
[[ -d "$HOME/.gemini/config" ]] && BACKUP_TARGETS+=("$HOME/.gemini/config")
[[ -d "$HOME/.gemini/policies" ]] && BACKUP_TARGETS+=("$HOME/.gemini/policies")
[[ -f "$HOME/.gemini/settings.json" ]] && BACKUP_TARGETS+=("$HOME/.gemini/settings.json")
[[ -f "$HOME/.codex/config.toml" ]] && BACKUP_TARGETS+=("$HOME/.codex/config.toml")
[[ -f "$HOME/.codex/hooks.json" ]] && BACKUP_TARGETS+=("$HOME/.codex/hooks.json")

# Adicionar workspace governado se disponível no host
if [ -d "/mnt/dados/Workspace/workspace" ]; then
  BACKUP_TARGETS+=("/mnt/dados/Workspace/workspace")
fi

restic backup \
  "${BACKUP_TARGETS[@]}" \
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
  --exclude='venv' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
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
  notify "normal" "✅ Backup Restic Concluído" "Backup local e sincronização offsite (Google Drive) finalizados com sucesso!"
else
  echo "WARNING: Rclone 'gdrive:' remote not configured. Skipping offsite sync."
  echo "Run 'rclone config' to set up Google Drive, then re-run this script."
  notify "normal" "✅ Backup Restic Concluído (Local)" "Backup local finalizado com sucesso. (Sincronização offsite pendente de configuração)."
fi
