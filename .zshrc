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

# Plugins do Oh My Zsh (nativos)
plugins=(git z node npm docker docker-compose)

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

# Otimização de performance: Não tenta ler a versão do pacote no package.json
# Isso evita lentidão em pastas node_modules gigantes
SPACESHIP_PACKAGE_SHOW=false

# --- ASYNC PLUGINS & TOOLS VIA ZINIT ---
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Carregamento Otimizado do NVM (Lazy Load)
zinit ice wait"0" lucid nocompletions
zinit light lukechilds/zsh-nvm
export ZSH_NVM_AUTOLOAD=true

# --- NAVIGATION & SYSTEM ALIASES ---
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc'

# Professional Navigation
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
alias gst='git stash'
alias gpop='git stash pop'

# --- NODE.JS & NPM TOOLING ---
alias ni='npm install'
alias nr='npm run'
alias dev='npm run dev'
alias start='npm start'
alias t='npm test'
alias nuke-modules='find . -name "node_modules" -type d -prune -exec rm -rf "{}" +'

# --- NODE.JS DEEP CLEAN ---
# Deleta node_modules, o lock file e instala tudo do zero (resolve 99% dos bugs estranhos)
alias node-reset='rm -rf node_modules package-lock.json && npm install'

# --- DOCKER MANAGEMENT ---
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimgs='docker images'
alias dstop='docker stop $(docker ps -q)'

# Docker Compose Workflow
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'
alias dcr='docker-compose restart'
alias dcs='docker-compose stop'
alias dcb='docker-compose up -d --build'

# --- DOCKER POWER USER ---
# Remove ABSOLUTAMENTE tudo o que não está sendo usado (limpa gigabytes de disco)
alias d-clean='docker system prune -a --volumes'
# Entra dentro de um container que está rodando (substitua <nome> na hora)
alias d-shell='docker exec -it'

# --- DIAGNÓSTICO DE REDE (Útil para APIs) ---
# Mostra qual processo está travando uma porta (ex: porta 5000 ocupada)
alias ports='sudo lsof -i -P -n | grep LISTEN'
# Pega o seu IP interno do WSL (necessário para conectar o celular na API)
alias myip="hostname -I | awk '{print \$1}'"

# --- UTILITY ALIASES ---
alias faxina="~/scripts/cleanup.sh"
alias gwatch='gh run watch'
alias gcheck='gh run list'
alias gview='gh run view --log'
