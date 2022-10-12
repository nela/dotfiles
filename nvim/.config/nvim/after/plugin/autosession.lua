local refresh_nvim_tree = function ()
  if not (packer_plugins["nvim-tree"] and packer_plugins["nvim-tree"].loaded) then
    return
  end

  local nt = require("nvim-tree")
  nt.change_dir(vim.fn.getcwd())
  nt.refresh()
end

local close_nvim_tree = function()
  if not (packer_plugins["nvim-tree"] and packer_plugins["nvim-tree"].loaded) then
    return
  end
  require("nvim-tree.view").close()
end

local refresh_lualine = function()
  require("lualine").refresh()
end


local opts = {
  auto_session_use_git_branch = true,
  auto_session_create_enabled = false,
  pre_save_cmds = { [[ silent tabdo v:lua.close_nvim_tree ]] },
  post_restore_cmds = { refresh_nvim_tree },
}

require('auto-session').setup(opts)
