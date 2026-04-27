--  brew install bash-language-server
--  also uses shellcheck if installed: brew install shellcheck

---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'zsh', 'sh', 'bash' },
}
