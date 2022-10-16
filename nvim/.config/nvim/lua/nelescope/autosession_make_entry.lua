local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local autosession = require('auto-session')
local str = require('plenary.strings')
local path = require('plenary.path')
local utils = require('telescope.utils')

-- From https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6b4e22777bfa6a31787a4ac8e086b062ef241ede/lua/telescope/_extensions/file_browser/make_entry.lua#L35
local YEAR = os.date '%Y'
local DATE = {
  width = 13,
  right_justify = true,
  display = function(entry)
    local mtime = entry.stat.mtime.sec
    if YEAR ~= os.date('%Y', mtime) then
      return os.date('%b %d  %Y', mtime)
    end
    return os.date('%b %d %H:%M', mtime)
  end,
  hl = 'TelescopePreviewDate',
}

local SIZE_TYPES = { '', 'K', 'M', 'G', 'T', 'P', 'E', 'Z' }
local SIZE = {
  width = 7,
  right_justify = true,
  display = function(entry)
    local size = entry.stat.size
    -- TODO(conni2461): If type directory we could just return 4.0K
    for _, v in ipairs(SIZE_TYPES) do
      local type_size = math.abs(size)
      if type_size < 1024.0 then
        if type_size > 9 then
          return string.format('%3d%s', size, v)
        else
          return string.format('%3.1f%s', size, v)
        end
      end
      size = size / 1024.0
    end
    return string.format('%.1f%s', size, 'Y')
  end,
  hl = 'TelescopePreviewSize',
}

local stat_enum = { date = DATE, size = SIZE }

local my_displayer = function(stuff)
  return require('telescope.pickers.entry_display').create {
      separator = ' ',
      items = stuff,
    }
end


local make_entry = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local root = autosession.get_root_dir()

  local mt = {}

  mt.display = function(entry)
    local display_items = {}
    local display_widths = {}
    local icon, icon_hl = utils.get_devicons(entry.ordinal, false)
    table.insert(display_widths, { width = str.strdisplaywidth(icon) })
    table.insert(display_items, { icon, icon_hl })

    local displayer = my_displayer(display_widths)
    return displayer(display_items)
  end

  return function(entry)
    return {
      value = entry,
      ordinal = entry,
      filename = entry,
      path = path:new(root, entry):absolute()
    }
  end
end

local source_session = function(bufnr)
  local selection = actions_state.get_selected_entry()
  actions.close(bufnr)
  vim.defer_fn(function ()
    autosession.AutoSaveSession()
    vim.cmd('%bd!')
    autosession.RestoreSession(selection.path)
  end, 50)
end

local delete_session = function (bufnr)
  local curr_picker = actions_state.get_current_picker(bufnr)
  curr_picker:delete_selection(function(selection)
    autosession.DeleteSession(selection.path)
  end)
end

local M = {}

M.search_sessions = function()
  local opts = {
    prompt_title = 'Sessions',
    previewer = false,
    cwd = autosession.conf.auto_session_root_dir,
    entry_maker = make_entry,
    attach_mappings = function(_, map)
      actions.select_default:replace(source_session)
      map('i', '<C-d>', delete_session)
      return true
    end,
  }

  require('telescope.builtin').find_files(opts)
end

return M
