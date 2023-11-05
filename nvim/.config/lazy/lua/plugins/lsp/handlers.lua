local M = {}

--dynamic capability registration - might be changed
-- follow https://github.com/neovim/neovim/issues/24229
---@param on_attach fun(client, buffer)
---@param original_handler fun(err, res, ctx)
function M.dynamic_capability_registration(on_attach, original_handler)
  return function(err, res, ctx)
    local ret = original_handler(err, res, ctx)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local buf = vim.api.nvim_get_current_buf()
    on_attach(client, buf)
    return ret
  end
end

function M.enhance_rename(handler)
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

  return function(err, result, ...)
    handler(err, result, ...)
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
    vim.cmd("copen")
  end
end


local nela_ns = vim.api.nvim_create_namespace('nela/lsp_float')

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@return function
function M.enhance_float_handler(handler)
  return function(err, result, ctx, config)
    local buf, win = handler(err, result, ctx, vim.tbl_deep_extend('force', config or {} , {
      border = 'rounded',
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4)
    }))

    if not buf or not win then
      return
    end

    vim.wo[win].concealcursor = 'n'

    -- Extra highlighs
    for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      for pattern, hl_group in pairs {
        ['|%S-|'] = '@text.reference',
        ['@S+'] = '@parameter',
        ['^%s*(Parameters:)'] = '@text.title',
        ['^%s*(Return:)'] = '@text.title',
        ['^%s*(See also:)'] = '@text.title',
        ['{%S-}'] = '@parameter'
      } do

        ---@type integer?
        local from = 1
        while from do
          local to
          from, to = line:find(pattern, from)
          if from then
            vim.api.nvim_buf_set_extmark(buf, nela_ns, l - 1, from - 1, {
              end_col = to,
              hl_group = hl_group
            })
          end
          from = to and to + 1 or nil
        end
      end
    end
  end
end

return M
