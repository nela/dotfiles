source ${NVIM_CONFIG_HOME}/settings.vim
source ${NVIM_CONFIG_HOME}/autocommands.vim
source ${NVIM_CONFIG_HOME}/keybindings.vim

" Set Vim Global python virtual enviornment
let g:python3_host_prog = "$XDG_DATA_HOME/nelapys/py3nvim/bin/python"

" Install Vim-plug and related plugins if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'hoob3rt/lualine.nvim'
Plug 'sainnhe/gruvbox-material'

" Basics
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
Plug 'windwp/nvim-autopairs' " Plug 'jiangmiao/auto-pairs'
" Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'nelstrom/vim-visual-star-search'

Plug 'nvim-lua/plenary.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'kabouzeid/nvim-lspinstall'

" Telescope things
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
" Plug 'lukas-reineke/cmp-under-comparator'

" Plug 'f3fora/cmp-spell'

" Plug 'hrsh7th/nvim-compe'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/vim-vsnip-integ'
" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'rafamadriz/friendly-snippets'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

Plug 'mfussenegger/nvim-dap'
Plug 'Pocco81/DAPInstall.nvim'
Plug 'numToStr/Comment.nvim'

if has('mac')
  Plug 'lervag/vimtex'
  Plug 'davidgranstrom/scnvim', { 'do': {-> scnvim#install() } }
  " Plug 'mfussenegger/nvim-jdtls'
  " Plug 'OmniSharp/omnisharp-vim'
  Plug 'Seudev/vscode-java-snippets'
  Plug 'JeffersonQin/VSCode-LaTeX-Snippets'
  " Plug 'ThePrimeagen/vim-be-good'
endif

call plug#end()

" lua require("nelavim")
" lua require '_telescope'
" lua require '_compe'
" lua require '_nvim-treesitter'
" lua require '_nvim-autopairs'
" lua require '_nvim-tree'
" " lua require '_lspsaga'
" " lua require '_colorizer'
" lua require '_lualine'
" lua require '_nvim-lspinstall'
" lua require '_toggleterm'
" lua require '_comment'

set background=dark
let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_disable_italic_comment = 0
colorscheme gruvbox-material
