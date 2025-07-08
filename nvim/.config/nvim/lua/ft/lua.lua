return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", event = 'BufReadPre', ft = 'lua' }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["local-lua"] then
        require("dap").adapters["local-lua"] = {
          type = "executable",
          command = "local-lua-dbg",
          args = {},
          enrich_config = function(config, on_config)
            if not config["extensionPath"] then
              local c = vim.deepcopy(config)
              c.extensionPath = "/usr/lib/node_modules/local-lua-debugger-vscode/"
              on_config(c)
            else
              on_config(config)
            end
          end
        }
      end

      dap.configurations["lua"] =  {
        {
          type = "local-lua",
          name = "Launch file",
          request = "launch",
          program = {
            lua = "lua",
            file = "${file}"
          },
          cwd = "${workspaceFolder}",
          args = {}
        }
      }

    end
  }

}
