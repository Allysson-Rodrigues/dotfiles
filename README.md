# ⚡ Allysson's Dotfiles

A performance-first, multidisciplinary development environment optimized for **Node.js** and **WSL2**.

## 🛠️ Tech Stack

- **Shell**: Zsh managed by **Zinit** (Performance-focused)
- **Prompt**: Spaceship (Node.js & Git optimized)
- **Editor**: VS Code (Zen Mode / High Performance config)
- **Symlinks**: Managed via **GNU Stow**

## 📂 Repository Structure

- `zsh/`: Advanced `.zshrc` with Zinit, autosuggestions, and syntax highlighting.
- `git/`: Global `.gitconfig` with custom aliases and identity.
- `vscode/`: `settings.json` optimized for low I/O overhead on WSL2.
- `editor/`: Global `.editorconfig` to enforce indent rules (2 spaces).
- `scripts/`: System maintenance and automation utilities.

## 🚀 Core Features

- **Conventional Commits Aliases**: Built-in support for `feat:`, `fix:`, `chore:`, etc.
- **Automated Cleanup**: Dedicated `faxina` script to purge system/npm caches.
- **Lazy Loading**: Plugins like NVM are deferred to ensure sub-second shell startup.
- **I/O Shielding**: Aggressive exclusion of `node_modules`, `dist`, and `build` from file watchers.

## ⚙️ Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/allyssons/dotfiles.git](https://github.com/allyssons/dotfiles.git) ~/dotfiles
   Navigate to the folder and use GNU Stow to link modules:
   ```

Bash
cd ~/dotfiles
stow zsh git vscode editor scripts
Restart your shell to trigger Zinit's automated installation.

Senior Mentor Note: Focus on Security > Correctness > Performance.

---

### Riscos e Próximos Passos

- **Risco de Segurança:** Evite adicionar chaves SSH ou arquivos `.env` privados a este repositório, pois ele é sua vitrine técnica pública.
- **Manutenção:** Sempre que adicionar uma nova ferramenta (ex: Docker, Databases), atualize a seção de "Tech Stack" no README.

\*\*Deseja que eu ajude a configurar uma Action no GitHub para validar se seu `settings.js
