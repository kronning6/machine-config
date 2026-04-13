return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',
  config = function()
    local nvim_treesitter = require 'nvim-treesitter'

    if not nvim_treesitter.install then
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'html',
          'lua',
          'markdown',
          'vim',
          'vimdoc',
          'go',
          'python',
          'rust',
          'tsx',
          'javascript',
          'typescript',
          'toml',
          'yaml',
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }
      return
    end

    local parsers = {
      'bash',
      'c',
      'diff',
      'go',
      'html',
      'javascript',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'rust',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    }
    nvim_treesitter.install(parsers)

    local function treesitter_try_attach(buf, language)
      if not vim.treesitter.language.add(language) then
        return
      end

      vim.treesitter.start(buf, language)
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    local available_parsers = nvim_treesitter.get_available()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('kronning6-treesitter', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local filetype = args.match
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end

        local installed_parsers = nvim_treesitter.get_installed 'parsers'

        if vim.tbl_contains(installed_parsers, language) then
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          nvim_treesitter.install(language):await(function()
            treesitter_try_attach(buf, language)
          end)
        else
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
