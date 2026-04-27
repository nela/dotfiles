---@type vim.lsp.Config

return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  -- init_options = { provide_formatter = false }
}
