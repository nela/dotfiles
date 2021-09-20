source $XDG_CONFIG_HOME/nvim/settings.vim
source $XDG_CONFIG_HOME/nvim/autocommands.vim
source $XDG_CONFIG_HOME/nvim/keybindings.vim

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
" Color scheme
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'shaunsingh/nord.nvim'
Plug 'Mofiqul/vscode.nvim'
Plug 'wadackel/vim-dogrun'
Plug 'AlessandroYorba/Sierra'
Plug 'doums/darcula'
Plug 'marko-cerovac/material.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'hoob3rt/lualine.nvim'
" Plug 'tomasiser/vim-code-dark'
" Plug 'MordechaiHadad/nvim-papadark'
" Plug 'rktjmp/lush.nvim'
" Plug 'itchyny/lightline.vim'

" Basics
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'windwp/nvim-autopairs'
" Plug 'jiangmiao/auto-pairs'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

" Telescope things
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" fzf from brew installation
" Plug '/usr/local/opt/fzf'
" Plug 'junegunn/fzf.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'OmniSharp/omnisharp-vim'
Plug 'kabouzeid/nvim-lspinstall'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Plug 'Seudev/vscode-java-snippets'
" Plug 'JeffersonQin/VSCode-LaTeX-Snippets'
Plug 'lervag/vimtex'
"Plug 'supercollider/scvim'
" Unused
Plug 'davidgranstrom/scnvim', { 'do': {-> scnvim#install() } }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

call plug#end()

" if (has("termguicolors"))
"   set termguicolors
" endif
set termguicolors

lua require '_compe'
lua require '_nvim-treesitter'
lua require '_nvim-autopairs'
lua require '_nvim-tree'
lua require '_lspsaga'
lua require '_nord'
lua require '_colorizer'
lua require '_lualine'
lua require '_nvim-lspinstall'
" Relaced with nvim-lspinstall
" lua require 'lsp.lua'
" lua require 'lsp.python'
lua require 'lsp.texlab'
lua require 'lsp.omnisharp'
lua require 'lsp.typescript'

"" source $XDG_CONFIG_HOME/nvim/plugconfig/lightline.vim
" source $XDG_CONFIG_HOMEvalg != 3 && /nvim/plugconfig/scvim.vim
" source $XDG_CONFIG_HOME/nvim/plugconfig/fzf.vim
" set Vim-specific sequences for RGB colors
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" if (has("termguicolors"))
"   set termguicolors
" endif
set termguicolors

let g:nvcode_termcolors=256
" Set the color scheme

" let g:vscode_style = "dark"
let g:material_style = 'darker'
let g:material_italic_comments = 'true'
colorscheme material
" set background=dark
" source $XDG_CONFIG_HOME/nvim/transparent-bg.vim
