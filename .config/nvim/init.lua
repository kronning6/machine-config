-- My configuration was kickstarted from: https://github.com/nvim-lua/kickstart.nvim

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require 'kronning6.options'
require 'kronning6.keymaps'
require 'kronning6.autocommands'
require 'kronning6.lazy-bootstrap'
require 'kronning6.lazy-plugins'
require 'kronning6.themes'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
