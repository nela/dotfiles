_ = vim.cmd [[packadd packer.nvim]]

-- local fn = vim.fn
local has = function(x)
  return vim.fn.has(x) == 1
end

require("packer").startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }
  use 'tpope/vim-surround'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'wellle/targets.vim'
  use 'ggandor/lightspeed.nvim'
	use 'sainnhe/gruvbox-material'
  use 'junegunn/vim-easy-align'
  use 'romainl/vim-qf'

  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
	}

	use {
		'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
		cmd = { 'NvimTreeToggle' },
		-- opt = true,
		setup = function() require('nelavim.nvimtree') end,
		config = function() require('nelavim.nvimtree-after') end
	}

	use {
 		'nvim-lualine/lualine.nvim',
  	requires = {
			{ 'kyazdani42/nvim-web-devicons', opt = true },
			{ 'arkav/lualine-lsp-progress', opt = true },
		}
	}

	use {
		'windwp/nvim-autopairs',
		config = function()
      require('nvim-autopairs').setup({
        fast_wrap = { map = '<M-w>' }
      })
    end,
	}

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use { 'nvim-treesitter/playground' }

	use {
		'neovim/nvim-lspconfig',
		'williamboman/nvim-lsp-installer'
	}

	use {
		'onsails/lspkind-nvim'
	}

	use {
  	'nvim-telescope/telescope.nvim',
  	requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
			{ 'nvim-telescope/telescope-symbols.nvim' }
		}
	}

	use {
		'hrsh7th/nvim-cmp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-nvim-lua',
		'hrsh7th/cmp-omni',
		'hrsh7th/cmp-cmdline'
	}

	use {
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'rafamadriz/friendly-snippets'
	}

	use {
 		'mfussenegger/nvim-dap',
 		'Pocco81/DAPInstall.nvim'
	}

  use {
    'mfussenegger/nvim-jdtls'
  }

	if has('mac') then

  	use {
		  'norcalli/nvim-colorizer.lua',
		  config = function() require('colorizer').setup() end,
			opt = true,
			cmd = { 'ColorizerAttachToBuffer' }
  	}

		use {
			'iamcco/markdown-preview.nvim',
			opt = true,
			cmd = { 'MarkdownPreview' },
			ft = { 'md' },
			config = function() end,
			run = 'cd app && pnpm install'
		}

		use {
			'lervag/vimtex',
			ft = { 'tex' },
			cmd = { 'VimtexCompile', 'VimtexView' },
			opt = true
		}

		use {
			'davidgranstrom/scnvim',
			ft = { 'supercollider' },
			run = function() vim.fn['-> scnvim#install']() end,
			config = function() require('scnvim') end
		}

		use {
			'tomlion/vim-solidity',
			ft = { 'sol' },
			opt = true
		}
	end

end)
