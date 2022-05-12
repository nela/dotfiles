local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then
    return
end

local exclude_servers = { "sumneko_lua", "ltex", "jdtls" }

local installed_servers = function()
  local names = {}
  for _, server in ipairs(lsp_installer.get_installed_servers()) do
    -- vim.pretty_print(server.name)
    table.insert(names, server.name)
  end

  return names
end

local contains = function(table, element)
  for _, value in ipairs(table) do
    if value == element then
      return true
      end
  end
  return false
end

for _, server in ipairs(installed_servers()) do
  if not contains(exclude_servers, server) then
    lspconfig[server].setup {}
  end
end
