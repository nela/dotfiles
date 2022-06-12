-- Copied from
-- https://github.com/williamboman/nvim-config/blob/main/plugin/lsp/setup.lua
local ok, util = pcall(require, "lspconfig.util")
if not ok then
  return
end

local ts_utils = require("nvim-treesitter.ts_utils")
local lsp_signature = require "lsp_signature"
local bindings = require("nelsp.bindings")

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

  bindings.buf_set_keymaps(bufnr)
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

-- local lsp_installer = require('nvim-lsp-installer')
-- local lspconfig = require('lspconfig')

-- local servers = lsp_installer.get_installed_servers()

-- local on_attach = function(client, bufnr)
--     local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--
--
--     local opts = { noremap = true, silent = true }
--
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--     buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--     buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--     buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--     buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--     buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--     buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--     buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--     buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--     buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
--     buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
--     buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- if client.resolved_capabilities.document_highlight then
--   vim.api.nvim_exec(
--     [[
--       augroup lsp_document_highlight
--         autocmd!
--         autocmd CursorHold *\(.tex\|.md\)\@<! lua vim.lsp.buf.document_highlight()
--         autocmd CursorMoved *\(.tex\|.md\)\@<! lua vim.lsp.buf.clear_references()
--       augroup END
--     ]], false)
-- end

-- lsp_installer.setup{}
-- for _, s in pairs(servers) do
--   -- print(i)
--   vim.pretty_print(s.name)
--   if s.name == 'jdtls' then
--     vim.g.jdtls_ready = true
--   elseif s.name == 'sumneko_lua' then
--     lspconfig[s.name].setup {
--       on_attach = on_attach,
--       capabilities = capabilities,
--       settings = sumneko_lua_settings,
--     }
--   elseif s.name == 'ltex' then
--     print('ltex')
--   else
--     lspconfig[s.name].setup {
--       on_attach = on_attach,
--       capabilities = capabilities
--     }
--   end
--
-- end

-- lsp_installer.on_server_ready(function(server)
--     local opts = {
--       on_attach = on_attach,
--       flags = { debounce_text_changes = 150 },
--       capabilities = capabilities
--     }
--
--     if server.name == 'jdtls' then
--         vim.g.jdtls_ready = true
--     elseif server.name == 'ltex' then
--         opts.settings = ltex_settings
--         opts.filetypes = { 'latex', 'tex', 'bib', 'markdown'  }
--         -- server:setup(opts)
--     elseif server.name == 'sumneko_lua' then
--         opts.settings  = sumneko_lua_settings
--         server:setup(opts)
--     else
--         server:setup(opts)
--     end
--
--     vim.cmd [[ do User LspAttachBuffers ]]
-- end)

-- local lspconfig = require('lspconfig')
-- vim.cmd([[ command LspFormatting lua vim.lsp.buf.formatting() ]])
-- vim.cmd([[ command LspSetLocList lua vim.diagnostic.setloclist() ]])
-- vim.cmd([[ command LspSetQfList lua vim.diagnostic.setqflist() ]])
-- vim.cmd([[ command LspAddWorkspaceFolder lua vim.lsp.buf.add_workspace_folder() ]])
-- vim.cmd([[ command LspRemoveWorkspaceFolder lua vim.lsp.buf.remove_workspace_folder() ]])
-- vim.cmd([[ command LspListWorkspaceFolders lua print(vim.inspect(vim.lsp.buf.list_workspace_folders())) ]])
-- vim.cmd([[ command LspRename lua vim.lsp.buf.rename() ]])
-- vim.cmd([[ command LspCodeAction lua vim.lsp.buf.code_action() ]])
