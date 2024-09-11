local M = {}


---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.setup()
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

---@param on_attach fun(client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
  local p = name or ''
  vim.print('util.on_attach - creating LspAttach for name: ' .. p)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      vim.print("util.on_attach - LspAttach callback fn")
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        vim.print('util.on_attach - before running function for name ' .. p .. ' client ' .. client.name )
        return on_attach(client, buffer)
      end
    end
  })
end

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
  -- dont trigger or unvalid, unlisted or nofile buffers
  if not vim.api.nvim_buf_is_valid(buffer) then return end
  if not vim.bo[buffer].buflisted then return end
  if vim.bo[buffer].buftype == 'nofile' then return end

  vim.print('check_methods for ' .. client.name)

  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.print('exeucting LspSupportsMethod for method ' .. method .. ' client ' .. client.name .. ' buffer ' .. buffer)
        vim.api.nvim_exec_autocmds('User', {
          pattern = 'LspSupportsMethod',
          data = { client_id = client.id, buffer = buffer, method = method }
        })
      end
    end
  end

end

---@param fn fun(client: vim.lsp.Client, buffer): boolean?
---@param opts? { group?: integer }
function M.on_dynamic_capability(fn, opts)
  vim.print('on dyn capability')
  return vim.api.nvim_create_autocmd('User', {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      vim.print('odc - callback')
      local client = vim.lsp.buf.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        vim.print('ods - returning input fn')
        return fn(client, buffer)
      end
    end
  })
end

---@param method string
---@param fn fun(client: vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
  vim.print('on_supports_method ' .. method)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = 'k' })
  vim.print(M._supports_method)
  return vim.api.nvim_create_autocmd("User", {
    pattern = 'LspSupportsMethod',
    callback = function(args)
      vim.print('LspSupport method callback for ' .. method)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        vim.print('LspSupportsMethod callback for method ' .. method .. ' returning fn')
        return fn(client, buffer)
      end
    end
  })
end


return M
