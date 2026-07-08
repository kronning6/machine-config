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

    local eslint_config_files = {
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      '.eslintrc.json',
      '.eslintrc.js',
      '.eslintrc.cjs',
    }

    local function find_upward(start_dir, file_name)
      local matches = vim.fs.find(file_name, { path = start_dir, upward = true })
      return matches[1]
    end

    local function has_eslint_config(utils)
      return utils.root_has_file(eslint_config_files)
    end

    local function eslint_cwd(params)
      local config_file = find_upward(params.bufname, eslint_config_files)
      if config_file ~= nil then
        return vim.fs.dirname(config_file)
      end

      return params.root
    end

    local eslint_args = {
      'exec',
      'eslint',
      '-f',
      'json',
      '--stdin',
      '--stdin-filename',
      '$FILENAME',
    }

    nls.setup {
      root_dir = nls_utils.root_pattern('.null-ls-root', 'package.json', 'tsconfig.json'),
      sources = {
        require('none-ls.diagnostics.eslint').with {
          command = 'pnpm',
          args = eslint_args,
          cwd = eslint_cwd,
          condition = has_eslint_config,
        },
        require('none-ls.code_actions.eslint').with {
          command = 'pnpm',
          args = eslint_args,
          cwd = eslint_cwd,
          condition = has_eslint_config,
        },
      },
    }
  end,
}
