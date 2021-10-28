set tabstop=4 shiftwidth=4 softtabstop=4

map <buffer> <F7> :w<CR>:exec '!javac *.java'<CR>
imap <buffer> <F7> <esc>:w<CR>:exec '!javac *java'<CR>

map <buffer> <F8> :w<CR>:exec '!javac' shellescape(@%, 1)<CR>
imap <buffer> <F8> <esc>:w<CR>:exec '!javac' shellescape(@%, 1)<CR>

map <buffer> <F9> :w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>
imap <buffer> <F9> <esc>:w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>


" Jdtls config
if has('nvim-0.5')
    lua require('jdtls').start_or_attach({cmd = {'java-lsp.sh', '/Users/nela/.local/share/eclipse/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')}})
endif

" -- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
" -- use this mapping also with other language servers
nnoremap <A-CR> <cmd>lua require('jdtls').code_action()<CR>
vnoremap <A-CR> <Esc><cmd>lua require('jdtls').code_action(true)<CR>
nnoremap <leader>r <cmd>lua require('jdtls').code_action(false, 'refactor')<CR>

nnoremap <A-o> <cmd>lua require'jdtls'.organize_imports()<CR>
nnoremap crv <cmd>lua require('jdtls').extract_variable()<CR>
vnoremap crv <Esc><cmd>lua require('jdtls').extract_variable(true)<CR>
vnoremap crm <Esc><cmd>lua require('jdtls').extract_method(true)<CR>

" -- If using nvim-dap
" -- This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
" nnoremap <leader>df <cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <cmd>lua require'jdtls'.test_nearest_method()<CR>
