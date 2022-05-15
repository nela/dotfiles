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

-- Go to definition in a split window
-- local function goto_definition(split_cmd)
--   local util = vim.lsp.util
--   local log = require('vim.lsp.log')
--   local api = vim.api
--
--   -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
--   local handler = function(_, result, ctx)
--     if result == nil or vim.tbl_isempty(result) then
--       local _ = log.info() and log.info(ctx.method, 'No location found')
--       return nil
--     end
--
--     if split_cmd then
--       vim.cmd(split_cmd)
--     end
--
--     if vim.tbl_islist(result) then
--       util.jump_to_location(result[1])
--
--       if #result > 1 then
--         util.set_qflist(util.locations_to_items(result))
--         api.nvim_command('copen')
--         api.nvim_command('wincmd p')
--       end
--     else
--       util.jump_to_location(result)
--     end
--   end
--
--   return handler
-- end
--
-- vim.lsp.handlers['textDocument/definition'] = goto_definition('split')
