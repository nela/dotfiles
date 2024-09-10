local M = {}

function M.setup(opts)
  local function _load(name)
    require("config." .. name)
    local pattern = "NelaVim" .. name:sub(1,1):upper() .. name:sub(2)
    vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
  end


  require("config.options")

  if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("NelaVim", { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        _load("autocmds")
        _load("keymaps")
        print("autocmd")
      end
    })
  else
    print('second')
    _load("autocmds")
    _load("keymaps")
  end

  require("config.lazy")

  local scheme = opts["colorscheme"]
  require('lazy.core.util').try(function()
    if type(scheme) == 'function' then
      scheme()
    else
      vim.cmd.colorscheme(scheme)
    end
  end, {
      msg = 'Unable to load colorscheme',
      on_error = function(msg)
        require('lazy.core.util').error(msg)
        vim.cmd.colorscheme('habamax')
      end
    })
end


return M
