-- LSP Server to use for Rust.
-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer.
-- only for diagnostics. The rest of LSP support will still be
-- provided by rust-analyzer.
-- local codelldb = '/usr/bin/codelldb'
-- local liblldb = '/usr/lib/codelldb/lldb/lib/liblldb.so'
local codelldb = '/Users/nela/dev/codelldb/extension/adapter/codelldb'
local liblldb = '/Users/nela/dev/codelldb/extension/lldb/lib/liblldb.so'

return {
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    enabled = true,
    version = '^6',
    ft = { 'rust' },
    lazy = false,
    opts = {},
    config = function(_, opts)
      vim.g.rustaceanvim = function()
        if vim.fn.executable('rust-analyzer') == 0 then
          vim.notify(
            '**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/',
            vim.log.levels.ERROR
          )
        end

        return {

          tools = {
            code_actions = {
              keys = {
                confirm = '<C-y>',
              },
            },
          },

          server = {
          --stylua: ignore
            on_attach = function(_, bufnr)
              vim.keymap.set("n", "<leader>dR", function()
                vim.cmd.RustLsp("debuggables")
              end, { desc = "Rust Debuggables", buffer = bufnr })
            end,
            default_settings = {
              ['rust-analyzer'] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  buildScripts = {
                    enable = true,
                  },
                },
                -- Add clippy lints for Rust if using rust-analyzer
                checkOnSave = vim.g.rust_diagnostics_engine == 'rust-analyzer',
                -- Enable diagnostics if using rust-analyzer
                diagnostics = {
                  enable = vim.g.rust_diagnostics_engine == 'rust-analyzer',
                },
                procMacro = {
                  enable = true,
                  ignored = {
                    ['async-trait'] = { 'async_trait' },
                    ['napi-derive'] = { 'napi' },
                    ['async-recursion'] = { 'async_recursion' },
                  },
                },

                files = {
                  excludeDirs = {
                    '.direnv',
                    '.git',
                    '.github',
                    '.gitlab',
                    'bin',
                    'node_modules',
                    'target',
                    'venv',
                    '.venv',
                  },
                },
              },
            },
          },
          dap = {
            adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb, liblldb),
          },
        }
      end
    end,
  },
  --[[ {
    'nvim-neotest/neotest',
    dependencies = {
      'rouge8/neotest-rust',
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      -- 'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    -- optional = true,
    opts = function()
      return {
        adapters = {
          require('rustaceanvim.neotest'),
        },
      }
    end,
  }, ]]
}
