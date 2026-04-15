return {
  'stevearc/aerial.nvim',
  keys = {
    { '<leader>at', '<cmd>AerialToggle<cr>', desc = 'Toggle Aerial' },
  },
  opts = {},
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
