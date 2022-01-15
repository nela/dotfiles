" " noremap j gj
" " noremap k gk
" " noremap <Down> gj
" " noremap <Up> gk
" " inoremap <Down> <C-o>gj
" " inoremap <Up> <C-o>gk

nnoremap <leader>hs :split<Space>
nnoremap <leader>vs :vsplit<Space>

" Navigate around splits with a single key combo.
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>

nnoremap <M

" Yank whole line
nnoremap Y y$

" Keep jumps centred
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Jumplist mutation
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bl :ls<CR>:b<Space>

"Cycle through quickfix listk
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprev<CR>
nnoremap <leader>lj :lnext<CR>
nnoremap <leader>lk :lprev<CR>

" Tab navigation
" nnoremap TF :tabfirst<CR>
" nnoremap TJ :tabnext<CR>
" nnoremap TK :tabprev<CR>
" nnoremap TL :tablast<CR>
" nnoremap TN :tabnew<Space>
" nnoremap TM :tabm<Space>
" nnoremap TD :tabclose<CR>
" nnoremap TE :tabedit<Space>
" nnoremap TN :tabnext<Space>

" Toggle AutoIndent
map <leader>I :setlocal autoindent!<CR>

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
" nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
" xnoremap <silent> s* "sy:let @/=@s<CR>cgn

" Prevent x from overriding what's in the clipboard.
" noremap x "_x
" noremap X "_x

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" Source Vim config file.
map <leader>sv :source $MYVIMRC<CR>
"Toggle spell check.
map <F4> :setlocal spell!<CR>
" Automatically fix the last misspelled word and jump back to where you were.
nnoremap <leader>sp :normal! mz[s1z=`z<CR>

xnoremap <silent> K <Plug>MoveUp
xnoremap <silent> J <Plug>MoveDown
nnoremap <leader>cf :ClearQuickfixList<CR>
nnoremap <leader>sw <Plug>StripTrailingWhitespace

" Shift + J/K moves selected lines down/up in visual mode
" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv

