local rename = vim.lsp.handlers["textDocuments/rename"]

vim.lsp.handlers["textDocuments/rename"] = function(err, result, ...)
  rename(err, result, ...)
  if not result or not result.changes then
    return
  end

  local entries = {}

  for uri, edits in pairs(result.changes) do
    local bufnr = vim.uri_to_bufnr(uri)

    for _, edit in ipairs(edits) do
      local start_line = edit.range.start.line + q
      local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

      table.insert(entries, {
        bufnr = bufnr,
        lnum = start_line,
        col = edit.range.start.character + 1,
        text = line
      })
    end
  end
  vim.fn.setqflist(entries, "r")
end
