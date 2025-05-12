return {
  { 'nvim-lua/plenary.nvim' },
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-abolish', event = 'VeryLazy' },
  {
    'tpope/vim-unimpaired',
    event = 'VeryLazy',
    keys = {
      { "]g", "<Plug>(unimpaired-move-down)", { "n", "x"} },
      { "[g", "<Plug>(unimpaired-move-up)", { "n", "x"} },
      { "]a", "<Plug>(unimpaired-bnext)", { "n", "x"} },
      { "[a", "<Plug>(unimpaired-bprevious)", { "n", "x"} }
    }
  },
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
	{ 'zegervdv/nrpattern.nvim' }, -- TODO LazyLoad
	{ 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
	{ 'windwp/nvim-autopairs', opts = { map = '<M-w>' }, event = "InsertEnter" },
}
