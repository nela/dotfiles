---@type vim.lsp.Config
return {
  root_markers = { 'compile_commands.json', '.clangd' },
  --[[ capabilities = {
      offsetEncoding = { "utf-16" },
    }, ]]
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  filetypes = { 'c', 'cpp' }
}
