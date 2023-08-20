local M = {}

function M.on_attach(on_attach)
  print('now')
  vim.api.nvim_create_autocmd('LspAttach', {
    --group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      print('noww')
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      on_attach(client, ev.buf)
    end
  })
end

return M
