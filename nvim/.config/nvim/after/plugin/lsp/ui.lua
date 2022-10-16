local sd = vim.fn.sign_define

sd("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "YellowSign"})
sd("DiagnosticSignError", { texthl = "DiagnosticSignError", numhl = "RedSign"})
sd("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", numhl = "BlueSign"})
sd("DiagnosticSignHint", { texthl = "DiagnosticSignHint", numhl = "AquaSign"})

vim.diagnostic.config({
  float = {
    show_header = true,
    border = "rounded",
    source = "always",
    format = function(d)
      local t = vim.deepcopy(d)
      local code = d.code or d.user_data.lsp.code
      if code then
        t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
      end
      return t.message
    end,
  },
  severity_sort = true,
  update_in_insert = false,
})
