local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-x><C-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
  end
end

local lsp_installer = require('nvim-lsp-installer')
-- For Lsp snippet completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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

local sumneko_lua_settings = {
  Lua = { diagnostics = { globals = { 'vim' } } }
}

lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
      capabilities = capabilities
    }

    if server.name == 'jdtls' then
        vim.g.jdtls_ready = true
    elseif server.name == 'ltex' then
        opts.settings = ltex_settings
        opts.filetypes = { 'latex', 'tex', 'bib', 'markdown'  }
        server:setup(opts)
    elseif server.name == 'sumneko_lua' then
        opts.settings  = sumneko_lua_settings
        server:setup(opts)
    else
        server:setup(opts)
    end

    vim.cmd [[ do User LspAttachBuffers ]]
end)

-- local lspconfig = require('lspconfig')
vim.cmd([[ command LspFormatting lua vim.lsp.buf.formatting() ]])
vim.cmd([[ command LspSetLocList lua vim.diagnostic.setloclist() ]])
vim.cmd([[ command LspSetQfList lua vim.diagnostic.setqflist() ]])
vim.cmd([[ command LspAddWorkspaceFolder lua vim.lsp.buf.add_workspace_folder() ]])
vim.cmd([[ command LspRemoveWorkspaceFolder lua vim.lsp.buf.remove_workspace_folder() ]])
vim.cmd([[ command LspListWorkspaceFolders lua print(vim.inspect(vim.lsp.buf.list_workspace_folders())) ]])
vim.cmd([[ command LspRename lua vim.lsp.buf.rename() ]])
vim.cmd([[ command LspCodeAction lua vim.lsp.buf.code_action() ]])
