local ts_utils = require("nvim-treesitter.ts_utils")
local lsp_signature = require("lsp_signature")
local navic = require("nvim-navic")
local lsp_bindings = require("nelsp.bindings")

local highlight_references = function()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil do
    local node_type = node:type()
    if node_type == "string"
        or node_type == "string_fragment"
        or node_type == "template_string"
        or node_type == "document" -- for inline gql`` strings
    then
      return
    end
    node = node:parent()
  end
  vim.lsp.buf.document_highlight()
end

local function nl(fn)
  return function()
    return fn()
  end
end

-- @param bufnr number
local buf_autocmd_document_highlight = function(bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    group = group,
    callback = highlight_references,
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = bufnr,
    group = group,
    callback = nl(vim.lsp.buf.clear_references)
  })
end

-- @param bufnr number
local buf_autocmd_codelens = function(bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
    buffer = bufnr,
    group = group,
    callback = nl(vim.lsp.codelens.refresh),
  })
end


return function(client, bufnr)
  -- Enable completion triggered by <C-x><C-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  lsp_bindings.set_buf_keymap(bufnr)
  lsp_bindings.set_commands()

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  if client.supports_method("textDocument/documentHighlight") then
    buf_autocmd_document_highlight(bufnr)
  end

  if client.supports_method("textDocument/codeLens") then
    buf_autocmd_codelens(bufnr)
    vim.schedule(vim.lsp.codelens.refresh)
  end

  lsp_signature.on_attach({
    bind = true,
    floating_window = false,
    hint_prefix = "",
    hint_scheme = "Comment",
  }, bufnr)

  if client.supports_method("textDocument/documentSymbol") then
    navic.attach(client, bufnr)
  end

end
