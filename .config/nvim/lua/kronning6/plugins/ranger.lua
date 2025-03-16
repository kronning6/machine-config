return {
  'kelly-lin/ranger.nvim',
  config = function()
    require('ranger-nvim').setup {}
    vim.api.nvim_set_keymap('n', '<leader>rr', '', {
      noremap = true,
      callback = function()
        require('ranger-nvim').open(true)
      end,
    })
  end,
}
