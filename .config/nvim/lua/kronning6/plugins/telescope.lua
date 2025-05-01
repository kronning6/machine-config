return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for install instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    local telescope = require 'telescope'
    local telescope_config = require 'telescope.config'
    local telescope_actions_layout = require 'telescope.actions.layout'
    local telescope_actions = require 'telescope.actions'
    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

    -- Search hidden/dot files and ignored files
    table.insert(vimgrep_arguments, '--hidden')
    table.insert(vimgrep_arguments, '--no-ignore')
    -- Ignore `.git` directory.
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/.git/*')
    -- Ignore node_modules
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/node_modules/*')
    -- Ignore dist
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/dist/*')
    -- Ignore .next
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/.next/*')
    -- Ignore .turbo
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/.turbo/*')

    -- See `:help telescope` and `:help telescope.setup()`
    telescope.setup {
      defaults = {
        -- `hidden = true` is not supported in text grep commands.
        vimgrep_arguments = vimgrep_arguments,
        mappings = {
          n = {
            ['<M-p>'] = telescope_actions_layout.toggle_preview,
          },
          i = {
            ['<M-p>'] = telescope_actions_layout.toggle_preview,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { 'rg', '--files', '--hidden', '--no-ignore', '--glob', '!**/.git/*', '--glob', '!**/node_modules/*' },
        },
        buffers = {
          mappings = {
            n = {
              ['<c-d>'] = telescope_actions.delete_buffer,
            },
            i = {
              ['<c-d>'] = telescope_actions.delete_buffer,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable telescope extensions, if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'

    -- Main finders
    vim.keymap.set('n', '<leader>f', function()
      builtin.git_files {
        show_untracked = true,
      }
    end, { desc = 'Search [F]iles (Git Files)' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>st', builtin.live_grep, { desc = '[S]earch Files (Live Grep)' })
    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers { sort_mru = true }
    end, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

    -- Provided by Kickstart
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
