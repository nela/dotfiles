vim.cmd("nnoremap <silent><leader>vca <cmd>lua require('lspsaga.codeaction').code_action()<CR>")
vim.cmd("vnoremap <silent><leader>vca <cmd><C-U>lua require('lspsaga.codeaction').range_code_action()<CR>")

-- rename
vim.cmd("nnoremap <silent><leader>vrn <cmd>lua require('lspsaga.rename').rename()<CR>")

-- show diagnostics
vim.cmd("nnoremap <silent><leader>sd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>")

-- only show diagnostic if cursor is over the area
vim.cmd("nnoremap <silent><leader>sc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>")

-- jump diagnostic
vim.cmd("nnoremap <silent><leader>vp <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>")
vim.cmd("nnoremap <silent><leader>vn <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>")

-- float terminal also you can pass the cli command in open_float_terminal function
-- or open_float_terminal('lazygit')<CR>
vim.cmd("nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>")
vim.cmd("tnoremap <silent> <A-d> <C-\\><C-n><cmd>lua require('lspsaga.floaterm').close_float_terminal()<CR>")
