
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", opts = {}, ft = 'lua', event = 'VeryLazy' },
    },
    opts = {
      servers = {
        pyright = {
          cmd = { 'pyright-langserver', '--stdio' },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true
              }
            },
          },
        }
      }
    }
  }
}
