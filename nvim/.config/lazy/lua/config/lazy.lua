local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
    		"clone",
    		"--filter=blob:none",
    		"git@github.com:folke/lazy.nvim.git",
        -- "https://github.com/folke/lazy.nvim.git",
    		"--branch=stable", -- latest stable release
    		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function() vim.g.startuptime_tries = 10 end,
    },
    {
      "m4xshen/hardtime.nvim",
      dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
      opts = {},
      event = "VeryLazy"
    },
    { import = "plugins" },
    { import = "ft" }
  },
  install = { missing = false },
  ui = {
    border = "rounded"
  },
  defaults = { lazy = true },
	performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin"
      }
    }
  }
})
