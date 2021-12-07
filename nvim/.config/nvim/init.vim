let mapleader=" "
let maplocalleader=" "

set autowrite " writes on make/shell commands
set autoread
" set timeoutlen=150 " time to wait after ESC (default causes annoying delay)
set path+=**

set backspace=indent,eol,start

set backupdir=$XDG_CACHE_HOME/nvim/backup
set directory=$XDG_CACHE_HOME/nvim/swap
set undodir=$XDG_CACHE_HOME/nvim/undo
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

" Set Vim Global python virtualtenviornment
let g:python3_host_prog = "$XDG_DATA_HOME/nelapys/py3nvim/bin/python"

" Install Vim-plug and related plugins if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('$XDG_DATA_HOME/nvim/plugged')

" Plug 'cocopon/iceberg.vim'
" Plug 'jacoborus/tender.vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'savq/melange'
" Plug 'jacoborus/tender.vim'
" Plug 'AlessandroYorba/Despacio'
" Plug 'haystackandroid/carbonized'
" Plug 'chase/focuspoint-vim'

Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'hoob3rt/lualine.nvim'
Plug 'sainnhe/gruvbox-material'

Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'ggandor/lightspeed.nvim'
Plug 'numToStr/Comment.nvim'

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'Valloric/ListToggle'
Plug 'windwp/nvim-autopairs'
" Plug 'jiangmiao/auto-pairs'
" Plug 'junegunn/rainbow_parentheses.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Lsp
Plug 'neovim/nvim-lspconfig'
" Plug 'kabouzeid/nvim-lspinstall'
Plug 'williamboman/nvim-lsp-installer'
Plug 'onsails/lspkind-nvim'

" Telescope things
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-omni'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }
Plug 'mfussenegger/nvim-dap'
Plug 'Pocco81/DAPInstall.nvim'

if has('mac')
  Plug 'lervag/vimtex'
  Plug 'davidgranstrom/scnvim', { 'do': {-> scnvim#install() } }
  " Plug 'mfussenegger/nvim-jdtls'
  " Plug 'OmniSharp/omnisharp-vim'
  " Plug 'Seudev/vscode-java-snippets'
  " Plug 'JeffersonQin/VSCode-LaTeX-Snippets'
  Plug 'ThePrimeagen/vim-be-good'
endif
call plug#end()

lua require 'nvim_lsp'

set background=dark

let g:gruvbox_material_palette = 'material'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_disable_italic_comment = 0

let g:despacio_Midnight = 1

let g:alduin_Shout_Dragon_Aspect = 1
let g:alduin_Shout_Fire_Breath = 1

colorscheme gruvbox-material
