#!/usr/bin/env bash

DIR=$HOME/code/machine-config/.config

if [ $# -eq 0 ]; then
    echo "Usage: $0 <theme>"
    exit 1
fi

theme=$1


cp "${DIR}/ghostty/theme_config/${theme}" "${DIR}/ghostty/theme_config/current"
touch "${DIR}/ghostty/config"

cp "${DIR}/wezterm/themes/${theme}.lua" "${DIR}/wezterm/themes/current.lua"
touch "${DIR}/wezterm/wezterm.lua"

cp "${DIR}/alacritty/themes/${theme}.toml" "${DIR}/alacritty/themes/current.toml"
touch "${DIR}/alacritty/alacritty.toml"

tmux list-panes -a -F '#{pane_id} #{pane_current_command}' |
    grep vim |
    cut -d ' ' -f 1 |
    xargs -I PANE tmux send-keys -t PANE ESCAPE ":colorscheme ${theme}" ENTER
echo "vim.cmd(\"colorscheme ${theme}\")" > "${DIR}/nvim/lua/kronning6/current-theme.lua"

cp "${DIR}/tmux/themes/${theme}.conf" "${DIR}/tmux/themes/current.conf"
tmux source-file "${DIR}/tmux/tmux.conf"

# TODO: Figure out how to set fzf theme
# $(fzf_${theme})
