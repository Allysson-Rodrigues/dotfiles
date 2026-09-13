# ==============================================================================
# Zsh Configuration (Optimized for Fedora & Development Performance)
# ==============================================================================

# --- Path e ambiente base ---
export PATH="$HOME/.local/bin:$PATH"

# --- Shared environment (Bash & Zsh parity) ---
if [[ -f "$HOME/.shell_env" ]]; then
  source "$HOME/.shell_env"
fi

# --- Histórico ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE         # Commands starting with space stay out of history (security)
setopt HIST_EXPIRE_DUPS_FIRST    # Remove oldest duplicates first when hitting 50k limit
setopt AUTO_CD                   # Typing a directory name navigates into it directly

# --- Completion Otimizado (Cache de 24h para inicialização rápida) ---
fpath=("$HOME/.local/share/zsh/site-functions" $fpath)
autoload -Uz compinit
if [[ -r ~/.zcompdump ]]; then
  compinit -C
else
  compinit
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Compile zcompdump to bytecode in background for faster startup
{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# --- Keybindings (Navegação natural de terminal) ---
bindkey -e
bindkey '^[[H' beginning-of-line          # Home
bindkey '^[[F' end-of-line                # End
bindkey '^[[3~' delete-char               # Delete
bindkey '^[[1;5C' forward-word            # Ctrl+Right
bindkey '^[[1;5D' backward-word           # Ctrl+Left
bindkey '^H' backward-kill-word           # Ctrl+Backspace
bindkey '^[[3;5~' kill-word               # Ctrl+Delete

# Substring History Search (Seta Cima/Baixo filtra pelo texto já digitado)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- FZF (cached init for faster startup) ---
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--height 45% --layout=reverse --border --inline-info --color=dark"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :300 {} 2>/dev/null || tree -C {}' --preview-window right:55%"

# --- Aliases ---
if [[ -f "$HOME/.shell_aliases" ]]; then
  source "$HOME/.shell_aliases"
fi


# --- Integrations ---
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# FZF: cached init (regenerates only when fzf binary changes)
_fzf_cache="$HOME/.cache/fzf-init.zsh"
_fzf_bin="$(command -v fzf 2>/dev/null)"
if [[ -n "$_fzf_bin" && ( ! -f "$_fzf_cache" || "$_fzf_bin" -nt "$_fzf_cache" ) ]]; then
  fzf --zsh > "$_fzf_cache" 2>/dev/null
fi
[[ -f "$_fzf_cache" ]] && source "$_fzf_cache"

# --- Prompt ---
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# --- Plugins ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5c6370,bold"

if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

setopt INTERACTIVE_COMMENTS

# --- PATH deduplication (última palavra) ---
typeset -U PATH
