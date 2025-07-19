return {
  {
    dir = '~/code/fringe-mode.nvim',
    config = function()
      require('fringe-mode').setup {
        -- bgcolor = '#1f2335',
        bgcolor = '#e1e2e7',
        min_fringe_width = 20,
        widths = { normal = 118, narrow = 88 },
      }
    end,
  },
}
