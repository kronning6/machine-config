local function on_attach(event)
  local telescope = require 'telescope.builtin'
  local function map(keys, action, desc)
    vim.keymap.set('n', keys, action, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  map('gd', telescope.lsp_definitions, 'Go to definition')
  map('gD', vim.lsp.buf.declaration, 'Go to declaration')
  map('gI', telescope.lsp_implementations, 'Go to implementation')
  map('<leader>D', telescope.lsp_type_definitions, 'Go to type definition')
  map('gr', function()
    telescope.lsp_references { include_declaration = true, include_current_line = true }
  end, 'Go to references')
  map('<leader>ds', telescope.lsp_document_symbols, 'Document symbols')
  map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, 'Workspace symbols')
  map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
  map('K', vim.lsp.buf.hover, 'Hover documentation')

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client or not client:supports_method('textDocument/documentHighlight', event.buf) then
    return
  end

  local group = vim.api.nvim_create_augroup('kronning6-lsp-highlight', { clear = false })
  vim.api.nvim_clear_autocmds { group = group, buffer = event.buf }
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = group,
    buffer = event.buf,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group,
    buffer = event.buf,
    callback = vim.lsp.buf.clear_references,
  })
end

-- Prefer package-manager lockfiles so monorepos share a workspace root.
local typescript_root_markers = {
  { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' },
  '.git',
}

local function native_typescript(root)
  -- Search parent directories too, for hoisted dependencies.
  local package = vim.fs.find('node_modules/typescript/package.json', { path = root, upward = true, type = 'file' })[1]
  if not package then
    return
  end

  local ok, metadata = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(package), '\n'))
  end)
  if not ok or type(metadata) ~= 'table' or type(metadata.version) ~= 'string' then
    return
  end

  local major = tonumber(metadata.version:match '^(%d+)')
  if major and major >= 7 then
    local command = vim.fs.joinpath(vim.fs.dirname(package), 'bin', 'tsc')
    if vim.fn.executable(command) == 1 then
      return command
    end
  end
end

local function typescript_root(use_native)
  return function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, typescript_root_markers) or vim.fn.getcwd()
    if (native_typescript(root) ~= nil) == use_native then
      on_dir(root)
    end
  end
end

local servers = {
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = 'Replace' } } },
  },
  -- TypeScript 6 and older, or when no native executable is available.
  ts_ls = { root_dir = typescript_root(false) },
  -- TypeScript 7+ supplies its own language server.
  tsc = {
    cmd = function(dispatchers, config)
      local command = assert(native_typescript(config.root_dir), 'Project TypeScript executable not found')
      return vim.lsp.rpc.start({ command, '--lsp', '--stdio' }, dispatchers)
    end,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_dir = typescript_root(true),
  },
}

local function setup_mason()
  require('mason').setup()

  local tools = { 'stylua', 'gofumpt', 'golangci-lint', 'delve' }
  for server in pairs(servers) do
    if server ~= 'tsc' then -- Provided by the project, not Mason.
      table.insert(tools, server)
    end
  end
  require('mason-tool-installer').setup { ensure_installed = tools }
  require('mason-lspconfig').setup { automatic_enable = false }
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kronning6-lsp-attach', { clear = true }),
      callback = on_attach,
    })

    setup_mason()

    local capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)
    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
