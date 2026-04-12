#!/usr/bin/env bash

DIR=$HOME/code/machine-config
EMAIL_FILE="${DIR}/.git-email"
GITCONFIG_TEMPLATE="${DIR}/.gitconfig"
GITCONFIG_TARGET="${HOME}/.gitconfig"

# TODO: Instead of doing this here, let's create a setup script that populates a gitignored file
if [ -f "$EMAIL_FILE" ]; then
  GIT_EMAIL=$(cat "$EMAIL_FILE")
  echo "Using stored Git email: $GIT_EMAIL"
else
  read -p "Enter your Git email address: " GIT_EMAIL
  if [ -n "$GIT_EMAIL" ]; then
    echo "$GIT_EMAIL" > "$EMAIL_FILE"
    echo "Git email saved to $EMAIL_FILE"
  else
    echo "No email provided, using existing Git email configuration"
  fi
fi

DOTFILES=(
  ".zshrc"
  ".config/aerospace"
  ".config/alacritty"
  ".config/ghostty"
  ".config/gitui"
  ".config/lazygit"
  ".config/nvim"
  ".config/nvim-kickstart"
  ".config/nvim-lazyvim"
  ".config/opencode"
  ".config/ranger"
  ".config/sesh"
  # ".config/skhd"
  ".config/tmux"
  ".config/wezterm"
  # ".config/yabai"
  ".config/zellij"
  ".config/starship.toml"
)


for dotfile in "${DOTFILES[@]}";do
  rm -rf "${HOME}/${dotfile}"
  ln -sf "${DIR}/${dotfile}" "${HOME}/${dotfile}"
done

cp "$GITCONFIG_TEMPLATE" "$GITCONFIG_TARGET"

if [ -n "$GIT_EMAIL" ]; then
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
else
  echo "Copied Git config template to $GITCONFIG_TARGET without an email override"
fi

if [ ! -d ~/.config/tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

if [ ! -d ~/.config/nvim-kickstart ]; then
  git clone https://github.com/nvim-lua/kickstart.nvim.git ~/code/machine-config/.config/nvim-kickstart
fi

if [ ! -d ~/.config/nvim-lazyvim ]; then
  git clone https://github.com/LazyVim/starter.git ~/code/machine-config/.config/nvim-lazyvim
fi

# if [ -f ~/.aws/credentials ]; then
#   awk -F '=' '/aws_access_key_id/ { gsub(/^[[:blank:]]+|[[:blank:]]+$/, "", $2); print "export AWS_ACCESS_KEY_ID=" $2 }' ~/.aws/credentials > ~/.zshrc_aws
#   awk -F '=' '/aws_secret_access_key/ { gsub(/^[[:blank:]]+|[[:blank:]]+$/, "", $2); print "export AWS_SECRET_ACCESS_KEY=" $2 }' ~/.aws/credentials >> ~/.zshrc_aws
# fi
