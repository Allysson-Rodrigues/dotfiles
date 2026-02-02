# --- Gerenciador de Plugins (Zinit)
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}Instalando Zinit...%f"
  command mkdir -p "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Hooks iniciais
autoload -Uz add-zsh-hook
unsetopt nomatch

# --- Oh My Zsh & Tema
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git) # O essencial. Plugins pesados carregamos via Zinit abaixo.

source $ZSH/oh-my-zsh.sh

# Customização do Spaceship Prompt
SPACESHIP_PROMPT_ORDER=(user dir host git node exec_time line_sep jobs exit_code char)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_NODE_SHOW=true

# --- Plugins de Performance (Zinit)
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# NVM com lazy load (terminal abre instantâneo)
zinit ice wait"0" lucid nocompletions
zinit light lukechilds/zsh-nvm
export ZSH_NVM_AUTOLOAD=true

# Zoxide (Navegação inteligente)
eval "$(zoxide init zsh)"

# --- Atalhos (Aliases)

# Navegação e Sistema
# ======================================================
# 📦 ZINIT PACKAGE MANAGER
# ======================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}%F{220}Installing %F{33}Zinit%F{220}...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Hooks e Comandos Iniciais
autoload -Uz add-zsh-hook
unsetopt nomatch # Previne o erro 'no match found' em comandos curtos

# ======================================================
# 🏛️ OH MY ZSH CORE & THEME
# ======================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Estética Spaceship
SPACESHIP_PROMPT_ORDER=(dir git node char)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL=">"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_NODE_SHOW=true
SPACESHIP_GIT_STATUS_SHOW=false
RPROMPT=""

# ======================================================
# 🔌 PLUGIN LOADER (ZINIT)
# ======================================================
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# ======================================================
# ✅ COMPLETIONS & TOOLS
# ======================================================
autoload -Uz compinit && compinit -C

# Inicialização do Zoxide (Navegação Inteligente)
# Como já está instalado via apt, apenas inicializamos o hook
eval "$(zoxide init zsh)"

# NVM (Lazy Load para performance)
zinit ice wait"0" lucid nocompletions
zinit light lukechilds/zsh-nvm
export ZSH_NVM_AUTOLOAD=true

# ======================================================
# 🛠️ ALIASES (SISTEMA, NODE, DOCKER & GIT)
# ======================================================

# Navegação e Sistema (Usando Zoxide)
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear && printf "\n"'
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias projects='cd /home/allys/projetos'
alias template='cd /home/allys/projetos/node-express-template'

# Git Workflow (Essencial para seu Portfólio)
alias gstart='git init && git add . && git commit -m "chore: initial commit" && git checkout -b dev'
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push -u origin HEAD'
alias gl='git log --oneline --graph --all -n 10'
alias gpl='git pull --rebase'
# --- Git Branch Workflow ---
alias gb='git branch'
alias gcb='git checkout -b'     # criar branch
alias gco='git checkout'        # trocar branch
alias gcm='git checkout $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed "s@^origin/@@")'
alias gcd='git checkout dev'    # voltar pro dev
alias gbd='git branch -d'       # deletar branch
alias gdev='git show-ref --verify --quiet refs/heads/dev && git checkout dev || git checkout -b dev'
alias gss='git status -sb'


# Node.js & NPM (Foco no seu aprendizado Backend)
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'
alias start='npm start'
alias node-reset='rm -rf node_modules package-lock.json && npm install'
alias nuke-modules='find . -name "node_modules" -type d -prune -exec rm -rf "{}" +'

# Docker & Containers (Configuração de Elite)
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcb='docker-compose up -d --build'
alias d-clean='docker system prune -a --volumes'

# Diagnóstico
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias myip="hostname -I | awk '{print \$1}'"

# --- UTILITY ALIASES ---
alias faxina="~/scripts/cleanup.sh"
alias gwatch='gh run watch'
alias gcheck='gh run list'
alias gview='gh run view --log'

# ======================================================
# ✅ FIX VS CODE
# ======================================================
_vscode_prompt_fix_once() {
  [[ -n "$VSCODE_PID" ]] || return
  zle && zle reset-prompt 2>/dev/null
  add-zsh-hook -d precmd _vscode_prompt_fix_once
}
add-zsh-hook precmd _vscode_prompt_fix_once

# Carrega Aliases Customizados
if [ -f ~/dotfiles/aliases.zsh ]; then
    source ~/dotfiles/aliases.zsh
fi

# --- Finalização e Fixes
# Garante que o sistema de completions esteja pronto
if [[ -z "$_comp_dumpfile" ]]; then
  _comp_dumpfile="${ZDOTDIR:-$HOME}/.zcompdump"
fi
autoload -Uz compinit && compinit -C

# Fix para o prompt no terminal integrado do VS Code WSL
_vscode_prompt_fix_once() {
  [[ -n "$VSCODE_PID" ]] || return
  zle && zle reset-prompt 2>/dev/null
  add-zsh-hook -d precmd _vscode_prompt_fix_once
}
add-zsh-hook precmd _vscode_prompt_fix_once

# Arquivo para variáveis secretas ou locais (não vai para o Git)
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local
