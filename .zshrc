# --- ZINIT (MANTER NO TOPO) ---
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}%F{220}Installing %F{33}Zinit%F{220}...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || \
    print -P "%F{160}Zinit clone failed.%f"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# --- FIM ZINIT ---

# --- OH MY ZSH ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

# ⚠️ IMPORTANTE: plugins do Oh My Zsh devem ficar ANTES do source
plugins=(
  git
  z
  node
  npm
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# --- SPACESHIP (CONFIG LEVE) ---
SPACESHIP_PROMPT_ORDER=(
  user
  dir
  host
  git
  node
  exec_time
  line_sep
  jobs
  exit_code
  char
)

SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

SPACESHIP_NODE_SHOW=true
SPACESHIP_GIT_SHOW=true

# --- PLUGINS VIA ZINIT (RÁPIDOS) ---
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# --- ALIASES: NAVEGAÇÃO & SISTEMA ---
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'  # Estilo Windows no Linux
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'

# --- ALIASES: GIT (MAIS AGRESSIVOS) ---
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'      # Ex: gc "feat: add express routes"
alias gp='git push'
alias gl='git log --oneline --graph --all -n 10'
alias gco='git checkout'
alias gb='git branch'

# --- ALIASES: NODE & NPM (ISSUE #1) ---
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'       # Para rodar o nodemon direto
alias start='npm start'

# --- ALIASES: DOCKER (ISSUE #3) ---
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimgs='docker images'
alias dstop='docker stop $(docker ps -q)' # Para tudo de uma vez

# --- ALIASES: UTILITÁRIOS JÁ EXISTENTES ---
alias faxina="~/scripts/cleanup.sh"
alias gwatch='gh run watch'
alias gcheck='gh run list'
alias gview='gh run view --log'



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
