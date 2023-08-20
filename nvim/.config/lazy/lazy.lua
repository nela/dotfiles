local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'git@github.com:folke/lazy.nvim.git',
   '--depth=1',
    '--branch=stable', -- latest stable release
    lazypath,
})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.shiftwidth=2
vim.opt.tabstop=2

local has_git = function()
	local output = vim.fn.systemlist('git rev-parse --is-inside-work-tree 2>/dev/null')
	return #output ~= 0
end

require('lazy').setup({
  {
		'sainnhe/gruvbox-material',
		lazy = false,
		priority = 666,
		config = function() vim.cmd([[ colorscheme gruvbox-material ]]) end
  },
	{
		"dstein64/vim-startuptime",
		-- lazy-load on a command
		cmd = "StartupTime",
		-- init is called during startup. Configuration for vim plugins typically should be set in an init function
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},

	{ dir = '~/.local/share/zsh/fzf', cond = [[ vim.fn.has('mac') != 1]], event = "VeryLazy" },
	{ dir = '/usr/local/opt/fzf', cond = [[ vim.fn.has('mac') == 1]], event = "VeryLazy" },
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-abolish', event = 'VeryLazy' },
  { 'tpope/vim-unimpaired', event = 'VeryLazy' },
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
	{ 'zegervdv/nrpattern.nvim', event = "VeryLazy" },
	{ 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
	{ 'numToStr/Comment.nvim', event = "VeryLazy" },
	{ 'windwp/nvim-autopairs', opt = { map = '<M-w>' }, event = "InsertEnter" },

	-- Git --
  { 'tpope/vim-fugitive', cmd = { 'G', 'Gw' } },
  {
   'lewis6991/gitsigns.nvim',
   dependencies = { 'nvim-lua/plenary.nvim' },
   event = 'VeryLazy',
   cond = has_git
  },

  -- Movement --
  { 'wellle/targets.vim', event = 'VeryLazy' },
  {
		'ggandor/leap.nvim',
		event = 'VeryLazy',
		init = function() require('leap').add_default_mappings() end
  },
	{ 
		'ggandor/leap.nvim', event = "VeryLazy"
		dependencies = { 
			{ 'ggandor/leap-spooky.nvim', event = 'VeryLazy' }
		}
	},

  -- Quickfix --
  { 'romainl/vim-qf', event = 'QuickFixCmdPre' },
  { 'kevinhwang91/nvim-bqf', event = 'QuickFixCmdPre' },

	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		build = function() require('nvim-treesitter.install').update({
			with_sync = true,
		}) end,
		dependencies = {
			{
				'nvim-treesitter/playground',
				cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
			},
			{
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
		}
	},

  -- Lsp -- 
  { 
		'neovim/nvim-lspconfig', 
		event = { 'BufReadPost', 'BufNewFile' }
	},
  { 
		'mfussenegger/nvim-jdtls', 
		ft = 'java',
		event = { 'BufReadPost', 'BufNewFile' } 
	},
  { 
		'jose-elias-alvarez/typescript.nvim', 
		ft = 'typescript',
		event = { 'BufReadPost', 'BufNewFile' },
		dependencies = 'nvim-lspconfig'
	},
  { 
		'folke/neodev.nvim', 
		ft = 'lua',
		event = 'VeryLazy'
	},
  { 'SmiteshP/nvim-navic', event = 'VeryLazy' },
  { 
		'stevearc/aerial.nvim', 
		cmd = { 'AerialOpen', 'AerialNavOpen', 'AerialToggle' }
	},
	{
		'ray-x/lsp_signature.nvim',
		event = 'InsertEnter'
	},
	{ 'onsails/lspkind-nvim', event = 'InsertEnter' },

	-- Dap --
	{
		'mfussenegger/nvim-dap',
		event = "VeryLazy",
		dependencies = {
			{
				'mfussenegger/nvim-dap-python',
				ft = "python",
				event = "VeryLazy"
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				ft = { "javascript", "typescript" },
				event = "VeryLazy" 
			},
			{
				'theHamsta/nvim-dap-virtual-text',
				dependencies = "nvim-dap",
				event = "VeryLazy"
			},
		}
	},
	-- Test --
	-- "nvim-neotest/neotest",
	-- "haydenmeade/neotest-jest",

	-- Cmp --
	{
		'hrsh7th/nvim-cmp',
		event = "InsertEnter",
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-omni',
			'hrsh7th/cmp-cmdline',
			'andersevenrud/cmp-tmux',
		},
	},

	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
			'nvim-telescope/telescope-dap.nvim',
			'nvim-telescope/telescope-symbols.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function() require('nelescope').setup() end,
		event = "VeryLazy"
	},

	-- Visuals
	{
		'nvim-zh/colorful-winsep.nvim',
		event = "BufLeave"
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		event = "VeryLazy"
	},
	{
		'hoschi/yode-nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = { 'YodeCreateSeditorFloating', 'YodeCreateSeditorReplace', }
	},
	{
		'norcalli/nvim-colorizer.lua',
		-- config = function() require('colorizer').setup() end,
		cmd = { 'ColorizerAttachToBuffer' }
	},
	{
		'kyazdani42/nvim-tree.lua',
			dependencies = { 'kyazdani42/nvim-web-devicons' },
			config = function() require('nvimtree') end
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons' }
	},
	-- {
	-- 	'iamcco/markdown-preview.nvim',
	-- 	cmd = { 'MarkdownPreview' },
	-- 	run = 'cd app && pnpm install && pnpm add msgpack-lite',
	-- 	ft = { 'markdown' },
	-- 	setup = function () vim.g.mkdp_filetypes = { 'markdown' } end,
	-- },
	{
		'stevearc/dressing.nvim',
		event = "VeryLazy"
	},
	-- {
	-- 	'alvarosevilla95/luatab.nvim',
	-- 	event = "TabNew"
	-- },
	-- DB --
	{
		'tpope/vim-dadbod',
		cmd = { "DBUI" },
		dependencies = {
			'kristijanhusak/vim-dadbod-ui',
			'kristijanhusak/vim-dadbod-completion',
		}
	},
	{ 'BlackLight/nvim-http', cmd = "HTTPClientDoRequest" },
})
