local M = {}

---@param client lsp.Client
function M.supports_format(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

local function format(client)
  vim.api.nvim_echo({ { ("Formatting with %s…"):format(client.name) } }, false, {})
  vim.lsp.buf.format { id = client.id }
end

function M.pick_formatter(bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  local candidates = vim.tbl_filter(function(client)
    return client.name ~= M.supports_format(client) end, clients)

  if #candidates > 1 then
    vim.ui.select(candidates, {
      prompt = "Client",
      format_item = function(client) return client.name end,
    }, function(client) if client then format(client) end end)
  elseif #candidates == 1 then
    format(candidates[1])
  else
    vim.api.nvim_echo(
      { { "No clients that support textDocument/formatting are attached.", "WarningMsg" } },
      false,
      {}
    )
  end
end

--@param opts PluginLspOpts
--[[ function M.setup(opts)
  M.opts = opts
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("NelaVimFormat", {}),
    callback = function()
      if M.opts.autoformat then
        M.format()
      end
    end,
  })
end ]]

return M
