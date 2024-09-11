for _, level in ipairs({ 'Hint', 'Info', 'Warn', 'Error'}) do
  local sign = 'DiagnosticSign' .. level
  vim.fn.sign_define(sign, { texthl = sign, numhl = sign})
end
--
vim.diagnostic.config({
  float = {
    show_header = true,
    border = "rounded",
    source = "if_many",
  },
  severity_sort = true,
  update_in_insert = false,
})
