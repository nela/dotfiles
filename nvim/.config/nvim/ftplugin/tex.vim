set colorcolumn=100
set textwidth=99
set spell spelllang=en_gb

" Format paragraph (selected or not)
nnoremap <leader>gp gqap
xnoremap <leader>gp gqa

let g:vimtex_complete_recursive_bib=1
let g:vimtex_fold_enabled=1
" set foldmethod=syntax
set fillchars=fold:\

let g:tex_flavor = 'latex'

function! Callback(msg)
  let l:m = matchlist(a:msg, '\vRun number (\d+) of rule ''(.*)''')
  if !empty(l:m)
    echomsg l:m[2] . ' (' . l:m[1] . ')'
  endif
endfunction

let g:vimtex_compiler_latexmk = {
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [function('Callback')]
      \ }

let g:vimtex_view_method = 'skim'
let g:vimtex_view_skim_activate = 1
let g:vimtex_view_skim_reading_bar = 1

let g:vimtex_grammar_vlty = {
      \ 'lt_command': 'languagetool',
      \ 'show_suggestions' : 1,
      \ 'server': 'no',
      \ 'shell_options':
          \  ' --packages "*"'
          \ . ' --add-modules /Users/nela/skole/master/thesis/main.tex'
          \ . ' --define /Users/nela/skole/master/thesis/aux/commands.tex'
          \ . ' --equation-punctuation display'
          \ }
          " \ . ' --single-letters "I.\,A.\|a.\,B.\|\|"'

map <F9> :w <bar> compiler vlty <bar> make <bar> :cw <cr><esc>
