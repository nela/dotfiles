return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'echasnovski/mini.diff',
        config = function()
          local diff = require('mini.diff')
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
    },
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'BufReadPre',
  cmd = {
    'CodeCompanion',
    'CodeCompanionActions',
    'CodeCompanionChat',
    'CodeCompanionCmd',
  },
  keys = {
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
    { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to CodeCompanion chat', mode = 'x' },
  },
  opts = function()
    local config = require('codecompanion.config').config

    local diff_opts = config.display.diff.opts
    table.insert(diff_opts, 'context:99') -- Setting the context to a very large number disables folding.
    return {
      adapters = {
        opts = {
          show_model_choices = false,
        },
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            schema = {
              model = {
                default = 'gemini-2.5-pro',
              },
            },
            env = {
              api_key = 'GEMINI_API_KEY',
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'gemini',
        },
        inline = {
          adapter = 'gemini',
        },
        cmd = {
          adapter = 'gemini',
        },
      },
      opts = {
        display = {
          diff = {
            provider = 'default' --'mini_diff',
          },
        },
      },
    }
  end,
  init = function()
    require('plugins.ai.fidget-spinner'):init()
  end,
}
