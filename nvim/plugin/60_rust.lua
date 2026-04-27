local codelldb = '/Users/nela/dev/codelldb/extension/adapter/codelldb'
local liblldb = '/Users/nela/dev/codelldb/extension/lldb/lib/liblldb.so'
local now, later, gh = Config.now, Config.later, Config.gh

now(function()
  vim.pack.add({
    { src = gh('mrcjkb/rustaceanvim'), version = vim.version.range('^9') },
  })

  vim.g.rustaceanvim = function()
    vim.print('rrustuns')
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
end)

-- FIXME think on this
later(function()
  vim.pack.add({
    gh('Saecki/crates.nvim'),
  })

  require('crates').setup({
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
  })
end)
