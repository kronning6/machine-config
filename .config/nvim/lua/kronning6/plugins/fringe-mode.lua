return {
  {
    dir = '~/code/fringe-mode.nvim',
    config = function()
      require('fringe-mode').setup {
        bgcolor = '#1f2335',
        min_fringe_width = 20,
        widths = { normal = 118, narrow = 88 },
      }
    end,
  },
}
