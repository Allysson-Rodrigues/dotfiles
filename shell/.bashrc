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


# Shared environment (Bash & Zsh parity)
if [ -f "$HOME/.shell_env" ]; then
  . "$HOME/.shell_env"
fi

if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell bash)"
fi

if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

# Load shared aliases
if [ -f "$HOME/.shell_aliases" ]; then
  . "$HOME/.shell_aliases"
fi

