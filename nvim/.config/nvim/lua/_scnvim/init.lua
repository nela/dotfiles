local scnvim = require 'scnvim'

-- vim.g.scnvim_postwin_size = 15
-- vim.g.scnvim_postwin_orientation = 'h'
vim.api.nvim_set_var('scnvim_postwin_orientation', 'h')

print(vim.inspect(vim.api.nvim_get_var('scnvim_postwin_orientation')))
-- vim.api.nvim_win_set_var('scnvim_postwin_size', 20)

