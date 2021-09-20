" Make sure all types of requirements.txt files get syntax highlighting.
autocmd BufNewFile,BufRead requirements*.txt set syntax=python

" Python Compile
map <buffer> <F9> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
imap <buffer> <F9> <esc>:w<CR>:exec '!python' shellescape(@%, 1)<CR>
