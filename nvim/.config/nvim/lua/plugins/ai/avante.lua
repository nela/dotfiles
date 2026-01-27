return {
  'yetone/avante.nvim',
  enabled = false,
  build = function()
    return 'make'
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    -- 'stevearc/dressing.nvim', -- for input provider dressing
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settig
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
  opts = {
    provider = 'gemini',
    providers = {
      gemini = {
        model = 'gemini-2.5-pro',
      },
    },
  },
}
