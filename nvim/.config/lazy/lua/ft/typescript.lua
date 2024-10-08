local node_version = '20.10.0'
local pnpm_dir = os.getenv('PNPM_GLOBAL') .. '/5/.pnpm/'

local function find_probes_dir()
  -- local working_dir = vim.fs.basename(vim.api.nvim_buf_attach)
  -- vim.print(working_dir)
  if vim.fn.isdirectory(pnpm_dir) ~= 0 then
    for name, type in vim.fs.dir(pnpm_dir, { depth = 1 }) do
      if name:match('typescript@[%d+.]+%d+') and type == 'directory' then
        return pnpm_dir
      end
    end
  end

  vim.print('returning asdf dir')
  return os.getenv('ASDF_DATA_DIR') .. '/installs/nodejs/' .. node_version .. '/lib/node_modules'
end

local angularls_cmd = {
  "ngserver",
  "--stdio",
  -- "--tsProbeLocations", find_probes_dir(),
  -- "--ngProbeLocations", find_probes_dir()
  "--tsProbeLocations", '/home/nela/.local/share/asdf/tools/installs/nodejs/20.10.0/lib/node_modules',
  "--ngProbeLocations", '/home/nela/.local/share/asdf/tools/installs/nodejs/20.10.0/lib/node_modules'
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
        -- ts_ls = {
        --   -- cmd = { "typescript-language-server --stdio" },
        --   keys = {
        --     { "<leader>oi", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
        --     { "<leader>tr", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" }
        --   },
        --   settings = {
        --     typescript = {
        --       format = {
        --         indentSize = vim.o.shiftwidth,
        --         convertTabsToSpaces = vim.o.expandtab,
        --         tabSize = vim.o.tabstop
        --       },
        --       inlayHints = {
        --         --[[ includeInlayEnumMemberValueHints = true,
        --         includeInlayFunctionLikeReturnTypeHints = true,
        --         includeInlayFunctionParameterTypeHints = true,
        --         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        --         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --         includeInlayPropertyDeclarationTypeHints = true,
        --         includeInlayVariableTypeHints = true, ]]
        --       },
        --     },
        --     javascript = {
        --       format = {
        --         indentSize = vim.o.shiftwidth,
        --         convertTabsToSpaces = vim.o.expandtab,
        --         tabSize = vim.o.tabstop
        --       },
        --       inlayHints = {
        --         --[[ includeInlayEnumMemberValueHints = true,
        --         includeInlayFunctionLikeReturnTypeHints = true,
        --         includeInlayFunctionParameterTypeHints = true,
        --         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        --         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --         includeInlayPropertyDeclarationTypeHints = true,
        --         includeInlayVariableTypeHints = true, ]]
        --       },
        --     },
        --     completions = {
        --       completeFunctionCalls = true
        --     }
        --   }
        -- },
        vtsls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.jsx'
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = {
                completeFunctionCalls = true
              }
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            }
          },
          --[[ keys = {
            {
              "<leader>gd",
              function()
                local params = vim.lsp.util.make_position_params()
                local opts = {
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position }
                }
                vim.lsp.buf_request_all(0, "workspace/executeCommand", opts, vim.lsp.handlers["textDocument/definition"])
              end,
              desc = "Goto Source Definition"
            }
          } ]]
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
        --[[ ts_ls = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end, ]]
        vtsls = function(_, opts)
          opts.settings.javascript =
          vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end
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
