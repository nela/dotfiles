-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
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
      ]],
      false
    )
  end

  vim.cmd [[
    sign define DiagnosticSignError text= texthl= linehl= numhl=DiagnosticSignError
    sign define DiagnosticSignWarn text= texthl= linehl= numhl=DiagnosticSignWarn
    sign define DiagnosticSignInfo text= texthl= linehl= numhl=DiagnosticSignInfo
    sign define DiagnosticSignHint text= texthl= linehl= numhl=DiagnosticSignHint
  ]]

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
     motherTongue = 'sv',
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

vim.diagnostic.config({
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
    -- spacing = 6,
    prefix = ''
  },
  -- signs = false
})

-- Go to definition in a split window
local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require('vim.lsp.log')
  local api = vim.api

  -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
  local handler = function(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, 'No location found')
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command('copen')
        api.nvim_command('wincmd p')
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

vim.lsp.handlers['textDocument/definition'] = goto_definition('split')
