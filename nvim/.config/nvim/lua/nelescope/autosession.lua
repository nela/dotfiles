local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local str = require("plenary.strings")
local autosession = require("auto-session")
local path = require("plenary.path")

local M = {}

-- From https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6b4e22777bfa6a31787a4ac8e086b062ef241ede/lua/telescope/_extensions/file_browser/make_entry.lua#L35
local YEAR = os.date("%Y")
local DATE = {
  width = 13,
  right_justify = true,
  display = function(entry)
    local mtime = entry.stat.mtime.sec
    if YEAR ~= os.date("%Y", mtime) then
      return os.date("%b %d  %Y", mtime)
    end
    return os.date("%b %d %H:%M", mtime)
  end,
  hl = "TelescopePreviewDate",
}

local SIZE_TYPES = { "", "K", "M", "G", "T", "P", "E", "Z" }
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
          return string.format("%3d%s", size, v)
        else
          return string.format("%3.1f%s", size, v)
        end
      end
      size = size / 1024.0
    end
    return string.format("%.1f%s", size, "Y")
  end,
  hl = "TelescopePreviewSize",
}

local stat_enum = { date = DATE, size = SIZE }

local get_vim_icon = function()
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    if not devicons.has_loaded() then
      devicons.setup()
    end
    return devicons.get_icon_by_filetype("vim")
  end
end

local make_entry = function()
  local root = autosession.get_root_dir()
  local mt = {}

  mt.display = function(entry)
    local display_widths = {}
    local display_items = {}
    local icon, icon_hl = get_vim_icon()

    table.insert(display_widths, { width = str.strdisplaywidth(icon) })
    table.insert(display_items, { icon, icon_hl })

    table.insert(display_widths, { remaining = true })
    table.insert(display_items, entry.stat and entry.value)

    for _, v in pairs(stat_enum) do
      if entry.stat then
        table.insert(display_widths, { remaining = true, right_justify = v.right_justify })
        table.insert(display_items, { v.display(entry), v.hl })
      end
    end

    local displayer = require("telescope.pickers.entry_display").create({
      separator = " ",
      items = display_widths,
    })

    return displayer(display_items)
  end

  mt.__index = function(t, k)
    local raw = rawget(mt, k)
    if raw then
      return raw
    end

    if k == "stat" then
      local stat = vim.loop.fs_stat(root .. "/" .. t.ordinal)
      t.stat = vim.F.if_nil(stat, false)
      if not t.stat then
        local lstat = vim.F.if_nil(vim.loop.fs_lstat(root .. "/" .. t.ordinal), false)
        if not lstat then
          print("Unable to get stat for " .. root .. "/" .. t.ordinal)
        end
      end
      return stat
    end
    return rawget(t, rawget({ value = 1 }, k))
  end

  return function(entry)
    local out = require("auto-session-library").unescape_dir(entry):match("(.+)%.vim")
    return setmetatable({
      value = out,
      ordinal = entry,
      filename = out,
      path = path:new(root, entry):absolute(),
    }, mt)
  end
end

local source_session = function(bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(bufnr)
  vim.defer_fn(function()
    autosession.AutoSaveSession()
    vim.cmd("%bd!")
    autosession.RestoreSession(selection.path)
  end, 50)
end

local delete_session = function(bufnr)
  local curr_picker = action_state.get_current_picker(bufnr)
  curr_picker:delete_selection(function(selection)
    autosession.DeleteSession(selection.path)
  end)
end

M.search_sessions = function()
  local opts = {
    prompt_title = "Sessions",
    -- previewer = false,
    cwd = autosession.get_root_dir(),
    entry_maker = make_entry(),
    -- layout_config = { width = 0.3 },
    attach_mappings = function(_, map)
      actions.select_default:replace(source_session)
      map("i", "<C-d>", delete_session)
      return true
    end,
  }

  require("telescope.builtin").find_files(opts)
end

return M
