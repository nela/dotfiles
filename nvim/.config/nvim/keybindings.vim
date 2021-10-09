noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

nnoremap <leader>hs :split<Space>
nnoremap <leader>vs :vsplit<Space>

" Navigate around splits with a single key combo.
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>

" Tab navigation
nnoremap tf :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnew<Space>
nnoremap tm :tabm<Space>
nnoremap td :tabclose<CR>
nnoremap <leader>te :tabedit<Space>
nnoremap <leader>tn :tabnext<Space>

nnoremap <leader>b :ls<CR>:b<Space>
" Cycle through buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

"Cycle through splits.
" nnoremap <S-Tab> <C-w>w


" Toggle QuickFixList -> Vallorig/ListToggle
" Cycle through quickfix list
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>
nnoremap <leader>j :lnext<CR>
nnoremap <leader>k :lprev<CR>

" Format paragraph (selected or not) to 80 character lines.
nnoremap <leader>fp gqap
xnoremap <leader>fp gqa

" Enable Disable Auto Indent
map <leader>I :setlocal autoindent!<CR>

" Clear search highlights.
map <leader><Space> :noh <CR>

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <leader>r :%s///g<Left><Left>
nnoremap <leader>rc :%s///gc<Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
xnoremap <leader>r :s///g<Left><Left>
xnoremap <leader>rc :s///gc<Left><Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" Edit Vim config file in a new tab.
map <leader>ev :tabnew $MYVIMRC<CR>

" Source Vim config file.
map <leader>sv :source $MYVIMRC<CR>
"Toggle spell check.
map <F4> :setlocal spell!<CR>
" Automatically fix the last misspelled word and jump back to where you were.
nnoremap <leader>sp :normal! mz[s1z=`z<CR>

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" Toggle visually showing all whitespace characters.
" noremap <F7> :set list!<CR>
" inoremap <F7> <C-o>:set list!<CR>
" cnoremap <F7> <C-c>:set list!<CR>

xnoremap <silent> K <Plug>MoveUp
xnoremap <silent> J <Plug>MoveDown
nmap <leader>cf :ClearQuickfixList<CR>
nmap <Leader>x <Plug>StripTrailingWhitespace

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
" nnoremap <silent> <Leader>c :call QuickFix_toggle()<CR>
