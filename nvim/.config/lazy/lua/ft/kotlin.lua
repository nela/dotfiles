return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {
          cmd = { os.getenv('XDG_DATA_HOME') .. '/lsp/kotlin-language-server/bin/kotlin-language-server' },

        }
      }
    }
  }
}
