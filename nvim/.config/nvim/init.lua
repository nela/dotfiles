vim.g.mapleader = " "
vim.g.maplocalleader = ","

local colorscheme = 'gruvbox-material'
local backup_colorscheme = 'habamax'

-- set up options first
require("options")

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
    { import = "plugins" },
    { import = "ft" },
  },
  install = { missing = false },
  ui = {
    border = "rounded",
  },
  change_detection = { notify = false },
  -- defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

--[[ require('lazy.core.util').try(function()
    vim.cmd.colorscheme(colorscheme)
end, {
  msg = 'Unable to load ' .. colorscheme .. ' colorscheme. Loading ' .. backup_colorscheme .. '.',
  on_error = function(msg)
    require('lazy.core.util').error(msg)
    vim.cmd.colorscheme(backup_colorscheme)
  end
}) ]]

-- new experimental command-line features.
-- Disabled: causes cursor jumping with LSP messages in Ghostty
-- if vim.fn.has('nvim-0.12') == 1 then
--   require('vim._extui').enable({})
-- end
