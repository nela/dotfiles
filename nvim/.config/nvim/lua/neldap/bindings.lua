local M = {}

M.buf_set_keymaps = function(bufnr)
  local buf_set_keymap = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
  end

  buf_set_keymap("<F5>", require("dap").continue)
  buf_set_keymap("<F10>", require("dap").step_over)
  buf_set_keymap("<F11>", require("dap").step_into)
  buf_set_keymap("<F12>", require("dap").step_out)
  buf_set_keymap("<leader>b", require("dap").toggle_breakpoint)
  buf_set_keymap("<leader>B", require("dap").set_breakpoint)
  buf_set_keymap("<leader>lp", require("dap").set_breakpoint)
  buf_set_keymap("<leader>dr", require("dap").repl.open)
  buf_set_keymap("<leader>dl", require("dap").run_last)
end

return M
