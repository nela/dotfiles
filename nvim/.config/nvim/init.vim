source ${NVIM_CONFIG_HOME}/settings.vim
source ${NVIM_CONFIG_HOME}/autocommands.vim
source ${NVIM_CONFIG_HOME}/keybindings.vim

" Set Vim Global python virtual enviornment
let g:python3_host_prog = "$XDG_DATA_HOME/virtual-envs/py3nvim/bin/python"

" Install Vim-plug and related plugins if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
Plug 'kyazdani42/nvim-tree.lua'
Plug 'wadackel/vim-dogrun'
Plug 'AlessandroYorba/Sierra'
Plug 'marko-cerovac/material.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'hoob3rt/lualine.nvim'

" Basics
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'windwp/nvim-autopairs' " Plug 'jiangmiao/auto-pairs'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

" Telescope things
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

<<<<<<< HEAD
=======

Plug 'akinsho/toggleterm.nvim'
>>>>>>> 81a5ac0... Added bashit, tmux, fixed init.vim
"Plug 'supercollider/scvim'
" Unused
if has('mac')
  Plug 'lervag/vimtex'
  Plug 'davidgranstrom/scnvim', { 'do': {-> scnvim#install() } }
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'OmniSharp/omnisharp-vim'
  Plug 'Seudev/vscode-java-snippets'
  Plug 'JeffersonQin/VSCode-LaTeX-Snippets'
endif

call plug#end()

" if (has("termguicolors"))
"   set termguicolors
" endif
set termguicolors

lua require '_material'
lua require '_compe'
lua require '_nvim-treesitter'
lua require '_nvim-autopairs'
lua require '_nvim-tree'
lua require '_lspsaga'
lua require '_colorizer'
lua require '_lualine'
lua require '_nvim-lspinstall'
<<<<<<< HEAD

if has('mac')
  lua require 'lsp.texlab'
  lua require 'lsp.omnisharp'
  lua require 'lsp.typescript'
endif

=======
lua require '_toggleterm'

if has('mac')
  lua require 'lsp.texlab'
  lua require 'lsp.omnisharp'
  lua require 'lsp.typescript'
endif

>>>>>>> 81a5ac0... Added bashit, tmux, fixed init.vim
set termguicolors

let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_disable_italic_comment = 1
colorscheme gruvbox-material

" Set the color scheme

<<<<<<< HEAD
" let g:vscode_style = "dark"
let g:material_style = 'darker'

colorscheme material
" set background=dark
=======
set background=dark
>>>>>>> 81a5ac0... Added bashit, tmux, fixed init.vim
" source $XDG_CONFIG_HOME/nvim/transparent-bg.vim
