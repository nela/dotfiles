return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "scss", "css" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {
          settings = {
            css = {
              lint = { unknownAtRules = "ignore" },
              validate = true },
            scss = {
              lint = { unknownAtRules = "ignore" },
              validate = true
            },
          },
          cmd = { "vscode-css-language-server", "--stdio" }
        },
      }
    }
  }
}
