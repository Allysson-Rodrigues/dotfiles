# --- ZINIT PACKAGE MANAGER (KEEP AT TOP) ---
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}%F{220}Installing %F{33}Zinit%F{220}...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || \
    print -P "%F{160}Zinit clone failed.%f"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- OH MY ZSH CORE ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

# IMPORTANT: Plugins must be defined BEFORE sourcing oh-my-zsh.sh
plugins=(
  git
  z
  node
  npm
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# --- SPACESHIP PROMPT CONFIGURATION ---
SPACESHIP_PROMPT_ORDER=(
  user dir host git node exec_time line_sep jobs exit_code char
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_NODE_SHOW=true
SPACESHIP_GIT_SHOW=true

# --- ASYNC PLUGINS VIA ZINIT ---
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# --- NAVIGATION & SYSTEM ALIASES ---
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'      # Windows-style clear command
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'

# Professional Navigation Aliases
# NOTE: Update paths below by running 'pwd' inside your project folders
alias projects='cd /home/allys/projetos'
alias template='cd /home/allys/projetos/node-express-template'

# --- ENHANCED GIT WORKFLOW ---
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all -n 10'
alias gco='git checkout'
alias gb='git branch'
alias gpl='git pull origin main'
alias gcm='git commit -m'
alias gst='git stash'
alias gpop='git stash pop'

# --- NODE.JS & NPM TOOLING ---
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'   # Start development server (nodemon)
alias start='npm start'

# --- DOCKER MANAGEMENT ---
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimgs='docker images'
alias dstop='docker stop $(docker ps -q)'

# --- UTILITY ALIASES ---
alias faxina="~/scripts/cleanup.sh"
alias gwatch='gh run watch'
alias gcheck='gh run list'
alias gview='gh run view --log'

# --- Docker Compose Aliases ---
alias dcu='docker-compose up -d'      # Sobe tudo em segundo plano
alias dcd='docker-compose down'      # Para e remove tudo (limpa a porta 5000)
alias dcl='docker-compose logs -f'   # Mostra os logs em tempo real
alias dcr='docker-compose restart'   # Reinicia os containers
alias dcs='docker-compose stop'      # Apenas pausa os containers
alias dcb='docker-compose up -d --build' # Reconstrói e sobe (útil se mudar o código) 


# --- ENVIRONMENT LOADERS ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
