return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        -- float = {
        --   enable = true,
        --   open_win_config = function()
        --     local screen_w = vim.opt.columns:get()
        --     local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        --     local window_w = screen_w * 0.8
        --     local window_h = screen_h * 0.8
        --     local window_w_int = math.floor(window_w)
        --     local window_h_int = math.floor(window_h)
        --     local center_x = (screen_w - window_w) / 2
        --     local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
        --     return {
        --       border = 'rounded',
        --       relative = 'editor',
        --       row = center_y,
        --       col = center_x,
        --       width = window_w_int,
        --       height = window_h_int,
        --     }
        --   end,
        -- },
        width = function()
          -- return math.floor(vim.opt.columns:get() * 0.8)
          return math.floor(vim.opt.columns:get() * 0.2)
        end,
      },
      update_focused_file = {
        enable = true,
        debounce_delay = 15,
        update_root = true,
        ignore_list = {},
      },
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 200,
      },
      filters = {
        custom = { '^.git$' },
        git_ignored = false,
      },
    }
  end,
}
