nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fw <cmd>Telescope file_browser<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <leader>gf <cmd>Telescope git_files<CR>
nnoremap <leader>fc <cmd>Telescope commands<CR>
nnoremap <leader>fr <cmd>Telescope registers<CR>

nnoremap <leader>dot <cmd> :lua require('nelescope').search_dotfiles()<CR>
nnoremap <leader>vim <cmd> :lua require('nelescope').search_nvimfiles()<CR>
nnoremap <leader>zsh <cmd> :lua require('nelescope').search_zshfiles()<CR>
