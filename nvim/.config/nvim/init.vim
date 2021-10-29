source ${NVIM_CONFIG_HOME}/settings.vim
source ${NVIM_CONFIG_HOME}/autocommands.vim
source ${NVIM_CONFIG_HOME}/keybindings.vim

" Set Vim Global python virtualtenviornment
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

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
Plug 'windwp/nvim-autopairs'
" Plug 'jiangmiao/auto-pairs'
" Plug 'junegunn/rainbow_parentheses.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'onsails/lspkind-nvim'

" Telescope things
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'

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

lua require 'nvim_lsp'

set background=dark
let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_disable_italic_comment = 0
colorscheme gruvbox-material
