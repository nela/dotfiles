local rename = vim.lsp.handlers["textDocuments/rename"]

local parse_edits = function(entries, bufnr, text_edits)
  for _, edit in ipairs(text_edits) do
    local start_line = edit.range.start.line + 1
    local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
    table.insert(entries, {
      bufnr = bufnr,
      lnum = start_line,
      col = edit.range.start.character + 1,
      text = line,
    })
  end
end

vim.lsp.handlers["textDocuments/rename"] = function(err, result, ...)
  rename(err, result, ...)
  if err then return end

  local entries = {}
  if result.changes then
    for uri, edits in pairs(result.changes) do
      local bufnr = vim.uri_to_bufnr(uri)
      parse_edits(entries, bufnr, edits)
    end
  elseif result.documentChanges then
    for _, doc_change in ipairs(result.documentChanges) do
      if doc_change.textDocument then
        local bufnr = vim.uri_to_bufnr(doc_change.textDocument.uri)
        parse_edits(entries, bufnr, doc_change.edits)
      else
        vim.notify(("Failed to parse TextDocumentEdit of kind: $s"):format(doc_change.kind or "N/A"))
      end
    end
  end
  vim.fn.setqflist(entries)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
      format = function (diagnostic)
        if diagnostic.severity == vim.diagnostic.severity.HINT then
          return string.format('H: %s', diagnostic.message)
        elseif diagnostic.severity == vim.diagnostic.severity.INFO then
          return string.format('I: %s', diagnostic.message)
        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
          return string.format('W: %s', diagnostic.message)
        elseif diagnostic.severity == vim.diagnostic.severity.ERROR then
          return string.format('E: %s', diagnostic.message)
        end
        return diagnostic.message
      end,
      spacing = 6,
      prefix = "",
    },
})
