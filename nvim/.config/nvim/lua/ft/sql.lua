
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        postgres_lsp = {
          cmd = { "postgrestools", "lsp-proxy" },
          filetypes = { "sql" }
        }
      },
    }
  }
}
