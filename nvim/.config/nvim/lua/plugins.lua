_ = vim.cmd [[ packadd packer.nvim ]]

-- local fn = vim.fn
local has = function(x)
  return vim.fn.has(x) == 1
end

 require("packer").startup({function(use)
   use { "wbthomason/packer.nvim", opt = true }
   use {
    "tpope/vim-surround",
    "tpope/vim-eunuch",
    "tpope/vim-fugitive",
    "tpope/vim-sleuth",
    "tpope/vim-repeat",
    "tpope/vim-abolish",
    "tpope/vim-unimpaired",
    "wellle/targets.vim",
    "ggandor/lightspeed.nvim",
    "sainnhe/gruvbox-material",
    "onsails/lspkind-nvim",
    "romainl/vim-qf", -- hmmm??
    "kevinhwang91/nvim-bqf",
  }

   if has("mac") then
    use "/usr/local/opt/fzf"
   else
    use "~/.local/repositories/fzf"
   end

   use {
      "junegunn/vim-easy-align",
      opt = true,
      cmd = { "EasyAlign" }
   }

   use {
      "mvllow/modes.nvim",
      config = function () require("modes").setup() end,
      disable = true,
   }

  use {
    "zegervdv/nrpattern.nvim",
    config = function () require("nrpattern").setup() end,
  }

   use {
     "numToStr/Comment.nvim",
     config = function() require("Comment").setup() end,
   }

   use {
     "kyazdani42/nvim-tree.lua",
     requires = { "kyazdani42/nvim-web-devicons" },
     cmd = { "NvimTreeToggle" },
     -- opt = true, -- Doesn"t give icons
     -- setup = function() require("nelavim.nvimtree") end,
     config = function() require("tree.nvimtree") end
   }

   use {
     "nvim-lualine/lualine.nvim",
     requires = { "kyazdani42/nvim-web-devicons" },
   }

   use {
     "windwp/nvim-autopairs",
     config = function()
       require("nvim-autopairs").setup({
         fast_wrap = { map = "<M-w>" }
       })
     end,
   }

   use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
   use {
     "nvim-treesitter/playground",
     -- opt = true,
     -- cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
   }

   use {
     "neovim/nvim-lspconfig",
     "williamboman/nvim-lsp-installer",
     "ray-x/lsp_signature.nvim",
     "folke/lua-dev.nvim",
     "SmiteshP/nvim-navic",
   }

  use {
     "nvim-telescope/telescope.nvim",
     requires = {
       { "nvim-lua/plenary.nvim" },
     },
    config = function() require("nelescope").setup() end,
   }

  use {
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    { "nvim-telescope/telescope-symbols.nvim" },
  }

   use {
     "hrsh7th/nvim-cmp",
     "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-nvim-lsp",
     "hrsh7th/cmp-path",
     "hrsh7th/cmp-nvim-lua",
     "hrsh7th/cmp-omni",
     "hrsh7th/cmp-cmdline"
   }

   use {
     "L3MON4D3/LuaSnip",
     "saadparwaiz1/cmp_luasnip",
    -- "molleweide/luasnip_snippets.nvim"
     "molleweide/LuaSnip-snippets.nvim"
   }

   if has("mac") then
     use { "~/projects/friendly-snippets" }
   else
     use { "rafamadriz/friendly-snippets" }
   end

   use {
     "mfussenegger/nvim-dap",
     -- ft = { "java", "python" }
   }

   use {
     "mfussenegger/nvim-jdtls",
     -- opt = true,
     -- ft = { java"java" }
   }

   use {
     "Pocco81/DAPInstall.nvim",
     opt = true,
     cmd = { "DIList", "DIInstall" },
     disable = true,
   }

   use {
     "hoschi/yode-nvim",
     requires = { "nvim-lua/plenary.nvim" },
     config = function ()
       require("yode-nvim").setup()
     end,
     opt = true,
     cmd = {
       "YodeCreateSeditorFloating",
       "YodeCreateSeditorReplace",
     }
   }

   use {
    "lewis6991/gitsigns.nvim",
     requires = { "nvim-lua/plenary.nvim" },
     -- opt = true,
     config = function() require("gitsigns").setup() end,
     -- cmd = { "Gitsigns preview_hunk"}
   }

   if has("mac") then
     use {
       "brymer-meneses/grammar-guard.nvim",
       config = function () require("grammar-guard").init() end
     }

     use {
       "norcalli/nvim-colorizer.lua",
       config = function() require("colorizer").setup() end,
       opt = true,
       cmd = { "ColorizerAttachToBuffer" }
     }

     use {
       "iamcco/markdown-preview.nvim",
       -- opt = true,
       cmd = { "MarkdownPreview" },
      run = "cd app && pnpm install && pnpm add msgpack-lite",
       ft = { "markdown" },
        setup = function () vim.g.mkdp_filetypes = { "markdown" } end,
     }

     use {
       "lervag/vimtex",
       ft = { "tex" },
       cmd = { "VimtexCompile", "VimtexView" },
       opt = true
     }

     use {
       "davidgranstrom/scnvim",
       ft = { "supercollider" },
       run = function() vim.fn["-> scnvim#install"]() end,
       config = function() require("scnvim") end
     }

     use {
       "tomlion/vim-solidity",
       ft = { "sol" },
       opt = true
     }
   end
 end,
   config = {
     display = {
       open_fn = function()
        return require("packer.util").float({ border = "single" })
      end
     }
   }
  }
)
