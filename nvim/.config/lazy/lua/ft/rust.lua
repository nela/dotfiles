return {
 {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = true,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },
   {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
      end
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    opts = function()
      local extension_path = os.getenv("HOME") .. "/extension"
      local codelldb_path =  extension_path .. "/adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      Adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)

      return {
        dap = {
          adapter = Adapter,
        },
        tools = {
          on_initialized = function()
            -- print('rust_tools on_initialized')
            vim.cmd([[
                  augroup RustLSP
                    autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                    autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                  augroup END
                ]])
          end,
        },
      }
    end,

    config = function() end,
  },

 -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          cmd = { os.getenv('ASDF_DATA_DIR') .. '/installs/rust-analyzer/2023-09-11/bin/rust-analyzer' },
          keys = {
            { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
            { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
            { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
          },

          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },

              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function(_, opts)
          local rust_tools_opts = require("util").opts("rust-tools.nvim")
          require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
          return true
        end,
      },
    },
  },
  --[[ {
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

        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "codelldb",
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
  } ]]
  --[[ {
    "nvim-neotest/neotest",
    optional = true,

    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-rust"] = {},
      },
    },
  }, ]]
}
