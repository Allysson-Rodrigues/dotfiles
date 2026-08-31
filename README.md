# 🏠 Dotfiles

Personal development environment configuration for **Fedora Workstation**.

Managed with symlinks for clean separation between repo and system files.

## Stack

| Category | Tools |
|---|---|
| **Shell** | Zsh + [Starship](https://starship.rs) prompt |
| **Terminal** | [Ghostty](https://ghostty.org) (Wayland-native) |
| **Editor** | VS Code |
| **Font** | JetBrainsMono Nerd Font |
| **Modern CLI** | eza, bat, ripgrep, fd, fzf, zoxide, delta, glow |
| **Version Mgmt** | fnm (Node.js), pnpm |
| **Containers** | Podman (rootless) |
| **Cloud** | Google Cloud SDK, Rclone (GDrive mount) |
| **Backup** | Restic (daily, automated via systemd timer) + Rclone offsite sync |
| **VCS** | Git + delta (side-by-side diffs) + SSH commit signing |

## Structure

```
dotfiles/
├── shell/           # Zsh, Bash, shared env & aliases
├── git/             # Git config & commit template
├── config/          # App configs (starship, bat, ghostty, fastfetch, glow)
├── systemd/user/    # Systemd user units (backup timer, GDrive mount)
├── scripts/         # Operational scripts (backup)
├── install.sh       # Symlink installer (idempotent, backs up existing files)
├── .editorconfig    # Editor defaults
└── .gitignore       # Security-hardened ignore rules
```

## Installation

```bash
# Clone
git clone git@github.com:Allysson-Rodrigues/dotfiles.git ~/dotfiles

# Preview changes (no modifications)
./install.sh --dry-run

# Install symlinks (backs up existing files automatically)
./install.sh
```

## Security

The `.gitignore` is hardened to prevent accidental exposure of:

- SSH keys and authorized files
- GPG keyrings
- OAuth tokens and credentials
- Shell history
- Password files
- Environment secrets (`.env*`)

> **Never commit secrets.** The gitignore acts as a safety net, but always review `git status` before committing.

## Highlights

- **Shell parity**: Shared `~/.shell_env` ensures Bash and Zsh have identical environment variables
- **FZF cached init**: Shell startup avoids forking a subshell on every new terminal
- **Zoxide native cd**: Replaces `cd` natively with `zoxide init --cmd cd`
- **Zcompdump bytecode**: Compiled in background for faster Zsh startup
- **Restic + Rclone**: Daily automated local backup with offsite Google Drive replication
- **Delta hyperlinks**: `git diff` outputs are clickable in VS Code
- **SSH commit signing**: Modern Ed25519 signing without GPG complexity

## License

[MIT](LICENSE)
