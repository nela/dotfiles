return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", opts = {}, ft = 'lua', event = 'VeryLazy' },
    },
    opts = {
      servers = {
        lua_ls = {
          cmd = { os.getenv('XDG_DATA_HOME') .. '/lsp/lua_ls/bin/lua-language-server' },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostic = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
              completion = { callSnippet = "Replace" },
            },
          },
        }
      }
    }
  }
}
