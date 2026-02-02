# ======================================================
# 📦 ZINIT PACKAGE MANAGER (Bootstrap)
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

# Hooks Iniciais
autoload -Uz add-zsh-hook
unsetopt nomatch

# ======================================================
# 🏛️ OH MY ZSH CORE & THEME (Spaceship)
# ======================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

# Mantemos apenas o essencial no OMZ; o resto carregamos via Zinit para performance
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Configuração Spaceship (Removido duplicatas e otimizado)
SPACESHIP_PROMPT_ORDER=(user dir host git node exec_time line_sep jobs exit_code char)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_NODE_SHOW=true
SPACESHIP_GIT_SHOW=true

# ======================================================
# 🔌 PLUGIN LOADER (ZINIT)
# ======================================================
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# NVM (Lazy Load)
zinit ice wait"0" lucid nocompletions
zinit light lukechilds/zsh-nvm
export ZSH_NVM_AUTOLOAD=true

# Zoxide (Substitui o plugin 'z' com mais inteligência)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# ======================================================
# 🛠️ ALIASES (PORTÁTEIS)
# ======================================================

# Navegação (Usando $HOME para portabilidade)
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias projects='cd $HOME/projetos'
alias template='cd $HOME/projetos/node-express-template'

# Git Workflow
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all -n 10'
alias gpl='git pull --rebase'

# Node.js & NPM
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'
alias start='npm start'
alias node-reset='rm -rf node_modules package-lock.json && npm install'
alias nuke-modules='find . -name "node_modules" -type d -prune -exec rm -rf "{}" +'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcb='docker-compose up -d --build'
alias d-clean='docker system prune -a --volumes'

# Diagnóstico e Utilidades
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias myip="hostname -I | awk '{print \$1}'"
alias faxina="[ -f ~/scripts/cleanup.sh ] && ~/scripts/cleanup.sh"

# ======================================================
# ✅ FIXES & FINALIZAÇÃO
# ======================================================
autoload -Uz compinit && compinit -C

# VS Code Prompt Fix (Essencial para WSL)
_vscode_prompt_fix_once() {
  [[ -n "$VSCODE_PID" ]] || return
  zle && zle reset-prompt 2>/dev/null
  add-zsh-hook -d precmd _vscode_prompt_fix_once
}
add-zsh-hook precmd _vscode_prompt_fix_once

# Carregar variáveis locais (Se existirem, para não expor chaves no GitHub)
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local
