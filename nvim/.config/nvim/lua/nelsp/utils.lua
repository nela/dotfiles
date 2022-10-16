local M = {}

M.find_and_run_codelens = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lenses = vim.lsp.codelens.get(bufnr)

  lenses = vim.tbl_filter(function(lense)
    return lense.range.start.line < row
  end, lenses)

  if #lenses == 0 then
    return vim.api.nvim_echo(
      { { "Could not find codelens to run.", "WarningMsg" } },
      false,
      {})
  end

  table.sort(lenses, function(a, b)
    return a.range.start.line > b.range.start.line
  end)

  vim.api.nvim_win_set_cursor(0, { lenses[1].range.start.line + 1, 0 })
  vim.lsp.codelens.run()
  vim.api.nvim_win_set_cursor(0, { row, col })
end

local function format(client)
  vim.api.nvim_echo({ { ("Formatting with %s…"):format(client.name) } }, false, {})
  vim.lsp.buf.format { id = client.id }
end

M.pick_formatter = function()
  local candidates = vim.tbl_filter(function(client)
    return client.name ~= client.supports_method "textDocument/formatting"
  end, vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() }))

  if #candidates > 1 then
    vim.ui.select(candidates, {
      prompt = "Client",
      format_item = function(client) return client.name end,
    }, function(client) if client then format(client) end end)
  elseif #candidates == 1 then
    format(candidates[1])
  else
    vim.api.nvim_echo(
      { { "No clients that support textDocument/formmating are attached.", " WarningMsg" } },
      false,
      {})
  end
end

return M
