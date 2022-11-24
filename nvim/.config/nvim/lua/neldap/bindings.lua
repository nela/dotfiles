local M = {}

local dap = require("dap")


M.set_buf_keymap = function(bufnr)
  local buf_set_keymap = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
  end

  local kmap = function(func, opts)
    return function()
      func(opts)
    end
  end

  buf_set_keymap("<leader>d.", kmap(dap.run_to_cursor))

  -- print("dap buf set keymaps")

   -- buf_set_keymap("<F5>", function() dap.continue() end)
   -- buf_set_keymap("<F10>", function() dap.step_over() end)
   -- buf_set_keymap("<F11>", function() dap.step_into() end)
   -- buf_set_keymap("<F12>", function() dap.step_out() end)
   -- buf_set_keymap("<leader>b", function() dap.toggle_breakpoint() end)
   -- buf_set_keymap("<leader>B", function() dap.set_breakpoint() end)
   -- buf_set_keymap("<leader>lp", function() dap.set_breakpoint() end)
   -- buf_set_keymap("<leader>dr", function() dap.repl.open() end)
   -- buf_set_keymap("<leader>dl", function() dap.run_last() end)
end

return M
