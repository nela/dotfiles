---@type vim.lsp.Config
return {
  cmd = { "codebook-lsp", "server" },
  filetype = { "c", "css", "go", "haskell", "html", "javascript", "javascriptreact", "markdown", "python", "php", "ruby", "rust", "toml", "text", "typescript", "typescriptreact" },
  root_markers = { ".git", "codebook.toml", ".codebook.toml" }
}
