# AGENTS.md

## Scope
- This repo is a personal macOS dotfiles/config repo, not a single app. Most edits target files under `.config/` plus a few root scripts.

## High-Value Entry Points
- Neovim starts at `.config/nvim/init.lua` and loads in this order: `options`, `keymaps`, `autocommands`, `lazy-bootstrap`, `lazy-plugins`, `themes`.
- Neovim plugin specs live in `.config/nvim/lua/kronning6/plugins/*.lua`; add or change plugin behavior there instead of stuffing more into `init.lua`.
- OpenCode config lives in `.config/opencode/opencode.json`; `.config/opencode/package.json` only installs the plugin dependency.

## Commands
- Do not run `./kronning.sh` casually. It deletes existing files under `$HOME` for the listed dotfiles, recreates them as symlinks to this repo, rewrites `~/.gitconfig`, and may clone tmux/nvim starter repos.
- Theme switching is centralized in `./set_theme.sh <theme>`. It copies theme files into the `current` files for Ghostty, WezTerm, Alacritty, tmux, and rewrites `.config/nvim/lua/kronning6/current-theme.lua`.
- Reload tmux config with `tmux source-file ~/.config/tmux/tmux.conf`.

## Generated / Derived Files
- Treat `.config/nvim/lua/kronning6/current-theme.lua`, `.config/alacritty/themes/current.toml`, `.config/wezterm/themes/current.lua`, `.config/ghostty/theme_config/current`, and `.config/tmux/themes/current.conf` as derived outputs of `set_theme.sh`. If the goal is a persistent theme change, update the source theme files or the script, not just the generated `current` files.

## Neovim Conventions
- The Neovim config is a Kickstart-based setup bootstrapped with `lazy.nvim`; `lazy-bootstrap.lua` auto-clones `folke/lazy.nvim` if missing.
- `lazy-plugins.lua` is the authoritative plugin wiring list. There is still an old `nvim-tree` plugin file, but `README.md` says Oil is the intended file manager; check both before changing file-explorer behavior.
- LSP/tool installation is driven from `.config/nvim/lua/kronning6/plugins/nvim-lspconfig.lua` via Mason. Current explicitly configured servers are `gopls`, `ts_ls`, and `lua_ls`.
- Formatting is driven by Conform in `.config/nvim/lua/kronning6/plugins/conform.lua`: Lua uses `stylua`; JS/TS/CSS/HTML/JSON/YAML/Markdown use `prettierd` then `prettier`; Go uses `gofumpt` and also runs `source.organizeImports` on save.
- Lua formatting style is pinned in `.stylua.toml`: 2 spaces, width 160, Unix line endings, `AutoPreferSingle`, and `call_parentheses = "None"`.

## Verification
- There is no repo-wide CI/test/lint entrypoint checked into the root.
- For Lua edits, prefer focused verification such as `stylua <paths>`.
- For Neovim config changes, a headless startup check is the most relevant validation: `nvim --headless '+qa'`.

## Tmux / AeroSpace Gotchas
- Tmux prefix is remapped to `Ctrl-Space`, not the default `Ctrl-B`.
- AeroSpace movement uses `.config/aerospace/join_with_or_move.sh` for `ctrl-alt-shift-cmd-{left,down,up,right}`: it tries `aerospace join-with` first and falls back to `aerospace move`.
