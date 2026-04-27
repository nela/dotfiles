---@type vim.lsp.Config
return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "hcl" },
  root_dir = require("lspconfig.util").root_pattern(".terraform", ".git"),
}
