return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          -- cmd = { "typescript-language-server --stdio" },
          -- settings = { },
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true
                }
              }
            }
          },
          settins = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true
            },
            provideFormatter = true
          }

          },
        },
      -- setup = {
      -- }

    },
  }
}
