#!/usr/bin/env bash

set -euo pipefail

# --- Config ---------------------------------------------------------------

DIR=$HOME/code/machine-config
MACHINE_SETUP_PRIVATE_DIR="${HOME}/code/machine-setup-private"
EMAIL_FILE="${DIR}/.git-email"
GITCONFIG_TEMPLATE="${DIR}/.gitconfig"
GITCONFIG_TARGET="${HOME}/.gitconfig"
GIT_EMAIL=""

DOTFILES=(
  ".zshenv"
  ".config/aerospace"
  # ".config/alacritty"
  ".config/ghostty"
  ".config/lazygit"
  ".config/nvim"
  ".config/nvim-kickstart"
  ".config/nvim-lazyvim"
  ".config/opencode"
  ".config/ranger"
  ".config/sesh"
  # ".config/skhd"
  ".config/tmux"
  # ".config/wezterm"
  ".config/zsh"
  # ".config/yabai"
  ".config/starship.toml"
)

# --- Git identity ---------------------------------------------------------

ensure_git_email() {
  # TODO: Instead of doing this here, let's create a setup script that populates a gitignored file
  if [ -f "$EMAIL_FILE" ]; then
    GIT_EMAIL=$(cat "$EMAIL_FILE")
    echo "Using stored Git email: $GIT_EMAIL"
    return
  fi

  read -p "Enter your Git email address: " GIT_EMAIL || true
  if [ -n "$GIT_EMAIL" ]; then
    echo "$GIT_EMAIL" > "$EMAIL_FILE"
    echo "Git email saved to $EMAIL_FILE"
  else
    echo "No email provided, using existing Git email configuration"
  fi
}

write_gitconfig() {
  if [ -z "$GIT_EMAIL" ]; then
    cp "$GITCONFIG_TEMPLATE" "$GITCONFIG_TARGET"
    echo "Copied Git config template to $GITCONFIG_TARGET without an email override"
    return
  fi

  awk -v email="$GIT_EMAIL" '
    /^\[user\]$/ { in_user = 1; print; next }
    /^\[/ && $0 != "[user]" {
      if (in_user && !inserted) {
        print "  email = " email
        inserted = 1
      }
      in_user = 0
      print
      next
    }
    in_user && $0 ~ /^[[:space:]]*email[[:space:]]*=/ { next }
    { print }
    END {
      if (in_user && !inserted) {
        print "  email = " email
      }
    }
  ' "$GITCONFIG_TEMPLATE" > "$GITCONFIG_TARGET"
  echo "Git email configured in $GITCONFIG_TARGET: $GIT_EMAIL"
}

# --- Dotfiles -------------------------------------------------------------

is_current_dotfile() {
  local path="$1"
  local dotfile

  for dotfile in "${DOTFILES[@]}"; do
    if [ "$path" = "${HOME}/${dotfile}" ]; then
      return 0
    fi
  done

  return 1
}

remove_stale_symlinks() {
  local path target

  for path in "${HOME}"/.* "${HOME}"/.config/*; do
    [ -L "$path" ] || continue

    target=$(readlink "$path")
    case "$target" in
      "${DIR}"/*)
        if ! is_current_dotfile "$path"; then
          rm "$path"
          echo "Removed stale dotfile symlink: $path"
        fi
        ;;
    esac
  done
}

link_dotfiles() {
  local dotfile

  remove_stale_symlinks

  for dotfile in "${DOTFILES[@]}"; do
    rm -rf "${HOME}/${dotfile}"
    ln -sf "${DIR}/${dotfile}" "${HOME}/${dotfile}"
  done
}

# --- Git checkouts --------------------------------------------------------

ensure_private_repos() {
  if [ ! -d "${MACHINE_SETUP_PRIVATE_DIR}/.git" ]; then
    git clone git@github.com:kronning6/machine-setup-private.git "$MACHINE_SETUP_PRIVATE_DIR"
  fi

  "${MACHINE_SETUP_PRIVATE_DIR}/clone-repositories.sh"
}

install_dependencies() {
  if [ ! -d "${HOME}/.config/tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.config/tmux/plugins/tpm"
  fi

  if [ ! -d "${DIR}/.config/nvim-kickstart" ]; then
    git clone https://github.com/nvim-lua/kickstart.nvim.git "${DIR}/.config/nvim-kickstart"
  fi

  if [ ! -d "${DIR}/.config/nvim-lazyvim" ]; then
    git clone https://github.com/LazyVim/starter.git "${DIR}/.config/nvim-lazyvim"
  fi
}

# --- Main -----------------------------------------------------------------

# Git identity: resolve the email first, then write ~/.gitconfig with it.
ensure_git_email
write_gitconfig

# Dotfiles: prune stale symlinks, then link the current set.
link_dotfiles

# Git checkouts: private repos first, then plugin/starter dependencies.
ensure_private_repos
install_dependencies
