# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


# Added by Antigravity CLI installer
export PATH="/home/allyssonrodrigues/.local/bin:$PATH"

# Shared environment (Bash & Zsh parity)
if [ -f "$HOME/.shell_env" ]; then
  . "$HOME/.shell_env"
fi

FNM_PATH="/home/allyssonrodrigues/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell bash)"
fi

if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

# Load shared aliases
if [ -f "$HOME/.shell_aliases" ]; then
  . "$HOME/.shell_aliases"
fi

