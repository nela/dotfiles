local nela_ns = vim.api.nvim_create_namespace('nela/lsp_float')

local function enhance_rename(handler)
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

---@param bufnr integer
local function add_inline_highlights(bufnr)
  for l, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    for pattern, hl_group in pairs {
      ['@S+'] = '@parameter',
      ['^%s*(Parameters:)'] = '@text.title',
      ['^%s*(Return:)'] = '@text.title',
      ['^%s*(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
      ['|%S-|'] = '@text.reference'
    } do
      local from = 1 ---@type integer?
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          vim.api.nvim_buf_set_extmark(bufnr, nela_ns, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param focusable boolean
---@return fun(err: any, result: any, ctx: any, config: any)
local function enhanced_float_handler(handler, focusable)
  return function(err, result, ctx, config)
    local buf, win = handler(err, result, ctx, vim.tbl_deep_extend('force', config or {} , {
      border = 'rounded',
      focusable = focusable,
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4)
    }))

    if not buf or not win then return end

    vim.wo[win].concealcursor = 'n'

    -- Extra highlighs
    add_inline_highlights(buf)

    -- keymas for opening links
    if focusable and not vim.b[buf].markdown_keys then
      local open = function()
        -- Vim help links
        local url = (vim.fn.expand '<cWORD>' --[[@as string]]):match('|(%S-)|')
        if url then return vim.cmd.help(url) end

        -- Markdown links
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = vim.api.nvim_get_current_line():find('%[.-%]%((%S-)%)')
        if from and col >= from and col <= to then
          vim.system({ 'xdg-open', url}, nil, function(res)
            if res.code ~= 0 then
              vim.notify('Failed to open URL ' .. url, vim.log.levels.ERROR)
            end
          end)
        end
      end

      vim.keymap.set('n', 'K', open, { buffer = buf, silent = true })
      vim.b[buf].markdown_keys = true
    end
  end
end

local function dynamic_capabilities(handler)
  return function(err, res, ctx)
    local ret = handler(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds('User', {
          pattern = 'LspDynamicCapability',
          data = { client_id = client.id, buffer = buffer }
        })
      end
    end
    return ret
  end
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'rounded', focusable = false
  }
)

vim.lsp.handlers['client/registerCapability'] = dynamic_capabilities(vim.lsp.handlers['client/registerCapability'])
vim.lsp.handlers['textDocument/rename'] = enhance_rename(vim.lsp.handlers['textDocument/rename'])
vim.lsp.handlers['textDocument/hover'] = enhanced_float_handler(vim.lsp.handlers.hover, true)
vim.lsp.handlers['textDocuments/signatureHelp'] = enhanced_float_handler(vim.lsp.handlers.signature_help, false)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'rounded', focusable = false
  }
)

vim.lsp.handlers['textDocument/rename'] = enhance_rename(vim.lsp.handlers['textDocument/rename'])
vim.lsp.handlers['textDocument/hover'] = enhanced_float_handler(vim.lsp.handlers.hover, true)
vim.lsp.handlers['textDocuments/signatureHelp'] = enhanced_float_handler(vim.lsp.handlers.signature_help, false)
