# ======================================================
# 📦 ZINIT PACKAGE MANAGER (KEEP AT TOP)
# ======================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}%F{220}Installing %F{33}Zinit%F{220}...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || \
    print -P "%F{160}Zinit clone failed.%f"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

autoload -Uz add-zsh-hook
unsetopt nomatch

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
# 🔌 PLUGIN LOADER (ZINIT)
# ======================================================
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# ======================================================
# ✅ COMPLETIONS & TOOLS
# ======================================================
autoload -Uz compinit && compinit -C

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

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
unalias gc 2>/dev/null
alias gc='git commit'
alias gca='git commit --amend'

alias gl='git log --oneline --graph --all -n 10'
alias gpl='git pull --rebase'
alias gp='git push -u origin HEAD'

# ------------------------------------------------------
# Conventional Commits (feat/fix/docs/...)
# ------------------------------------------------------

# (opcional) mantenha gc para uso rápido, mas prefira os tipos abaixo
# alias gc='git commit -m'

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

# ✅ CORREÇÃO COMPLETA DO ERRO:
# Removemos QUALQUER alias gcm e usamos só FUNÇÃO (mais robusta).
# (Não crie alias gcm em outro lugar, senão vai conflitar de novo.)
gcm() {
  local def
  def="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')"
  if [[ -n "$def" ]]; then
    git checkout "$def"
  else
    git checkout main 2>/dev/null || git checkout master
  fi
}


alias gcd='git checkout dev'
alias gbd='git branch -d'

gdev() { git show-ref --verify --quiet refs/heads/dev && git checkout dev || git checkout -b dev; }

# GitHub CLI
alias gwatch='gh run watch'
alias gcheck='gh run list'
alias gview='gh run view --log'

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
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcb='docker-compose up -d --build'
alias d-clean='docker system prune -a --volumes'

# Utility
alias faxina="~/scripts/cleanup.sh"

# ======================================================
# 🤖 IA WORKFLOW (COM SEU ai.js + MODOS)
# ======================================================

export GEMINI_MODEL_FAST="gemini-2.5-flash"
export GEMINI_MODEL_PRO="gemini-2.5-pro"

# ✅ SEGURANÇA: carregar chave de arquivo separado
# Crie: ~/.secrets/gemini.env com: export GOOGLE_API_KEY="SUA_NOVA_CHAVE"
# Depois: chmod 600 ~/.secrets/gemini.env
if [[ -f "$HOME/.secrets/gemini.env" ]]; then
  source "$HOME/.secrets/gemini.env"
fi


alias ai='GEMINI_MODEL="$GEMINI_MODEL_FAST" node "$HOME/projetos/gemini-tool/ai.js"'
alias aipro='GEMINI_MODEL="$GEMINI_MODEL_PRO" node "$HOME/projetos/gemini-tool/ai.js"'


alias explain='ai "Explique de forma simples e curta:"'
alias refactor='aipro "Refatore e melhore (segurança, legibilidade, performance). Mostre patch/diff curto:"'

alias aidiff='git diff | aipro "Revise esse diff. Aponte bugs, riscos e melhorias. Se possível, mostre patch."'
alias aistaged='git diff --staged | aipro "Crie commit message Conventional Commits + resumo + checklist de testes."'

# Logs: uso -> comando 2>&1 | ailog
ailog() { tail -n 160 | ai "Explique o erro, causa raiz e passos práticos de correção." ; }

alias ai-tree='tree -I "node_modules|dist|.git|.env|.next|build|coverage"'

ai-file() {
  local file="$1"; shift
  if [[ -z "$file" || ! -f "$file" ]]; then
    echo 'Uso: ai-file <arquivo> "instrução"'
    return 1
  fi
  cat "$file" | aipro "${*:-"Explique este arquivo e sugira melhorias. Aponte riscos e edge cases."}"
}

ai-src() {
  find ./src -type f \( -name "*.js" -o -name "*.ts" -o -name "*.json" \) -size -200k -print0 \
    | xargs -0 -I {} sh -c 'echo "\n--- FILE: {} ---\n"; cat "{}"' \
    | aipro "${*:-"Analise o código do src. Encontre bugs, melhorias e sugira refatorações."}"
}

alias netcheck='ping -c 3 google.com && myip'

# ======================================================
# ✅ FIX VS CODE (reset prompt once)
# ======================================================
_vscode_prompt_fix_once() {
  [[ -n "$VSCODE_PID" ]] || return
  zle && zle reset-prompt 2>/dev/null
  add-zsh-hook -d precmd _vscode_prompt_fix_once
}
add-zsh-hook precmd _vscode_prompt_fix_once

# ======================================================
# 📎 DOTFILES EXTRAS
# ======================================================
# ⚠️ Importante: se aliases.zsh tiver "alias gcm=...", vai dar conflito!
# Remova qualquer alias gcm lá.
if [[ -f "$HOME/dotfiles/aliases.zsh" ]]; then
  source "$HOME/dotfiles/aliases.zsh"
fi
