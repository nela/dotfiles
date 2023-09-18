local angularls_cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations", vim.fn.getcwd() .. '/node_modules',
  "--ngProbeLocations", vim.fn.getcwd() .. '/node_modules',
  -- "--tsProbeLocations", '/home/nela/.local/share/asdf/tools/installs/nodejs/lib/node_modules',
  -- "--ngProbeLocations", '/home/nela/.local/share/asdf/tools/installs/nodejs/lib/node_modules'
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      "joeveiga/ng.nvim"
    },
    opts = {
      servers = {
        tsserver = {
          --cmd = { "typescript-language-server --stdio" },
          keys = {
            { "<leader>oi", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
            { "<leader>tr", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" }
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop
              },
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop
              },
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            completions = {
              completeFunctionCalls = true
            }
          }
        },
        angularls = {
          keys = {
            { "<leader>at", function () require("ng").goto_template_for_component() end },
            { "<leader>ac", function () require("ng").goto_component_with_template_file() end },
            { "<leader>aT", function () require("ng").get_template_tcb() end },
          },
        cmd = angularls_cmd,
        on_new_config = function (new_config, _)
            new_config.cmd = angularls_cmd
          end
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- angularls = function(_, opts)
        --   opts.on_new_config = function(new_config, _)
        --     new_config.cmd = opts.cmd
        --   end
        --   return true
        -- end
      }
    },
  },
  {
    "mfussenegger/nvim-dap",
    -- optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              os.getenv("XDG_DATA_HOME") .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      for _, language in ipairs({ "typescript", "javascript" }) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",

              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
}
