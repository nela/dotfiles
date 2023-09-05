return {
  { 'nvim-lua/plenary.nvim' },
  { dir = '~/.local/share/fzf', cond = [[ vim.fn.has('mac') != 1]], event = "VeryLazy" },
	{ dir = '/usr/local/opt/fzf', cond = [[ vim.fn.has('mac') == 1]], event = "VeryLazy" },
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-abolish', event = 'VeryLazy' },
  { 'tpope/vim-unimpaired', event = 'VeryLazy' },
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
	{ 'zegervdv/nrpattern.nvim', event = "VeryLazy" },
	{ 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
	{ 'windwp/nvim-autopairs', opts = { map = '<M-w>' }, event = "InsertEnter" },
}
