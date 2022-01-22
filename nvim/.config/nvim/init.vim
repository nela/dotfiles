let g:python3_host_prog = "$XDG_DATA_HOME/nelapys/py3nvim/bin/python"

let mapleader=" "
let maplocalleader=" "

set backupdir=$XDG_CACHE_HOME/nvim/backup
set directory=$XDG_CACHE_HOME/nvim/swap
set undodir=$XDG_CACHE_HOME/nvim/undo

set autowrite " writes on make/shell commands
set autoread
set undofile
set ttimeout
set ttyfast
set tabstop=2
set shiftwidth=2
set number relativenumber

set hidden
set nospell
set hlsearch
set showmatch
set smartcase
set matchpairs+=<:>,":",':' " use % to jump between pairs
set incsearch
" set backspace=indent,eol,start
set tabstop=2 " set the default tabstop
set softtabstop=2
set shiftwidth=2 " set the default shift width for indents
set expandtab  " make tabs into spaces (set by tabstop)
set smarttab " smarter tab levels
" set cindent
" set cinoptions=:s,ps,ts,cs
" set cinwords=if,else,while,do,for,switch,case,try,class

set mouse=a
set virtualedit=block

" Visual
set ruler " show ruler
" set laststatus=2
set number relativenumber
set noerrorbells visualbell t_vb=
set scrolloff=4
" set wildmenu
" set wildmode=longest,list,full
" set wildignore+=*.pyc,.git,.idea,*.o
set whichwrap=b,s,<,>
set colorcolumn=80
set cursorline

" Spell check
set dictionary=/usr/share/dict/words
set thesaurus+=$XDG_DATA_HOME/thesaurus/words.txt
hi SpellBad cterm=underline "ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline "ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline "ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline "ctermfg=203 guifg=#ff5f5f

set termguicolors
set background=dark

" lua require('plugins')
lua require('nelspconfig')

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr() "ignore vimtex

let g:gruvbox_material_palette = 'original'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_transparent_background = 1

if has ('mac')
  let g:gruvbox_material_enable_italic = 1
  let g:gruvbox_material_disable_italic_comment = 0
  let g:gruvbox_material_virtual_text = 1
else
  let g:gruvbox_material_palette = 'original'
  let g:gruvbox_material_background = 'hard'
  let g:gruvbox_material_enable_italic = 0
  let g:gruvbox_material_disable_italic_comment = 1
endif

colorscheme gruvbox-material
