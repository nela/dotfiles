-- local path = os.getenv("XDG_DATA_HOME") .. '/nvim/plugged/friendly-snippets'
-- vim.inspect(print(path))
-- vim.o.runtimepath = vim.o.runtimepath .. ',' .. path

require'luasnip/loaders/from_vscode'.load()
