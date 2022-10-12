local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

local autosession = require("auto-session")
local path = require("plenary.path")
local M = {}

local get_vim_icon = function()
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    if not devicons.has_loaded() then devicons.setup() end
    return devicons.get_icon_by_filetype("vim")
  end
end

local determine_display_items = function(icon)
  local items = {
    { width = 40 },
    { remaining = true}
  }
  if icon then table.insert(items, 1, { width = 2 }) end
  return items
end

local entry_maker = function()
  local root = autosession.get_root_dir()
  local icon, hl_group = get_vim_icon()

  local items = determine_display_items(icon)

  local displayer = require("telescope.pickers.entry_display").create {
      separator = " ",
      items = items,
    }

  local make_display = function(entry)
    if icon and hl_group then
      return displayer {
        { icon, hl_group },
        { entry.value },
        { entry.date, "Yellow"}
      }
    else
      return displayer {
        { entry.value },
        { entry.date }
      }
    end
  end

  return function (entry)
    if entry == "" then return nil end
    local out = require("auto-session-library").unescape_dir(entry):match("(.+)%.vim")
    return {
      ordinal = entry,
      value = out,
      filename = out,
      date = os.date("%c", io.popen("stat -c %Y " .. path:new(root, entry):absolute()):read()),
      display = make_display,
      path = path:new(root, entry):absolute()
  }
  end
end

local source_session = function(bufnr)
  local selection = actions_state.get_selected_entry()
  actions.close(bufnr)
  vim.defer_fn(function ()
    autosession.AutoSaveSession()
    vim.cmd("%bd!")
    autosession.RestoreSession(selection.path)
  end, 50)
end

local delete_session = function (bufnr)
  local curr_picker = actions_state.get_current_picker(bufnr)
  curr_picker:delete_selection(function(selection)
    autosession.DeleteSession(selection.path)
  end)
end

M.search_sessions = function()
  local opts = {
    prompt_title = "Sessions",
    -- previewer = false,
    cwd = autosession.conf.auto_session_root_dir,
    entry_maker = entry_maker(),
    attach_mappings = function(_, map)
      actions.select_default:replace(source_session)
      map("i", "<C-d>", delete_session)
      return true
    end,
  }

  require("telescope.builtin").find_files(opts)
end

return M
