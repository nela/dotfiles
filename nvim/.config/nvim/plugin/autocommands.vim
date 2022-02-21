augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" Auto-resize splits when Vim gets resized.
augroup SplitResize
  au!
  autocmd VimResized * wincmd =
augroup END

" Vertically center document when entering insert mode
" autocmd InsertEnter * norm zz


augroup BufUpdate
  au!
  " Update a buffer's contents on focus if it changed outside of Vim.
  autocmd FocusGained,BufEnter * :checktime
  " Remove trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Unset paste on InsertLeave.
augroup UnsetPaste
  au!
  autocmd InsertLeave * silent! set nopaste
augroup END

" Ensure tabs don't get converted to spaces in Makefiles.
augroup MakefileTap
  au!
  autocmd FileType make setlocal noexpandtab
augroup END

" Fix tex file type set
" autocmd BufRead,BufNewFile *.tex set filetype=tex
" autocmd BufRead,BufNewFile *.md set filetype=markdown

" SuperCollider filetype
augroup SuperCollider
  au!
  autocmd BufRead,BufNewFile *.scd set filetype=supercollider
  autocmd BufRead,BufNewFile *.sc set filetype=supercollider
augroup END

augroup Solidity
  au!
  autocmd BufRead,BufNewFile *.sol set filetype=solidity
augroup END

" Only show the cursor line in the active buffer.
augroup CursorLine
  au!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
