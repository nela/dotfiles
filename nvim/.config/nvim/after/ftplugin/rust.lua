--[[ vim.keymap.set("n", "<leader>ca", function()
  vim.cmd.RustLsp("codeAction")
end, { desc = "Code Action", buffer = bufnr })

vim.keymap.set("n", "<leader>dR", function()
  vim.cmd.RustLsp("debuggables")
end, { desc = "Rust Debuggables", buffer = bufnr }) ]]
