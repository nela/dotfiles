" nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
" nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
" vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
" nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
" vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
" vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>

map <buffer> <F7> :w<CR>:exec '!javac *.java'<CR>
imap <buffer> <F7> <esc>:w<CR>:exec '!javac *java'<CR>

map <buffer> <F8> :w<CR>:exec '!javac' shellescape(@%, 1)<CR>
imap <buffer> <F8> <esc>:w<CR>:exec '!javac' shellescape(@%, 1)<CR>

map <buffer> <F9> :w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>
imap <buffer> <F9> <esc>:w<CR>:exec '!java' shellescape(fnamemodify(@%, ':r'), 1)<CR>

" If using nvim-dap
" This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
" nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
" command JdtTestClass lua require'jdtls'.test_class()
" command JdtTestNearestMethod lua require'jdtls'.test_nearest_method()

" command LspFormatting lua vim.lsp.buf.formatting()
" command LspSetLocList lua vim.diagnostic.setloclist()
" command LspSetQfList lua vim.diagnostic.setqflist()
" command LspAddWorkspaceFolder lua vim.lsp.buf.add_workspace_folder()
" command LspRemoveWorkspaceFolder lua vim.lsp.buf.remove_workspace_folder()
" command LspListWorkspaceFolders lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
" command LspRename lua vim.lsp.buf.rename()
" command LspCodeAction lua vim.lsp.buf.code_action()

" nnoremap gi <Cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap gr <Cmd>lua vim.lsp.buf.references()<CR>
" nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap gD <Cmd>lua require vim.lsp.buf.declaration()<CR>
" nnoremap K <Cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <leader>sh <Cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <space>D <Cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <space>rn <Cmd>lua vim.lsp.buf.rename()<CR>
" nnoremap <space>ca <Cmd>lua vim.lsp.buf.code_action()<CR>
" nnoremap <space>e <Cmd>lua vim.diagnostic.open_float()<CR>
" nnoremap [d <Cmd>lua vim.diagnostic.goto_prev()<CR>
" nnoremap ]d <Cmd>lua vim.diagnostic.goto_next()<CR>
"
" nnoremap <space>wa <Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
" nnoremap <space>wr <Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
" nnoremap <space>wl <Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
" nnoremap <space>loc <Cmd>lua vim.diagnostic.setloclist()<CR>
" nnoremap <space>f <Cmd>lua vim.lsp.buf.formatting()<CR>
