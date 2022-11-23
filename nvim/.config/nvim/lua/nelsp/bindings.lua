local nelescope_lsp = require("nelescope.lsp")
local nelsp_utils = require("nelsp.utils")

local M = {}

local goto_prev_error = function()
  vim.diagnostic.goto_prev { severity = "Error" }
end

local goto_next_error = function()
  vim.diagnostic.goto_next { severity = "Error" }
end

M.set_buf_keymap = function(bufnr)
  -- print("buf set keymaps")
  local buf_set_keymap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- Code actions
  buf_set_keymap("n", "<leader>rn", vim.lsp.buf.rename)
  buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action)

  buf_set_keymap("n", "<leader>cl", nelsp_utils.find_and_run_codelens)

  -- Movement
  buf_set_keymap("n", "<leader>gD", vim.lsp.buf.declaration)
  buf_set_keymap("n", "<leader>gd", nelescope_lsp.definitions)
  -- buf_set_keymap("n", "gd", vim.lsp.buf.definitions)
  buf_set_keymap("n", "<leader>gr", nelescope_lsp.references)
  buf_set_keymap("n", "<leader>gbr", nelescope_lsp.buffer_references)
  buf_set_keymap("n", "<leader>gi", nelescope_lsp.implementations)
  buf_set_keymap("n", "<leader>ds", nelescope_lsp.document_symbols)

  -- Docs
  buf_set_keymap("n", "K", vim.lsp.buf.hover)
  buf_set_keymap("n", "<leader>t", vim.lsp.buf.signature_help)
  buf_set_keymap("i", "<C-s>", vim.lsp.buf.signature_help)

  -- Diagnostics
  buf_set_keymap("n", "<leader>fd", nelescope_lsp.document_diagnostics)
  buf_set_keymap("n", "],", vim.diagnostic.open_float)

  buf_set_keymap("n", "<leader>ws", nelescope_lsp.workspace_symbols)
  buf_set_keymap("n", "<leader>wd", nelescope_lsp.workspace_diagnostics)

  buf_set_keymap({ "n", "v" }, "[e", goto_prev_error)
  buf_set_keymap({ "n", "v" }, "]e", goto_next_error)
  buf_set_keymap({ "n", "v" }, "[d", vim.diagnostic.goto_prev)
  buf_set_keymap({ "n", "v" }, "]d", vim.diagnostic.goto_next)

end

M.set_commands = function()
  -- print("set commands")

  local command = function(name, cmd)
    vim.api.nvim_create_user_command(name, cmd, {})
  end

  command("LspLog", [[exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()")]])
  command("LspFormat", function() nelsp_utils.pick_formatter() end)
  command("LspSetLocList", function() vim.diagnostic.setloclist() end)
  command("LspSetQfList", function() vim.diagnostic.setqflist() end)
  command("LspAddWorkspaceFolder", function() vim.lsp.buf.add_workspace_folder() end)
  command("LspRemoveWorkspaceFolder", function() vim.lsp.buf.remove_workspace_folder() end)
  command("LspListWorkspaceFolders", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
  command("LspRename", function() vim.lsp.buf.rename() end)
  command("LspCodeAction", function() vim.lsp.buf.code_action() end)
  command("RmLspLog", [[ exe 'silent ! rm $XDG_STATE_HOME/nvim/lsp.log' ]])
end

return M
