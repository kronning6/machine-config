# Kyle's Machine Configuration

## Current Setup

- [Neovim](https://neovim.io/) (custom config started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim))
- [Corne Keyboard](https://github.com/foostan/crkbd)
- [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- [WezTerm](https://wezfurlong.org/wezterm/index.html) (and trying out [Ghostty](https://ghostty.org/))
- zsh with [Starship](https://starship.rs/)
- [tmux](https://github.com/tmux/tmux/wiki)
- [lazygit](https://github.com/jesseduffield/lazygit)
- Slack
  - Catppuccin Latte (#EFF1F5,#F8F8FA,#40A02B,#EFF1F5,#DCE0E8,#4C4F69,#40A02B,#E64553,#EFF1F5,#4C4F69)
  - Material Oceanic (#1B2B34,#4F5B66,#5FB3B3,#FFFFFF,#4F5B66,#FFFFFF,#5FB3B3,#EC5F67,#4F5B66,#FFFFFF)

### Homebrew Packages

```
brew leaves

fd
fnm
fzf
git-delta
glow
gum
jesseduffield/lazydocker/lazydocker
joshmedeski/sesh/sesh
jq
lazygit
neovim
ripgrep
starship
tfenv

brew list --cask

aerospace               font-hack-nerd-font     ghostty                 ngrok                   raycast                 wezterm
```

## Dotfile Config

- Make repo public
- Use a bare git repo to improve on symlink solution
  - https://dr563105.github.io/blog/manage-dotfiles-with-gnu-stow/
  - https://www.jakewiesler.com/blog/managing-dotfiles#understanding-stow
  - https://www.atlassian.com/git/tutorials/dotfiles
  - https://earthly.dev/blog/mng-dotfiles-with-git/
  - https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
  - https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
  - https://stribny.name/blog/ansible-dev/
- New Machine Setup
  - .config
  - .zshrc (todo: move to .config/zsh/)
  - .aws
  - .ssh

## Neovim

- Stop using nvim-tree (since I use oil.nvim now)
- [Auto close old buffers (max of 10 open at a time)](https://github.com/sontungexpt/buffer-closer)
- Keybinding ideas
  - Make h go to previous line
  - Make l go to next line

### Plugins to try out

- Buffer Navigation
  - https://github.com/wojciech-kulik/filenav.nvim
  - https://github.com/folke/flash.nvim
- File management
  - https://github.com/mbbill/undotree
  - https://github.com/X3eRo0/dired.nvim
- Git
  - https://github.com/NeogitOrg/neogit
  - https://github.com/sindrets/diffview.nvim
    - https://github.com/pwntester/octo.nvim
- Language support
  - https://github.com/nvim-java/nvim-java
  - https://github.com/ccaglak/phptools.nvim
- Org mode-like
  - https://github.com/nvim-orgmode/orgmode
  - https://github.com/nvim-neorg/neorg
- Other
  - https://github.com/tpope/vim-dadbod
  - https://github.com/rest-nvim/rest.nvim

## Keyboard

- Buy [Voyager](https://www.zsa.io/voyager)
- [Revamp layout](https://www.jonashietala.se/blog/2021/06/03/the-t-34-keyboard-layout/)
  - [Use home row mods](https://www.rho.org.uk/2022/03/no_place_like_home_row.html)
  - Swap Alt and Cmd so they are the same as on a Mac
  - Swap backspace and escape on thumb keys because backspace is more common
- Setup [Karabiner-Elements](https://karabiner-elements.pqrs.org/):
  - To disable Mac keyboard when keyboard is attached
  - Add hyper and meh keys for Mac keyboard

## Keybindings

Reference of less used keybindings

- tmux
  - ctrl-space ctrl-s (save tmux sessions)
  - ctrl-space ctrl-r (restore last tmux session)
  - ctrl-space ctrl-o (swap panes)
- nvim
  - `:so` (source a lua file)
  - Insert mode
    - ctrl-o (next command will be in insert mode)
  - Windows
    - ctrl-w = (make windows equal height and width)
    - ctrl-w v (vertical split)
    - ctrl-w s (horizontal split)
    - ctrl-w x (swap windows)
    - ctrl-o (close all other windows)
    - ctrl-c (close current window)
    - up (vertical resize larger)
    - down (vertical resize smaller)
    - right (horizontal resize larger)
    - left (horizontal resize smaller)
    - ctrl-w H (move current window to the far left)
    - ctrl-w J (move current window to the very bottom)
    - ctrl-w K (move current window to the very top)
    - ctrl-w L (move current window to the far right)

## AeroSpace

- [Implement multiple workspaces per display](https://github.com/nikitabobko/AeroSpace/issues/465)

## Tmux

- Refresh on tmux
  - https://github.com/tmux/tmux/wiki/Getting-Started
  - https://tmuxcheatsheet.com/

## New Things to Learn

- Play with Emacs
  - Emacs Playlist: https://www.youtube.com/playlist?list=PL5--8gKSku15e8lXf7aLICFmAHQVo0KXX

## My Unique Features

### Quick Color Theme Switcher

`./set_theme.sh "catppuccin-latte"`

Credits:

- https://shapeshed.com/vim-tmux-alacritty-theme-switcher/
- https://unix.stackexchange.com/questions/656854/switch-between-light-and-dark-mode-in-vim-and-tmux-with-one-command
- https://github.com/tichopad/alacritty-theme-switch
- https://github.com/dweidner/tmux-theme
- https://github.com/zaldih/themery.nvim
