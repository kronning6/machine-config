-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
require('lazy').setup {
  -- Added from kickstart.nvim
  require 'kronning6.plugins.init',
  require 'kronning6.plugins.comment',
  require 'kronning6.plugins.gitsigns',
  require 'kronning6.plugins.which-key',
  require 'kronning6.plugins.telescope',
  require 'kronning6.plugins.nvim-lspconfig',
  require 'kronning6.plugins.conform',
  require 'kronning6.plugins.none-ls',
  -- require 'kronning6.plugins.nvim-cmp',
  require 'kronning6.plugins.blink',
  require 'kronning6.plugins.todo-comments',
  require 'kronning6.plugins.mini',
  require 'kronning6.plugins.treesitter',
  require 'kronning6.plugins.indent-blankline',
  -- My plugins
  require 'kronning6.plugins.lualine',
  require 'kronning6.plugins.vim-tmux-navigator',
  require 'kronning6.plugins.theme-catppuccin',
  require 'kronning6.plugins.theme-tokyonight',
  require 'kronning6.plugins.alpha',
  require 'kronning6.plugins.toggleterm',
  require 'kronning6.plugins.git-blame',
  require 'kronning6.plugins.nvim-ts-autotag',
  require 'kronning6.plugins.nvim-autopairs',
  require 'kronning6.plugins.nvim-tree',
  require 'kronning6.plugins.harpoon',
  -- require 'kronning6.plugins.ranger',
  require 'kronning6.plugins.oil',
  require 'kronning6.plugins.markdown',
  require 'kronning6.plugins.fringe-mode',
  require 'kronning6.plugins.aerial',
}

-- vim: ts=2 sts=2 sw=2 et
