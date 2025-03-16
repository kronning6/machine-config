#!/usr/bin/env bash

DIR=$HOME/code/machine-config
EMAIL_FILE="${DIR}/.git-email"

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
  ".gitconfig"
  ".config/aerospace"
  ".config/alacritty"
  ".config/ghostty"
  ".config/gitui"
  ".config/lazygit"
  ".config/nvim"
  ".config/nvim-kickstart"
  ".config/nvim-lazyvim"
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

if [ -n "$GIT_EMAIL" ]; then
  git config --global user.email "$GIT_EMAIL"
  echo "Git email configured: $GIT_EMAIL"
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
