local M = {}

function M.get()
  M._keys = {
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    {
      "gd", "<cmd>FzfLua lsp_definitions<cr>",
      desc = "Goto Definitions", has_method = "definition"
    },
    { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "References", has_method = "references" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", has_method = "declaration" },
    {
      "gI", "<cmd>FzfLua lsp_implementation<cr>",
      desc = "Goto Implementation", has_method = "implementation"
    },
    {
      "gy", "<cmd>FzfLua lsp_typedefs<cr>",
      desc = "Goto T[y]pe Definition", has_method = "typeDefinition"
    },
    { "K", vim.lsp.buf.hover, desc = "Hover", has_method = "hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has_method = "signatureHelp" },
    {
      "<c-K>", vim.lsp.buf.signature_help, mode = "i",
      desc = "Signature Help", has_method = "signatureHelp"
    },
    {
      "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" },
      desc = "Code Action", has_method = "codeAction"
    },
    { "]d", function() vim.diagnostic.goto_next() end, desc = "Next Diagnostic" },
    { "[d", function() vim.diagnostic.goto_prev() end, desc = "Prev Diagnostic" },
    { "]e", function() vim.diagnostic.goto_next({ severity = "ERROR" }) end, desc = "Next Error" },
    { "[e", function() vim.diagnostic.goto_prev({ severity = "ERROR" }) end, desc = "Prev Error" },
    { "]w", function() vim.diagnostic.goto_next({ severity = "WARN" }) end, desc = "Next Warning" },
    { "[w", function() vim.diagnostic.goto_prev({ severity = "WARN" }) end, desc = "Prev Warning" },
    { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has_method = "rename" },
    --{ "<leader>cf", format, desc = "Format Document", has_method = "formatting" },
    --{ "<leader>cf", format, desc = "Format Range", mode = "v", has_method = "rangeFormatting" },
    {
      "<leader>cA",
      function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end,
      desc = "Source Action", has_method = "codeAction",
     }
    }
  return M._keys
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>
  if not Keys.resolve then
    print('early return')
    return {}
  end

  local spec = M.get()
  local opts = require("util").opts("nvim-lspconfig")

  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.has_method(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has_method or M.has_method(buffer, keys.has_method) then
      local opts = Keys.opts(keys)
      opts.has_method = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
