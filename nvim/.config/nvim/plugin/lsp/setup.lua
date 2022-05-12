-- Copied from
-- https://github.com/williamboman/nvim-config/blob/main/plugin/lsp/setup.lua
local ok, util = pcall(require, "lspconfig.util")
if not ok then
    return
end

local ts_utils = require("nvim-treesitter.ts_utils")
local nelescope_lsp = require("nelescope.lsp")
local lsp_signature = require "lsp_signature"

vim.api.nvim_create_user_command("LspLog", [[exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()")]], {})

require("nvim-lsp-installer").setup {
  -- ensure_installed = { "sumneko_lua", "jsonls", "yamlls", "bashls" },
}

local create_capabilities = function(opts)
  local defaults = { with_snippet_support = true }
  opts = opts or defaults
  -- For Lsp snippet completion
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
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  return capabilities
end

local highlight_references = function()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil do
    local node_type = node:type()
    if
      node_type ==  "string"
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
local  buf_autocmd_document_highlight = function(bufnr)
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

local find_and_run_codelens = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lenses = vim.lsp.codelens.get(bufnr)

  lenses = vim.tbl_filter(function(lense)
    return lense.range.start.line < row
  end, lenses)

  if #lenses == 0 then
    return vim.notify "Could not fine codelens to run."
  end

  table.sort(lenses, function(a, b)
    return a.range.start.line > b.range.start.line
  end)

  vim.api.nvim_win_set_cursor(0 , { lenses[1].range.start.line + 1, 0 })
  vim.lsp.codelens.run()
  vim.api.nvim_win_set_cursor(0, { row, col })
end

local goto_prev_error = function()
      vim.diagnostic.goto_prev { severity = "Error" }
end

local goto_next_error = function()
      vim.diagnostic.goto_next { severity = "Error" }
end

local buf_set_keymaps = function(bufnr)
  local buf_set_keymap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true })
  end

  -- Code actions
  buf_set_keymap("n", "<leader>rn", vim.lsp.buf.rename)
  buf_set_keymap("n", "<leader>ca", vim.lsp.code_action)

  buf_set_keymap("n", "<leader>cl", find_and_run_codelens)

  -- Movement
  buf_set_keymap("n", "gD", vim.lsp.buf.declarations)
  buf_set_keymap("n", "gd", nelescope_lsp.definitions)
  -- buf_set_keymap("n", "gd", vim.lsp.buf.definitions)
  buf_set_keymap("n", "gr", nelescope_lsp.references)
  buf_set_keymap("n", "gbr", nelescope_lsp.buffer_references)
  buf_set_keymap("n", "gI", nelescope_lsp.implementations)
  buf_set_keymap("n", "<leader>s", nelescope_lsp.document_symbols)

  -- Docs
  buf_set_keymap("n", "K", vim.lsp.buf.hover)
  buf_set_keymap("n", "<leader>t", vim.lsp.buf.signature_help)
  buf_set_keymap("i", "<C-s>", vim.lsp.buf.signature_help)

  -- Diagnostics
  buf_set_keymap("n", "<leader>d", nelescope_lsp.document_diagnostics)
  buf_set_keymap("n", "],", vim.diagnostic.open_float)

  buf_set_keymap("n", "<leader>ws", nelescope_lsp.workspace_symbols)
  buf_set_keymap("n", "<leader>wd", nelescope_lsp.workspace_diagnostics)


  for _, mode in pairs { "n", "v" } do
    buf_set_keymap(mode, "[e", goto_prev_error)
    buf_set_keymap(mode, "]e", goto_next_error)
    buf_set_keymap(mode, "[d", vim.diagnostic.goto_prev)
    buf_set_keymap(mode, "]d", vim.diagnostic.goto_next)
  end

end


local common_on_attach = function(client, bufnr)
  -- Enable completion triggered by <C-x><C-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  buf_set_keymaps(bufnr)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  if client.supports_method("textDocuments/documentHighligh") then
    buf_autocmd_document_highlight(bufnr)
  end

  if client.supports_method("textDocuments/codeLens") then
    buf_autocmd_codelens(bufnr)
    vim.schedule(vim.lsp.codelens.refresh)
  end

  lsp_signature.on_attach({
    bind = true,
    floating_window = false,
    hint_prefix = "",
    hint_scheme = "Comment",
  }, bufnr)
end

util.on_setup = util.add_hook_after(util.on_setup, function(config)
  if config.on_attach then
    config.on_attach = util.add_hook_after(config.on_attach, common_on_attach)
  else
    config.on_attach = common_on_attach
  end
  config.capabilities = create_capabilities()
end)

local ltex_settings = {
  ltex = {
    enabled = { 'latex', 'tex', 'bib', 'markdown' },
    language = 'en-GB',
    diagnosticSeverity = 'information',
    setenceCacheSize = 2000,
    additionalRules = {
     enablePickyRules = true,
    },
    trace = { server = 'verbose' },
    dictionary = {},
    enabledRules = {},
    disabledRules = {},
    hiddenFalsePositives = {},
  }
}

ltex_settings.ltex.disabledRules['en-GB'] = { 'PASSIVE_VOICE' }
ltex_settings.ltex.enabledRules['en-GB'] = { 'TEXT_ANALYSIS' }


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
