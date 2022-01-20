let mapleader=" "
let maplocalleader=" "
set tabstop=2
set shiftwidth=2
set number relativenumber

let g:python3_host_prog = "$XDG_DATA_HOME/nelapys/py3nvim/bin/python"

lua require('plugins')
lua require('nelspconfig')

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr() "ignore vimtex

" command! PackerInstall packadd packer.nvim | lua require('plugins').install()
" command! PackerUpdate packadd packer.nvim | lua require('plugins').update()
" command! PackerSync packadd packer.nvim | lua require('plugins').sync()
" command! PackerClean packadd packer.nvim | lua require('plugins').clean()
" command! PackerCompile packadd packer.nvim | lua require('plugins').compile()
" command! PackerStatus packadd packer.nvim | lua require('plugins').status()

set termguicolors

if has ('mac')
  let g:gruvbox_material_palette = 'material'
  let g:gruvbox_material_background = 'hard'
  let g:gruvbox_material_enable_italic = 1
  let g:gruvbox_material_disable_italic_comment = 0
  let g:gruvbox_material_transparent_background = 1
  let g:gruvbox_material_virtual_text = 1
  colorscheme gruvbox-material
else
  let g:gruvbox_material_palette = 'original'
  let g:gruvbox_material_background = 'hard'
  let g:gruvbox_material_enable_italic = 0
  let g:gruvbox_material_disable_italic_comment = 1
  colorscheme gruvbox-material
endif
