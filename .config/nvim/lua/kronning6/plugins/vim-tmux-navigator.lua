return {
  'christoomey/vim-tmux-navigator',
  lazy = false,
  -- Keep Ctrl-h/j/k/l for Neovim splits in plain terminals; Rex uses its own navigator.
  cond = function()
    return vim.env.REX_SESSION == nil or vim.env.REX_SESSION == ''
  end,
}
