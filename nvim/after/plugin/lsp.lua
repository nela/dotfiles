local methods = vim.lsp.protocol.Methods

vim.g.inlay_hints = false

vim.api.nvim_create_user_command('ToggleInlayHints', function()
  vim.g.inlay_hints = not vim.g.inlay_hints
end, {})

local function debounce(ms, fn)
  local timer = assert(vim.uv.new_timer())
  return function(...)
    local argc, argv = select('#', ...), { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule(function()
        fn(unpack(argv, 1, argc))
      end)
    end)
  end
end

---@param name string
local augroup = function(name)
  return vim.api.nvim_create_augroup('nela.lsp.' .. name, { clear = false })
end

--[[ ---@param jumpCount integer
local function pretty_jump(jumpCount)
  pcall(vim.api.nvim_del_augroup_by_name, "nela.lsp.pretty_jump") -- prevent autocmd for repeated jumps

  vim.diagnostic.jump({ count = jumpCount })

  local orig_virtual_text_conf = vim.diagnostic.config().virtual_text
  local orig_virtual_lines_conf = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({
    -- virtual_text = false
    virtual_lines = { current_line = true },
  })

  vim.defer_fn(function() -- deferred to not trigger by jump itself
    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "User(once): Reset diagnostics virtual lines",
      once = true,
      group = vim.api.nvim_create_augroup("nela.lsp.pretty_jump", {}),
      callback = function()
        vim.diagnostic.config({ virtual_lines = orig_virtual_lines_conf, virtual_text = orig_virtual_text_conf })
      end,
    })
  end, 1)
end ]]

