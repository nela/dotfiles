local has = function(x)
  return vim.fn.has(x) == 1
end

local packer = nil

local function init()
  if packer == nil then
    packer = require 'packer'
  end

  local use = packer.use

  use 'wbthomason/packer.nvim'
  use 'sainnhe/gruvbox-material'
  use 'tpope/vim-surround'
  use 'wellle/targets.vim'
  use 'ggandor/lightspeed.nvim'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'

  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }

  end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
