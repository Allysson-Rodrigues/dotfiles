#!/bin/bash
set -e

echo "Iniciando provisionamento do ambiente..."

# 1. Instalar dependências básicas
sudo apt update && sudo apt install -y stow curl git

# 2. Instalar NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# 3. Aplicar dotfiles via Stow
cd ~/dotfiles
stow zsh
stow git

echo "Ambiente configurado. Reinicie o terminal."
