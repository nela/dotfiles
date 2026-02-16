return {
  {
    'echasnovski/mini.indentscope',
    version = '*',
    event = {
      'BufReadPost',
      'BufNewFile',
      opts = {
        -- symbol = '╎',
        symbol = '│',
        options = { try_as_border = true },
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost' },
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
        -- char = "▏",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'lazy',
          'NvimTree',
        },
      },
    },
    main = 'ibl',
  },
  {
    enabled = false,
    'lewis6991/hover.nvim',
    opts = {
      preview_opts = {
        border = 'single',
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = {
        'LSP',
      },
      mouse_delay = 2000,
    },
    init = function(_)
      require('hover.providers.lsp')
      require('hover.providers.diagnostic')
      require('hover.providers.dap')
      require('hover.providers.man')
      -- require('hover.providers.dictionary')
      -- require('hover.providers.highlight')
      -- require('hover.providers.gh')
      -- require('hover.providers.gh_user')
      -- require('hover.providers.jira')
      -- require('hover.providers.fold_preview')
    end,
  },
  {
    'j-hui/fidget.nvim',
    enabled = true,
    opts = {
      notification = {
        window = {
          -- normal_hl = "NormalFloat",
          winblend = 0,
          -- border = 'rounded'
        },
      },
    },
  },
  {
    'lewis6991/whatthejump.nvim',
    event = 'VeryLazy',
    enabled = false,
    keys = {
      --stylua: ignore
      { '<M-k>', function() require('whatthejump').show_jumps(false) return '<C-o>' end, mode = 'n', expr = true, },
      {
        '<M-j>',
        function()
          require('whatthejump').show_jumps(true)
          return '<C-i>'
        end,
        mode = 'n',
        expr = true,
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    enabled = false,
    config = function()
      vim.notify = require('notify')
    end,
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    enabled = true,
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    opts = {
      preset = 'classic',
      transparent_bg = true,
      transparent_cursorline = true, -- Set the background of the cursorline to transparent (only one the first diagnostic)
      options = {
        show_source = {
          enabled = true,
          -- if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = true,
          trim_whitespaces = true,
          -- Replace tabs with spaces in multiline diagnostics
          tabstop = 4,
        },
      },
    },
    config = function(_, opts)
      require('tiny-inline-diagnostic').setup(opts)
      -- vim.cmd('hi TinyInlineDiagnosticVirtualTextError guibg=NONE')
    end,
  },
}
