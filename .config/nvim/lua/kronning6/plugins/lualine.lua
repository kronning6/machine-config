return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- See `:help lualine.txt`
  opts = {
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = 'auto',
      component_separators = '',
      section_separators = '',
      disabled_filetypes = {
        'alpha',
      },
    },
    sections = {
      lualine_c = {
        {
          'filename',
          file_status = true,
          newfile_status = false,
          path = 3,
          shorting_target = 10,
          symbols = {
            modified = '**',
            readonly = '[Read-Only]',
            unnamed = '[No Name]',
            newfile = '[New]',
          },
        },
      },
    },
    winbar = {
      lualine_c = {
        {
          'filetype',
          colored = true,
          icon_only = true,
        },
        {
          'filename',
          file_status = true,
          newfile_status = false,
          path = 3,
          symbols = {
            modified = '**',
            readonly = '',
            unnamed = '',
            newfile = '',
          },
        },
      },
    },
    inactive_winbar = {
      lualine_c = {
        {
          'filename',
          file_status = false,
          newfile_status = false,
          path = 3,
          symbols = {
            modified = '',
            readonly = '',
            unnamed = '',
            newfile = '',
          },
        },
      },
    },
  },
}
