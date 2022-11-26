local ensure_packer = function()
  local retval = false
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'git@github.com:wbthomason/packer.nvim.git', install_path})
    retval = true
  end
  vim.cmd [[ packadd packer.nvim ]]
  return retval
end

local packer_bootstrap = ensure_packer()

local has = function(x)
  return vim.fn.has(x) == 1
end

require('packer').startup({
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }
    use {
      'sainnhe/gruvbox-material',

      -- Git --
      'tpope/vim-fugitive',
      {
       'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        -- opt = true,
        config = function() require('gitsigns').setup() end,
        -- cmd = { 'Gitsigns preview_hunk'}
        ensure_installed = true,
      },

      -- Tpope --
      'tpope/vim-surround',
      'tpope/vim-eunuch',
      'tpope/vim-sleuth',
      'tpope/vim-repeat',
      'tpope/vim-abolish',
      'tpope/vim-unimpaired',

      -- Movement --
      'wellle/targets.vim',
      {
        'ggandor/leap-spooky.nvim',
        config = function() require('leap-spooky').setup({}) end,
        require = { 'ggandor/leap.nvim' },
        ensure_installed = true
      },

      -- Quickfix --
      'romainl/vim-qf',
      'kevinhwang91/nvim-bqf',

      -- Sessions --
      'rmagatti/auto-session',

       -- LSP --
      {
        'neovim/nvim-lspconfig',
        requires = {
          {
            'williamboman/mason.nvim',
            config = function() require("mason").setup() end,
          },
          'williamboman/mason-lspconfig.nvim'
        },
        ensure_installed = true
      },
      {
        'folke/neodev.nvim',
        config = function() require('neodev').setup({}) end,
      },
      'SmiteshP/nvim-navic',
      {
        'stevearc/aerial.nvim',
        config = function() require('aerial').setup({}) end,
      },
      {
        'brymer-meneses/grammar-guard.nvim',
        config = function () require('grammar-guard').init() end,
        disable = true
      },
      'ray-x/lsp_signature.nvim',
      'onsails/lspkind-nvim',
      'mfussenegger/nvim-jdtls',
      'jose-elias-alvarez/null-ls.nvim',

      -- DAP--
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',

      -- CMP --
      {
        'hrsh7th/nvim-cmp',
        requires = {
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
          'hrsh7th/cmp-omni',
          'hrsh7th/cmp-cmdline',
          'andersevenrud/cmp-tmux',
        },
        ensure_installed = true,
      },

       -- Snippets --
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Treesitter --
      {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({
          with_sync = true,
        }) end,
        requires = {
          {
            'nvim-treesitter/playground',
            opt = true,
            cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
            -- disable = true,
          },
          'p00f/nvim-ts-rainbow',
        },
        ensure_instaled = true,
      },

      -- Telescope --
      {
        'nvim-telescope/telescope.nvim',
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope-file-browser.nvim',
          'nvim-telescope/telescope-symbols.nvim',
          -- also fzf installtion for fzf-native
          { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
        config = function() require('nelescope').setup() end,
        ensure_installed = true,
      },

      -- Visuals --
      {
        'nvim-zh/colorful-winsep.nvim',
        -- config = function() require('colorful-winsep').setup({}) end,
	-- disable = true,
      },
      {
        'alvarosevilla95/luatab.nvim',
        config = function() require('luatab').setup() end,
        disable = true,
      },
      'lukas-reineke/indent-blankline.nvim',
      {
        "luukvbaal/stabilize.nvim",
        config = function() require("stabilize").setup() end,
      },
      {
        'hoschi/yode-nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function () require('yode-nvim').setup() end,
        opt = true,
        cmd = { 'YodeCreateSeditorFloating', 'YodeCreateSeditorReplace', }
      },
      {
        'norcalli/nvim-colorizer.lua',
        config = function() require('colorizer').setup() end,
        opt = true,
        cmd = { 'ColorizerAttachToBuffer' }
      },
      {
        'kyazdani42/nvim-tree.lua',
          requires = { 'kyazdani42/nvim-web-devicons' },
          cmd = { 'NvimTreeToggle' },
          -- opt = true, -- Doesn't give icons
          -- setup = function() require('nelavim.nvimtree') end,
          config = function() require('nvimtree') end
      },
      {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        ensure_installed = true,
      },
      {
        'iamcco/markdown-preview.nvim',
        -- opt = true,
        cmd = { 'MarkdownPreview' },
        run = 'cd app && pnpm install && pnpm add msgpack-lite',
        ft = { 'markdown' },
        setup = function () vim.g.mkdp_filetypes = { 'markdown' } end,
      },
      'stevearc/dressing.nvim',

      -- Tex --
      {
        'lervag/vimtex',
        ft = { 'tex' },
        cmd = { 'VimtexCompile', 'VimtexView' },
        opt = true
      },

      -- DB --
      'tpope/vim-dadbod',
      'kristijanhusak/vim-dadbod-ui',

      -- Utils --
      {
        'zegervdv/nrpattern.nvim',
        config = function () require('nrpattern').setup() end,
      },
      {
        'junegunn/vim-easy-align',
        opt = true,
        cmd = { 'EasyAlign' }
      },
      {
        'mvllow/modes.nvim',
        config = function () require('modes').setup() end,
        disable = true,
      },
      {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end,
      },
      {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup({
          fast_wrap = { map = '<M-w>' },
        }) end,
      },

    }

    -- Specific mac plugins
    if not has('mac') then
      use '~/.local/repositories/fzf'
    else
      use {
        '/usr/local/opt/fzf',
        {
          'davidgranstrom/scnvim',
          ft = { 'supercollider' },
          run = function() vim.fn['-> scnvim#install']() end,
          config = function() require('scnvim') end
        },
        {
          'tomlion/vim-solidity',
          ft = { 'sol' },
          opt = true,
          disable = true,
        }
      }
    end

    if packer_bootstrap then require('packer').sync() end

  end,
  config = {
    display = {
      open_fn = function() return require('packer.util').float({
        border = 'single'
      }) end
    }
  }
})
