-- Copied from
-- https://github.com/williamboman/nvim-config/blob/main/plugin/lsp/setup.lua
local ok, util = pcall(require, "lspconfig.util")
if not ok then
  return
end

local ts_utils = require("nvim-treesitter.ts_utils")
local lsp_signature = require "lsp_signature"
local bindings = require("bindings.lsp")

require("nvim-lsp-installer").setup {
  -- ensure_installed = { "sumneko_lua", "jsonls", "yamlls", "bashls" },
}

local create_capabilities = function(opts)
  local defaults = { with_snippet_support = true }
  opts = opts or defaults
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
  if opts.with_snippet_support then
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    }
  end
  return capabilities
end

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
    callback = vim.lsp.buf.clear_references,
  })
end

-- @param bufnr number
local buf_autocmd_codelens = function(bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
    buffer = bufnr,
    group = group,
    callback = vim.lsp.codelens.refresh,
  })
end

local common_on_attach = function(client, bufnr)
  -- Enable completion triggered by <C-x><C-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  bindings.set_buf_keymap(bufnr)
  bindings.set_commands()

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

  require("nvim-navic").attach(client, bufnr)
end

util.on_setup = util.add_hook_after(util.on_setup, function(config)
  if config.on_attach then
    config.on_attach = util.add_hook_after(config.on_attach, common_on_attach)
  else
    config.on_attach = common_on_attach
  end
  local capabilities = create_capabilities()
  config.capabilities = capabilities
  -- For Lsp snippet completion
  require('cmp_nvim_lsp').update_capabilities(capabilities)
end)
