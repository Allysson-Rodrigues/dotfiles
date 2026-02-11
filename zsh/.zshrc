# ======================================================
# 📦 ZINIT PACKAGE MANAGER (KEEP AT TOP)
# ======================================================
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}%F{220}Installing %F{33}Zinit%F{220}...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" || \
    print -P "%F{160}Zinit clone failed.%f"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

autoload -Uz add-zsh-hook

# Safety: don't error on no-match globs
unsetopt nomatch

# ======================================================
# 🗂️ HISTORY (PROFISSIONAL)
# ======================================================
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history

# ======================================================
# 🏛️ OH MY ZSH CORE & THEME (SPACESHIP)
# ======================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

SPACESHIP_PROMPT_ORDER=(dir git node char)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL=">"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_NODE_SHOW=true
SPACESHIP_GIT_STATUS_SHOW=false
RPROMPT=""

# ======================================================
# 🔌 PLUGINS (ZINIT)
# ======================================================
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# ======================================================
# ✅ COMPLETIONS (AFTER zsh-completions)
# ======================================================
# Cache de completion (perf + estabilidade)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompcache

autoload -Uz compinit
compinit -C

# ======================================================
# 🧰 TOOLS
# ======================================================
# zoxide (if installed)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# NVM via zsh-nvm (deferred)
zinit ice wait"0" lucid nocompletions
zinit light lukechilds/zsh-nvm
export ZSH_NVM_AUTOLOAD=true

# ======================================================
# 🛠️ ALIASES (SISTEMA, NODE, DOCKER & GIT)
# ======================================================

# Navegação e Sistema
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear && printf "\n"'
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias projects='cd "$HOME/projetos"'
alias template='cd "$HOME/projetos/node-express-template"'

# Diagnóstico
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias myip="hostname -I | awk '{print \$1}'"

# ------------------------------------------------------
# Git Workflow
# ------------------------------------------------------
alias g='git'
alias gs='git status'
alias gss='git status -sb'
alias ga='git add .'

# Evita conflito: gc do OMZ às vezes existe
unalias gc 2>/dev/null
alias gc='git commit'
alias gca='git commit --amend'

alias gl='git log --oneline --graph --all -n 10'
alias gpl='git pull --rebase'
alias gp='git push -u origin HEAD'

# ------------------------------------------------------
# Conventional Commits (feat/fix/docs/...)
# ------------------------------------------------------
alias gfeat='git commit -m "feat: "'
alias gfix='git commit -m "fix: "'
alias gdocs='git commit -m "docs: "'
alias gstyle='git commit -m "style: "'
alias grefactor='git commit -m "refactor: "'
alias gperf='git commit -m "perf: "'
alias gtest='git commit -m "test: "'
alias gchore='git commit -m "chore: "'
alias gbuild='git commit -m "build: "'
alias gci='git commit -m "ci: "'

# Commits com escopo: tipo(escopo): mensagem
# uso: gscope feat api "adicionar paginação"
gscope() {
  local type="$1"
  local scope="$2"
  shift 2

  if [[ -z "$type" || -z "$scope" || -z "$*" ]]; then
    echo 'Uso: gscope <tipo> <escopo> "mensagem"'
    echo 'Ex:  gscope feat api "adicionar paginação"'
    return 1
  fi

  git commit -m "${type}(${scope}): $*"
}

# Atalhos para staged + commit por tipo (fluxo rápido)
alias gac='git add . && git status -sb'

alias gstart='git init && git add . && git commit -m "chore: initial commit" && git checkout -b dev'

alias gb='git branch'
alias gcb='git checkout -b'
alias gco='git checkout'

# Remove qualquer alias gcm (Oh My Zsh / dotfiles)
unalias gcm 2>/dev/null

# checkout para branch padrão do remoto (main/master)
gcm() {
  local def
  def=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
  def=${def#origin/}
  if [[ -n "$def" ]]; then
    git checkout "$def"
  else
    git checkout main 2>/dev/null || git checkout master
  fi
}

alias gcd='git checkout dev'
alias gbd='git branch -d'

# garante dev existente (se não existir, cria)
gdev() { git show-ref --verify --quiet refs/heads/dev && git checkout dev || git checkout -b dev; }

# GitHub CLI (só se existir)
if command -v gh >/dev/null 2>&1; then
  alias gwatch='gh run watch'
  alias gcheck='gh run list'
  alias gview='gh run view --log'
fi

# ------------------------------------------------------
# Node.js & NPM
# ------------------------------------------------------
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'
alias start='npm start'
alias node-reset='rm -rf node_modules package-lock.json && npm install'
alias nuke-modules='find . -name "node_modules" -type d -prune -exec rm -rf "{}" +'

# ------------------------------------------------------
# Docker & Containers
# ------------------------------------------------------
alias d='docker'

# docker compose compatível (v1 ou v2)
if command -v docker-compose >/dev/null 2>&1; then
  alias dc='docker-compose'
  alias dcu='docker-compose up -d'
  alias dcd='docker-compose down'
  alias dcb='docker-compose up -d --build'
else
  alias dc='docker compose'
  alias dcu='docker compose up -d'
  alias dcd='docker compose down'
  alias dcb='docker compose up -d --build'
fi

alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'

d-clean() {
  echo "Isso vai remover imagens/volumes não usados. Continuar? (y/N)"
  read -r ans
  [[ "$ans" == "y" ]] || return 1
  docker system prune -a --volumes
}

# Utility
alias faxina="~/scripts/cleanup.sh"

# ======================================================
# ✅ FIX VS CODE (reset prompt once)
# ======================================================
_vscode_prompt_fix_once() {
  [[ -n "$VSCODE_PID" ]] || return
  zle && zle reset-prompt 2>/dev/null
  add-zsh-hook -d precmd _vscode_prompt_fix_once
}
add-zsh-hook precmd _vscode_prompt_fix_once
