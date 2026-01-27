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

    -- local diff_opts = config.display.diff.opts
    -- table.insert(diff_opts, 'context:99') -- Setting the context to a very large number disables folding.
    return {
      adapters = {
        http = {
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              env = {
                api_key = 'GEMINI_API_KEY',
              },
              schema = {
                model = {
                  default = 'gemini-2.5-pro'
                }
              }
            })
          end,
        },
        --[[ acp = {
          opts = {
            show_model_choices = true,
          },
          claude_code = function()
            return require('codecompanion.adapters').extend('claude_code', {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = 'CLAUDE_CODE_OAUTH_TOKEN',
              },
            })
          end,
        }, ]]
      },
      strategies = {
        chat = {
          adapter = 'gemini',
--           opts = {
--             ---@param ctx CodeCompanion.SystemPrompt.Context
--             ---@return string
--             system_prompt = function(ctx)
--               return ctx.default_system_prompt
--                 .. string.format(
--                   [[IMPORTANT: Do not directly edit, modify, or create files in the codebase unless the user explicitly requests you to do so.
-- Your default mode is to provide suggestions, explanations, and code examples in markdown code blocks within your chat responses.
-- Only use file manipulation capabilities (such as creating, editing, or deleting files) when the user gives you clear, direct permission to make changes to the actual files.
-- DO NOT ask the user to manually apply code changes - either provide complete code examples in your response or wait for explicit permission to make the changes directly.
--
-- Additional context:
-- All non-code text responses must be written in the ${language} language.
-- The current date is ${date}.
-- The user's Neovim version is ${version}.
-- The user is working on a ${os} machine. Please respond with system specific commands if applicable.
-- ]],
--                   ctx.language,
--                   ctx.date,
--                   ctx.nvim_version,
--                   ctx.os
--                 )
--             end,
--           },
          ---Decorate the user message before it's sent to the LLM
          ---@param message string
          ---@param adapter CodeCompanion.Adapter
          ---@param context table
          ---@return string
          prompt_decorator = function(message, _, _)
            return string.format([[<prompt>%s</prompt>]], message)
          end,
        },
        inline = {
          adapter = 'gemini',
        },
        cmd = {
          adapter = 'gemini',
        },
      },
      display = {
        diff = {
          provider = 'split', --'mini_diff',
        },
      },
    }
  end,
  init = function()
    require('plugins.ai.fidget-spinner'):init()
  end,
}
