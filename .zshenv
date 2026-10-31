export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Use the standard ~/.zshenv and ~/.zshrc locations.
unset ZDOTDIR

# Environment needed by every shell, including commands launched by tools.
typeset -U path
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$HOME/.local/bin:$GOBIN:$HOME/.opencode/bin:$PNPM_HOME/bin:$PATH"

if command -v fnm >/dev/null 2>&1; then
  if [[ -o interactive ]]; then
    eval "$(fnm env --use-on-cd --shell zsh)"
  else
    eval "$(fnm env --shell zsh)"
  fi
fi
