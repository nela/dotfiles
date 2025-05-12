return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "terraform" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          cmd = { "terraform-ls", "serve" },
          filetypes = { "terraform", "hcl" },
          root_dir = require("lspconfig.util").root_pattern(".terraform", ".git")
        }
      }
    }
  }
}
