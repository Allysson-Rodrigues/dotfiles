# --- Gerenciador de Plugins (Zinit)
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}Instalando Zinit...%f"
  command mkdir -p "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- Oh My Zsh & Tema
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git) # Deixo só o git aqui, o resto vai pelo Zinit que é mais rápido

source $ZSH/oh-my-zsh.sh

# Ajustes do Spaceship Prompt
SPACESHIP_PROMPT_ORDER=(user dir host git node exec_time line_sep jobs exit_code char)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_NODE_SHOW=true

# --- Plugins (Zinit)
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# NVM com lazy load pra não travar o terminal ao abrir
zinit ice wait"0" lucid nocompletions
zinit light lukechilds/zsh-nvm
export ZSH_NVM_AUTOLOAD=true

# Zoxide (o melhor substituto pro 'cd')
eval "$(zoxide init zsh)"

# --- Atalhos (Aliases)

# Gerais e Navegação
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias projects='cd $HOME/projetos'
alias template='cd $HOME/projetos/node-express-template'

# Git
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all -n 10'
alias gpl='git pull --rebase'

# Node / NPM
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'
alias start='npm start'
alias node-reset='rm -rf node_modules package-lock.json && npm install'
alias nuke-modules='find . -name "node_modules" -type d -prune -exec rm -rf "{}" +'

# Docker stuff
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcb='docker-compose up -d --build'
alias d-clean='docker system prune -a --volumes'

# Úteis e Redes
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias myip="hostname -I | awk '{print \$1}'"

# --- Fixes e firulas finais
autoload -Uz compinit && compinit -C

# Corrige glitch de renderização no terminal do VS Code
_vscode_prompt_fix_once() {
  [[ -n "$VSCODE_PID" ]] || return
  zle && zle reset-prompt 2>/dev/null
  add-zsh-hook -d precmd _vscode_prompt_fix_once
}
add-zsh-hook precmd _vscode_prompt_fix_once

# Carregar configs locais (chaves de API, etc) sem subir pro Git
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local
