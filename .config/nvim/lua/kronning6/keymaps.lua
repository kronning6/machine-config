-- [[ My keymaps ]]

-- Basic remaps
vim.keymap.set('i', '<C-c>', "col('.') == col('$') ? '<Esc>' : '<Esc>l'", { expr = true, silent = false })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<C-a>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-x>', '<Nop>', { noremap = true, silent = true })

-- vim.keymap.set("n", "j", "jzz")
-- vim.keymap.set("n", "k", "kzz")
vim.keymap.set('n', 'zz', 'zz20<C-e>')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')

-- Other Custom Keymaps
vim.keymap.set('n', '<C-s>', ':w<cr>')
-- vim.keymap.set('n', '<S-x>', ':BufferKill<CR>')
vim.keymap.set('x', 'p', [["_dP]])
-- vim.keymap.set('x', '<Space>P', [["_dP]])
vim.keymap.set('n', '<Space>R', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Readline / Emacs style keybindings
vim.keymap.set('i', '<C-d>', '<Del>', { noremap = true })
vim.keymap.set('i', '<C-a>', '<C-o>^', { noremap = true })
vim.keymap.set('i', '<C-b>', '<Left>', { noremap = true })
vim.keymap.set('i', '<C-f>', '<Right>', { noremap = true })
vim.keymap.set('i', '<C-e>', '<C-o>$', { noremap = true })
vim.keymap.set(
  'i',
  '<C-e>',
  'col(".")>strlen(getline("."))<bar><bar>pumvisible()?"\\<Lt>C-e>":"\\<Lt>End>"',
  { noremap = true, expr = true, replace_keycodes = false }
)
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true })
vim.keymap.set('c', '<C-b>', '<Left>', { noremap = true })
vim.keymap.set('c', '<C-f>', '<Right>', { noremap = true })
vim.keymap.set('c', '<C-e>', '<End>', { noremap = true })
vim.keymap.set('c', '<C-d>', 'getcmdpos()>strlen(getcmdline())?"":"\\<Lt>Del>"', { noremap = true, expr = true, replace_keycodes = false })

-- Resize windows
-- ctrl-w = (make windows same size)
-- ctrl-w +/- (height)
-- ctrl-w >/< (width)

-- Based off of https://www.reddit.com/r/neovim/comments/umcv08/how_to_resize_a_split_based_on_its_position/
local change_width = function(d)
  local v = vim.api

  d = d and d or 'left'

  local lr = d == 'left' or d == 'right'
  local amt = lr and 2 or 2 -- customize lf vs ud resize amount

  local current_win_id = v.nvim_get_current_win()
  local pos = v.nvim_win_get_position(current_win_id)
  local w = v.nvim_win_get_width(current_win_id)
  local h = v.nvim_win_get_height(current_win_id)

  local has_win_right = false
  local has_win_down = false
  local win_ids = v.nvim_list_wins()
  for _, win_id in ipairs(win_ids) do
    local win_pos = v.nvim_win_get_position(win_id)
    if win_id ~= current_win_id and pos[1] == win_pos[1] and pos[2] < win_pos[2] then
      has_win_right = true
    end
    if win_id ~= current_win_id and pos[2] == win_pos[2] and pos[1] < win_pos[1] then
      has_win_down = true
    end
  end

  if lr then
    amt = (pos[2] == 0 or has_win_right) and -amt or amt
  else
    amt = (pos[1] == 0 or has_win_down) and -amt or amt
  end

  w = (d == 'left') and (w + amt) or (w - amt)
  h = (d == 'up') and (h + amt) or (h - amt)

  if lr then
    v.nvim_win_set_width(current_win_id, w)
  else
    v.nvim_win_set_height(current_win_id, h)
  end
end

vim.keymap.set({ 'n' }, '<Left>', function()
  change_width 'left'
end)
vim.keymap.set({ 'n' }, '<Right>', function()
  change_width 'right'
end)

vim.keymap.set({ 'n' }, '<Up>', function()
  change_width 'up'
end)
vim.keymap.set({ 'n' }, '<Down>', function()
  change_width 'down'
end)

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '<', '<<_')
vim.keymap.set('n', '>', '>>_')

vim.keymap.set('n', '<M-j>', ':m .+1<CR>==')
vim.keymap.set('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('x', '<M-j>', ":m '>+1<CR>gv-gv")
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==')
vim.keymap.set('i', '<M-k>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('x', '<M-k>', ":m '<-2<CR>gv-gv")

-- New keymaps
vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<cr>', { desc = '[E]xplore' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')

-- local lazygit_toggle = function()
--   local Terminal = require('toggleterm.terminal').Terminal
--   local lazygit = Terminal:new {
--     cmd = 'lazygit',
--     hidden = true,
--     direction = 'float',
--     float_opts = {
--       border = 'none',
--       width = 100000,
--       height = 100000,
--     },
--     on_open = function(_)
--       vim.cmd 'startinsert!'
--     end,
--     on_close = function(_) end,
--     count = 99,
--   }
--   lazygit:toggle()
-- end
--
-- vim.keymap.set('n', '<leader>gg', function()
--   lazygit_toggle()
-- end, { desc = 'Open lazygit' })

-- [[ Keymaps from kickstart.nvim ]]

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>ef', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<leader>gg', function()
  local oil = require 'oil'
  -- local util = require 'oil.util'
  oil.toggle_float()
  -- util.run_after_load(0, function()
  --   oil.open_preview()
  -- end)
end, { desc = 'Oil: toggle oil floating window' })

vim.keymap.set('n', '<leader>bb', '<cmd>FringeModeToggle<cr>', { desc = 'Toggle Fringe Mode' })
vim.keymap.set('n', '<leader>bg', '<cmd>FringeModeBalance<cr>', { desc = 'Balance Fringe Mode Windows' })
