local M = {}

local set_commands = function(bufnr)
  local command = function(name, cmd)
    vim.api.nvim_buf_create_user_command(bufnr, name, cmd, {})
  end

  command("LspLog", [[exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()")]])
  command("LspFormat", function() require('plugins.lsp.format').pick_formatter(bufnr) end)
  command("LspSetLocList", function() vim.diagnostic.setloclist() end)
  command("LspSetQfList", function() vim.diagnostic.setqflist() end)
  command("LspAddWorkspaceFolder", function() vim.lsp.buf.add_workspace_folder() end)
  command("LspRemoveWorkspaceFolder", function() vim.lsp.buf.remove_workspace_folder() end)
  command("LspListWorkspaceFolders", function() vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
  command("LspRename", function() vim.lsp.buf.rename() end)
  command("LspCodeAction", function() vim.lsp.buf.code_action() end)
  command("RmLspLog", [[ exe 'silent ! rm $XDG_STATE_HOME/nvim/lsp.log' ]])
end

M.on_attach = function(_, bufnr)
  set_commands(bufnr)
end

return M
