let mapleader=" "
let maplocalleader=" "

set autowrite " writes on make/shell commands
set autoread
" set timeoutlen=150 " time to wait after ESC (default causes annoying delay)
set path+=**

set backspace=indent,eol,start

silent !mkdir $XDG_CACHE_HOME/.nvim/backup > /dev/null 2>&1
silent !mkdir $XDG_CACHE_HOME/.nvim/swap > /dev/null 2>&1
silent !mkdir $XDG_CACHE_HOME/.nvim/undo > /dev/null 2>&1
set backupdir=$XDG_CACHE_HOME/.nvim/backup
set directory=$XDG_CACHE_HOME/.nvim/swap
set undodir=$XDG_CACHE_HOME/.nvim/undo
set undofile
set ttimeout
set ttyfast

" Buffers
set hidden

" Autocompletion (with AutoComplPop)
" set complete+=kspell
" set completeopt=menuone,noselect

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c
set nospell

" Match and Search
set hlsearch " highlight search
set ignorecase " case insensitive matching
set smartcase " be sensitive when there's a capital letter
set matchpairs+=<:> " use % to jump between pairs
set incsearch
set mmp=5000 " mak mem pattern 5000kb

" Formatting
set formatoptions=tcqrn1
set noshiftround
set textwidth=0 " don´t wrap lines by default
set wrap
set splitbelow splitright

" Toggle between paste and normal
set pastetoggle=<F10>

" Tab Settings
set tabstop=2 " set the default tabstop
set softtabstop=2
set shiftwidth=2 " set the default shift width for indents
set expandtab  " make tabs into spaces (set by tabstop)
set smarttab " smarter tab levels
set cindent
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do,for,switch,case,try,class

" set fo+=o " atomatically insert the current comment leader after hitting 'o' or 'O' in normal mode.
" set fo-=r " do not automatically insert a comment leader after an enter
" set fo-=t " Do no auto-wrap text using textwidth (does not apply to comments)

" Selection
set mouse=a
set virtualedit=block
" set ttymouse=sgr " not supported in neovim

" Visual
set ruler " show ruler
set laststatus=2
set number relativenumber
set noerrorbells visualbell t_vb=
set scrolloff=3
set wildmenu
set wildmode=longest,list,full
set wildignore+=*.pyc,.git,.idea,*.o
set showmatch
set whichwrap=b,s,<,>
set colorcolumn=80
set cursorline

" Language
set langmenu=en_gb
let $LANG = 'en_gb'
set encoding=utf-8
set spelllang=en_gb

" Spell check
set dictionary=/usr/share/dict/words
set thesaurus+=$XDG_DATA_HOME/thesaurus/words.txt
hi SpellBad cterm=underline "ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline "ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline "ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline "ctermfg=203 guifg=#ff5f5f

set termguicolors
