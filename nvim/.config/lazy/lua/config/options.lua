vim.opt.backupdir      = os.getenv('XDG_CACHE_HOME') .. '/nvim/backup'
vim.opt.directory      = os.getenv('XDG_CACHE_HOME') .. '/nvim/swap'
vim.opt.undodir        = os.getenv('XDG_CACHE_HOME') .. '/nvim/undo'
vim.opt.autowrite      = true
vim.opt.autoread       = true
vim.opt.undofile       = true
vim.opt.ttimeout       = true
vim.opt.ttyfast        = true
vim.opt.splitkeep      = 'topline' --screen
vim.opt.hidden         = true
vim.opt.spell          = false
vim.opt.hlsearch       = true
vim.opt.showmatch      = true
vim.opt.smartcase      = true
vim.opt.incsearch      = true
vim.opt.backspace      = 'indent,eol,start'
vim.opt.tabstop        = 2
vim.opt.softtabstop    = 2
vim.opt.shiftwidth     = 2
vim.opt.shiftround     = true
vim.opt.expandtab      = true
vim.opt.mouse          = 'a'
vim.opt.virtualedit    = 'block'
vim.opt.ruler          = true
vim.opt.laststatus     = 3
vim.opt.number         = true
--vim.opt.relativenumber = true
vim.opt.errorbells     = false
vim.opt.visualbell     = true
vim.opt.scrolloff      = 3
vim.opt.wildmenu       = true
vim.opt.wildmode       = 'longest:full,full'
vim.opt.colorcolumn    = '100'
vim.opt.termguicolors  = true
vim.opt.sessionoptions = 'buffers,tabpages,winpos,curdir,folds'
vim.opt.dictionary     = '/usr/share/dict/words'
vim.opt.formatoptions  = 'jcroqlnt'
vim.opt.smartindent    = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.wrap           = false
vim.opt.grepprg        = 'rg --vimgrep'
vim.opt.grepformat     = '%f:%l:%c:%m'


-- nvim-cmp
vim.opt.completeopt    = 'menu,menuone,noselect'
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true})


-- vim.o.whichwrap = 'b,s,<,>'

vim.opt.matchpairs:append('<:>')
vim.opt.thesaurus:append(os.getenv('XDG_DATA_HOME') .. '/thesaurus/words')
