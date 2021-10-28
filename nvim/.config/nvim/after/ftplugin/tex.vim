set colorcolumn=120
set textwidth=119
set spell spelllang=en_gb

" Format paragraph (selected or not) to 80 character lines.
nnoremap <leader>gp gqap
xnoremap <leader>gp gqa


map <F9> :w <bar> compiler vlty <bar> make <bar> :cw <cr><esc>

let g:vimtex_complete_recursive_bib=1
let g:vimtex_fold_enabled=1

let g:tex_flavor = 'latex'

" let g:vimtex_grammar_vlty = {
"       \ 'lt_command': 'languagetool',
"       \ 'show_suggestions' : 1,
"       \ 'server': 'my',
"       \ 'shell_options':
"           \   ' --multi-language',
"           \ . ' --packages "*"',
"           \ . ' --define ~/vlty/defs.tex',
"           \ . ' --replace ~/vlty/repls.txt',
"           \ . ' --equation-punctuation display',
"           \ . ' --single-letters "i.\,A.\|z.\,B.\|\|"',
"   }

let g:vimtex_grammar_vlty = {}
" let g:vimtex_grammar_vlty.lt_directory = '~/lib/LanguageTool-5.0'
let g:vimtex_grammar_vlty.lt_command = 'languagetool'
let g:vimtex_grammar_vlty.server = 'no'
let g:vimtex_grammar_vlty.show_suggestions = 1
" let g:vimtex_grammar_vlty.shell_options =
"         \   ' --multi-language'
"         \ . ' --packages "*"'
"         \ . ' --define ~/vlty/defs.tex'
"         \ . ' --replace ~/vlty/repls.txt'
"         \ . ' --equation-punctuation display'
"         \ . ' --single-letters "i.\,A.\|z.\,B.\|\|"'
