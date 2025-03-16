-- [[ My options ]]
vim.opt.guicursor = 'n-v-c-sm:block,i-ci:blinkwait1000-blinkon1000-blinkoff200'
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.scrolloff = 3
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.colorcolumn = '80,120'
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.listchars = { space = '.', tab = '››' }
vim.opt.list = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.cursorline = true

-- [[ kickstart.nvim options ]]
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'

-- Don't have `o` add a comment
vim.opt.formatoptions:remove 'o'
vim.opt.formatoptions:remove 'O'
