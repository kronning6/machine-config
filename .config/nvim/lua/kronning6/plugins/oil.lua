return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 2,
        max_width = 220,
        max_height = 0,
      },
      preview_win = {
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        preview_method = 'fast_scratch',
      },
      use_default_keymaps = false,
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
        ['<ESC>'] = { 'actions.close', mode = 'n' },
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-p>'] = 'actions.preview',
        ['R'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      },
    }
  end,
}
