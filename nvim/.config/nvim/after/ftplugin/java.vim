set tabstop=4 shiftwidth=4 softtabstop=4

map <buffer> <F7> :w<CR>:exec '!javac *.java'<CR>
imap <buffer> <F7> <esc>:w<CR>:exec '!javac *java'<CR>

map <buffer> <F8> :w<CR>:exec '!javac' shellescape(@%, 1)<CR>
imap <buffer> <F8> <esc>:w<CR>:exec '!javac' shellescape(@%, 1)<CR>

map <buffer> <F9> :w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>
imap <buffer> <F9> <esc>:w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>

nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>

" If using nvim-dap
" This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
" nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
