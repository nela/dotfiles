autocmd BufRead,BufNewFile *.java set filetype=java
autocmd FileType java set tabstop=4 shiftwidth=4 softtabstop=4

autocmd FileType java map <buffer> <F7> :w<CR>:exec '!javac *.java'<CR>
autocmd FileType java imap <buffer> <F7> <esc>:w<CR>:exec '!javac *java'<CR>

autocmd FileType java map <buffer> <F8> :w<CR>:exec '!javac' shellescape(@%, 1)<CR>
autocmd FileType java imap <buffer> <F8> <esc>:w<CR>:exec '!javac' shellescape(@%, 1)<CR>

autocmd FileType java map <buffer> <F9> :w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>
autocmd FileType java imap <buffer> <F9> <esc>:w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>

" Jdtls config
if has('nvim-0.5')
  augroup lsp
    au!
    au FileType java lua require('jdtls').start_or_attach({cmd = {'java-lsp.sh', '/Users/nela/.local/share/lang-servers/eclipse/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')}})
  augroup end
endif

" -- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
" -- use this mapping also with other language servers
nnoremap <A-CR> <Cmd>lua require('jdtls').code_action()<CR>
vnoremap <A-CR> <Esc><Cmd>lua require('jdtls').code_action(true)<CR>
nnoremap <leader>r <Cmd>lua require('jdtls').code_action(false, 'refactor')<CR>

nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>

" -- If using nvim-dap
" -- This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
" nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
