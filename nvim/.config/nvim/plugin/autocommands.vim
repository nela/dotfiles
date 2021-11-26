augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" Vertically center document when entering insert mode
" autocmd InsertEnter * norm zz

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime

" Unset paste on InsertLeave.
autocmd InsertLeave * silent! set nopaste

" Ensure tabs don't get converted to spaces in Makefiles.
autocmd FileType make setlocal noexpandtab

" Fix tex file type set
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile *.md set filetype=markdown

" SuperCollider filetype
autocmd BufRead,BufNewFile *.scd set filetype=supercollider
autocmd BufRead,BufNewFile *.sc set filetype=supercollider

" Only show the cursor line in the active buffer.
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

"" Load Rainbow Parantheses
"au VimEnter * RainbowParentheses!!
