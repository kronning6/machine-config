return { -- Autoformat
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 2000,
      async = false,
      quiet = false,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- https://astral.sh/ruff
      -- python = { "isort", "black" },
      ['javascript'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['javascriptreact'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['typescript'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['typescriptreact'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['astro'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['vue'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['css'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['scss'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['less'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['html'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['json'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['jsonc'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['yaml'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['markdown'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['markdown.mdx'] = { 'prettierd', 'prettier', stop_after_first = true },
      ['graphql'] = { 'prettierd', 'prettier', stop_after_first = true },
      -- Add Go formatting with gofumpt (more strict than gofmt)
      ['go'] = { 'gofumpt' },
    },
    -- Format options by formatter
    formatters = {
      gofumpt = {
        prepend_args = { '-s' }, -- Simplify code where possible
      },
    },
  },

  config = function(_, opts)
    -- Load the base configuration
    require('conform').setup(opts)

    -- Create the autocommand for Go files to handle organize imports
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        -- First organize imports
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { 'source.organizeImports' } }

        -- Increase timeout to 3000ms to allow for larger codebases
        local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)

        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end

        -- Then run conform's formatting
        require('conform').format { async = false, lsp_fallback = true }
      end,
    })
  end,
}
