Let g:scFlash = 1
let g:scSplitSize = 40
let g:sclangTerm = "open -a iTerm.app"
au BufEnter,BufWinEnter,BufNewFile,BufRead *.sc,*.scd set filetype=supercollider
au FileType supercollider packadd scvim

" Find arguments of a class by pressing the semi colon key
au FileType supercollider nnoremap ; :call SCfindArgs()<CR>

" Rebuild SCtags
au FileType supercollider nnoremap <buffer> <leader>rt :SCtags<CR>

" Look up implementation for class under cursor
au FileType supercollider nnoremap <buffer> <leader>si :execute "ts " . expand("<cword>")<cr>

au FileType supercollider nnoremap <buffer> <leader>sl :call SClang_line()<CR>
au FileType supercollider vnoremap <buffer> <leader>sl :call SClang_line()<CR>
au FileType supercollider nnoremap <buffer> <leader>sb :call SClang_block()<CR>
au FileType supercollider vnoremap <buffer> <leader>sb :call SClang_send()<CR>
au FileType supercollider nnoremap <buffer> <leader>ss :call SClangHardstop()<CR>
