local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

-- local sumneko_lua_settings = {
--   Lua = { diagnostics = { globals = { 'vim' } } }
-- }

lspconfig.sumneko_lua.setup(require("lua-dev").setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim",
        },
      },
    },
  },
})