local function disable_virt_text_jump(count)
  pcall(vim.api.nvim_del_augroup_by_name, 'nela.lsp.pretty_jump') -- prevent autocmd for repeated jumps

  vim.diagnostic.jump({ count = count })

  local orig_virtual_text_conf = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({
    virtual_text = false,
    -- virtual_lines = { current_line = true },
  })

  vim.defer_fn(function() -- deferred to not trigger by jump itself
    vim.api.nvim_create_autocmd('CursorMoved', {
      desc = 'User(once): Reset diagnostics virtual lines',
      once = true,
      group = vim.api.nvim_create_augroup('nela.lsp.pretty_jump', {}),
      callback = function()
        vim.diagnostic.config({ virtual_lines = false, virtual_text = orig_virtual_text_conf })
      end,
    })
  end, 1)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  if client:supports_method(methods.textDocument_codeLens) then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
    vim.api.nvim_create_autocmd({ 'FocusGained', 'WinEnter', 'BufEnter', 'CursorMoved' }, {
      group = augroup('codelens'),
      callback = debounce(200, function(args0)
        vim.lsp.codelens.refresh({ bufnr = args0.buf })
      end),
    })
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    local cursor_highlights = augroup('cursor_highlights')
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = cursor_highlights,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      -- callback = debounce(200, vim.lsp.buf.document_highlight)
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = cursor_highlights,
      desc = 'Clear highlight references',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    -- local inlay_hints_group = augroup('toggle_inlay_hints')

    if vim.g.inlay_hints then
      -- Initial inlay hint display.
      -- Idk why but without the delay inlay hints aren't displayed at the very start.
      debounce(500, function()
        local mode = vim.api.nvim_get_mode().mode
        vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
      end)
    end

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = augroup('inlay_hints'),
      desc = 'Enable inlay hints',
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then -- TODO fix inlay together with inlay toggle logic
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end,
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
      group = augroup('inlay_hints'),
      desc = 'Disable inlay hints',
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })
  end

  local keymap = {
    {
      lhs = '<leader>ld',
      --stylua: ignore
      rhs = function() vim.diagnostic.open_float() end,
      opts = { desc = 'Line Diagnostics' },
    },
    {
      lhs = '<leader>li',
      rhs = '<cmd>LspInfo<cr>',
      opts = { desc = 'Lsp Info' },
    },
    {
      lhs = '<leader>gd',
      rhs = function()
        require('fzf-lua').lsp_definitions({
          sync = true,
          -- jump_to_single_result = true,
          jump1 = false,
          -- jump1_action = require('fzf-lua.actions').file_vsplit
        })
      end,
      -- rhs = "<cmd>FzfLua lsp_definitions<cr>",
      opts = { desc = 'Go to Definitions' },
      has_method = methods.textDocument_definition,
    },
    {
      lhs = '<leader>gr',
      rhs = '<cmd>FzfLua lsp_references<cr>',
      opts = { desc = 'References' },
      has_method = methods.textDocument_references,
    },
    {
      lhs = '<leader>gs',
      rhs = '<cmd>FzfLua lsp_document_symbols<cr>',
      opts = { desc = 'Get document symbols' },
      has_method = methods.textDocument_documentSymbol,
    },
    {
      lhs = '<leader>gD',
      rhs = vim.lsp.buf.declaration,
      opts = { desc = 'Goto Declaration' },
      has_method = methods.textDocument_declaration,
    },
    {
      lhs = '<leader>gI',
      rhs = '<cmd>FzfLua lsp_implementation<cr>',
      opts = { desc = 'Goto Implementation' },
      has_method = methods.textDocument_implementation,
    },
    {
      lhs = '<leader>gy',
      rhs = '<cmd>FzfLua lsp_typedefs<cr>',
      opts = { desc = 'Goto T[y]pe Definition' },
      has_method = methods.textDocument_typeDefinition,
    },
    {
      lhs = 'K',
      rhs = vim.lsp.buf.hover,
      opts = { desc = 'Hover' },
      has_method = methods.textDocument_hover,
    },
    {
      lhs = 'gK',
      rhs = vim.lsp.buf.signature_help,
      opts = { desc = 'Signature Help' },
      has_method = methods.textDocument_signatureHelp,
    },
    {
      lhs = '<c-K>',
      rhs = vim.lsp.buf.signature_help,
      mode = 'i',
      opts = { desc = 'Signature Help' },
      has_method = methods.textDocument_signatureHelp,
    },
    {
      lhs = '<leader>ca',
      rhs = vim.lsp.buf.code_action,
      mode = { 'n', 'v' },
      opts = { desc = 'Code Action' },
      has_method = 'codeAction',
    },
    {
      lhs = '<leader>cl',
      rhs = vim.lsp.codelens.run,
      opts = { desc = 'Run Codelens' },
      has_method = methods.textDocument_codeLens,
    },
    {
      lhs = ']d',
      --stylua: ignore
      -- rhs = function() pretty_jump(1) end,
      -- rhs = function() vim.diagnostic.jump({ count = 1, float = true }) end,
      rhs = function() vim.diagnostic.jump({ count = 1 }) end,
      -- rhs = function() disable_virt_text_jump(1) end,
      opts = { desc = 'Next Diagnostic' },
    },
    {
      lhs = '[d',
      --stylua: ignore
      -- rhs = function() pretty_jump(-1) end,
      -- rhs = function() vim.diagnostic.jump({ count = -1, float = true }) end,
      -- rhs = function() disable_virt_text_jump(-1) end,
      rhs = function() vim.diagnostic.jump({ count = -1 }) end,
      opts = { desc = 'Prev Diagnostic' },
    },
    {
      lhs = ']e',
      --stylua: ignore
      rhs = function() vim.diagnostic.jump({ count = 1, severity = "ERROR" }) end,
      opts = { desc = 'Next Error' },
    },
    {
      lhs = '[e',
      --stylua: ignore
      rhs = function() vim.diagnostic.jump({ count = -1, severity = "ERROR" }) end,
      opts = { desc = 'Prev Error' },
    },
    {
      lhs = ']w',
      --stylua: ignore
      rhs = function()
        vim.diagnostic.jump({ count = 1, severity = "WARN" })
      end,
      opts = { desc = 'Next Warning' },
    },
    {
      lhs = '[w',
      --stylua: ignore
      rhs = function()
        vim.diagnostic.jump({ count = -1, severity = "WARN" })
      end,
      opts = { desc = 'Prev Warning' },
    },
    {
      lhs = '<leader>rn',
      rhs = vim.lsp.buf.rename,
      opts = { desc = 'Rename' },
      has_method = methods.textDocument_rename,
    },
    --{ "<leader>cf", format, desc = "Format Document", has_method = "formatting" },
    --{ "<leader>cf", format, desc = "Format Range", mode = "v", has_method = "rangeFormatting" },
    {
      lhs = '<leader>cA',
      rhs = function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              'source',
            },
            diagnostics = {},
          },
        })
      end,
      opts = { desc = 'Source Action' },
      has_method = 'codeAction',
    },
  }
  for _, keys in pairs(keymap) do
    if not keys.has_method or client:supports_method(keys.method) then
      local opts = keys.opts or {}
      opts.buffer = bufnr
      vim.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, opts)
    end
  end

  local command = function(name, cmd)
    vim.api.nvim_buf_create_user_command(bufnr, name, cmd, {})
  end

  command('LspLog', function()
    vim.cmd.split(vim.lsp.get_log_path())
  end)
  -- command("RmLspLog", [[ exe 'silent ! rm $XDG_STATE_HOME/nvim/lsp.log' ]])
  command('LspSetLocList', function()
    vim.diagnostic.setloclist()
  end)
  command('LspSetQfList', function()
    vim.diagnostic.setqflist()
  end)
  command('LspListWorkspaceFolders', function()
    vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  command('LspRename', function()
    vim.lsp.buf.rename()
  end)
end

do
  vim.fn.delete(vim.lsp.get_log_path())
  vim.lsp.set_log_level(vim.lsp.log.levels.TRACE)
end

-- Diagnostic Config
for _, level in ipairs({ 'Hint', 'Info', 'Warn', 'Error' }) do
  local sign = 'DiagnosticSign' .. level
  vim.fn.sign_define(sign, { text = '', texthl = sign, numhl = sign })
end

vim.diagnostic.config({
  float = {
    show_header = true,
    border = 'rounded',
    source = 'if_many',
  },
  underline = true,
  update_in_insert = true,
  -- virtual_text = { Handled by tiny-diagnostic-line
  --   spacing = 4,
  --   source = "if_many",
  --   prefix = "",
  --   format = function(diagnostic)
  --     local special_sources = {
  --       ["Lua Diagnostics."] = "lua",
  --       ["Lua Syntax Check."] = "lua",
  --     }
  --
  --     local message = require("util.icons").diagnostics[vim.diagnostic.severity[diagnostic.severity]]
  --
  --     if diagnostic.source then
  --       message = string.format("%s %s", message, special_sources[diagnostic.source] or diagnostic.source)
  --     end
  --
  --     if diagnostic.code then
  --       message = string.format("%s[%s]", message, diagnostic.code)
  --     end
  --
  --     return message .. " "
  --   end,
  --   severity_sort = true,
  --   update_in_insert = false,
  -- },
})

local show_handler = vim.diagnostic.handlers.virtual_text.show
if not show_handler then
  vim.notify('Unable to set Virtual Text Show Handler')
else
  vim.diagnostic.handlers.virtual_text.show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(a, b)
      return a.severity > b.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end
end

local function with(f, cfg)
  return function(c)
    return f(vim.tbl_deep_extend('force', cfg, c or {}))
  end
end

vim.lsp.buf.hover = with(vim.lsp.buf.hover, {
  -- max_height = math.floor(vim.o.lines * 0.5),
  -- max_width = math.floor(vim.o.columns * 0.4),
  border = 'rounded',
  focus = false,
})

vim.lsp.buf.signature_help = with(vim.lsp.buf.signature_help, {
  -- max_height = math.floor(vim.o.lines * 0.5),
  -- max_width = math.floor(vim.o.columns * 0.4),
  border = 'rounded',
  focus = false,
})

local open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = opts or {}
  opts.focus = opts.focus or false
  local bufnr, winid = open_floating_preview(contents, syntax, opts, ...)
  vim.api.nvim_set_option_value('number', false, { scope = 'local', win = winid })
  vim.api.nvim_set_option_value('relativenumber', false, { scope = 'local', win = winid })
  vim.api.nvim_set_option_value('spell', false, { scope = 'local', win = winid })
  return bufnr, winid
end


-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Buffer lsp setup',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

-- vim.lsp.config("rust_analyzer", { enabled = false })
vim.lsp.enable({
  'bashls',
  'clangd',
  'cssls',
  'lua_ls',
  -- "rust_analyzer",
  'glsl_analyzer',
  'bacon_ls',
  'taplo',
  'vtsls',
  'qmlls',
  'qmllint',
  'glslang',
  'svelte',
  'codebook',
  'gopls',
  'golangci_lint_ls',
  'docker_language_server',
  'vue_ls'
})
