vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.pack.add({
  'git@github.com:nvim-mini/mini.misc.git',
})

_G.Config = {}

local misc = require('mini.misc')
Config.now = function(f)
  misc.safely('now', f)
end

Config.later = function(f)
  misc.safely('later', f)
end

Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f)
  misc.safely('event:' .. ev, f)
end

Config.on_filetype = function(ft, f)
  misc.safely('filetype:' .. ft, f)
end

local gr = vim.api.nvim_create_augroup('nelavim.config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.spec.kind
    if name ~= plugin_name or not vim.tbl_contains(kinds, kind) then
      return
    end

    if not ev.data.active then
      vim.pack.add(plugin_name)
    end

    callback(ev)
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end
Config.gh = function(plugin)
  return 'git@github.com:' .. plugin .. '.git'
end

Config.cb = function(plugin)
  return 'https://codeberg.org/' .. plugin
end

-- require('base')
