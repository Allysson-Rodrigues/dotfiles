# 💻 Dotfiles | High-Performance Zsh Environment

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Zsh](https://img.shields.io/badge/Shell-Zsh-orange.svg)](https://www.zsh.org/)
[![WSL2](https://img.shields.io/badge/Platform-WSL2-blue.svg)](https://learn.microsoft.com/en-us/windows/wsl/)

Personal configuration files meticulously optimized for **Node.js** development, **Docker** orchestration, and a seamless professional workflow. Engineered specifically for **WSL2** and **GitHub Codespaces**.

> [!TIP]
> **Why this setup?** It balances speed (via Zinit's async loading) with a rich UI (Spaceship Prompt) to keep you productive without terminal lag.

---

## 🚀 Key Features

- **⚡ Zinit Package Manager:** High-speed, asynchronous plugin loading for a near-instant shell startup.
- **🚀 Spaceship Prompt:** A minimalist, powerful prompt highlighting Git status, Node.js versions, and Docker context.
- **🐳 DevOps Ready:** Custom aliases and functions tailored for Docker management and Node.js microservices.
- **🛠️ Automated Setup:** Idempotent `install.sh` script to bootstrap your environment in under a minute.

## 🛠️ Tech Stack & Plugins

| Tool                         | Purpose                                          |
| :--------------------------- | :----------------------------------------------- |
| **Zinit**                    | Turbo-charged plugin management                  |
| **Autosuggestions**          | Fish-like history suggestions                    |
| **Fast Syntax Highlighting** | Real-time command validation                     |
| **Completions**              | Advanced tab-completion for Git, Docker, and NPM |

---

## 🏁 Quick Start

### Prerequisites

Before installing, ensure you have `zsh` and `git` installed:

```bash
# Ubuntu/Debian/WSL
sudo apt update && sudo apt install zsh git -y
Note: For the icons to render correctly, it is highly recommended to use a Nerd Font (like FiraCode NF) in your terminal emulator.

Installation
Run the following one-liner to clone and deploy:

Bash
git clone [https://github.com/Allysson-Rodrigues/dotfiles.git](https://github.com/Allysson-Rodrigues/dotfiles.git) ~/dotfiles && cd ~/dotfiles && chmod +x install.sh && ./install.sh
📂 Structure
.zshrc - Main configuration and Zinit setup.

aliases.zsh - Productivity shortcuts for Git, Docker, and Node.

install.sh - Automated deployment script.

Maintained by Allysson Rodrigues
```
