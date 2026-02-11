#!/bin/bash
# ======================================================
# 🧹 SCRIPT DE FAXINA (WSL2 + NODE.JS)
# ======================================================

echo "🚀 Iniciando faxina no sistema..."

# 1. Limpeza de pacotes do sistema (Debian/Ubuntu)
echo "📦 Limpando pacotes do sistema..."
sudo apt update -y && sudo apt autoremove -y && sudo apt autoclean -y

# 2. Limpeza de cache do NPM
echo "🟢 Limpando cache do NPM..."
npm cache clean --force

# 3. Remoção de dumps de completion do Zsh (força reconstrução do cache)
echo "🐚 Limpando caches do Zsh..."
rm -f ~/.zcompdump*
rm -rf ~/.zcompcache/*

# 4. Limpeza de arquivos temporários e logs antigos
echo "📁 Removendo arquivos temporários..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

echo "✅ Faxina concluída com sucesso!"
