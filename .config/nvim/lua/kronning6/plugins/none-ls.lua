return {
  'nvimtools/none-ls.nvim',
  lazy = true,
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local nls = require 'null-ls'
    local nls_utils = require 'null-ls.utils'

    nls.setup {
      root_dir = nls_utils.root_pattern('.null-ls-root', 'package.json', 'tsconfig.json'),
      sources = {
        require('none-ls.diagnostics.eslint_d').with {
          condition = function(utils)
            return utils.root_has_file { '.eslintrc.json', '.eslintrc.js', '.eslintrc.cjs' }
          end,
        },
        require('none-ls.code_actions.eslint_d').with {
          condition = function(utils)
            return utils.root_has_file { '.eslintrc.json', '.eslintrc.js', '.eslintrc.cjs' }
          end,
        },
      },
    }
  end,
}
