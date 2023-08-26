local M = {}

function M.redefine_diagnostic_signs()
  local sign_define = vim.fn.sign_define

  sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "DiagnosticSignWarn" })
  sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
  sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", numhl ="DiagnosticSignInfo" })
  sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", numhl ="DiagnosticSignHint" })
end

return M
