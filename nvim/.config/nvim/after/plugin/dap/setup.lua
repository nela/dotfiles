local deps_ok, dap_virtual_text, dapui, dapui_widgets, dap = pcall(function()
    return require "nvim-dap-virtual-text", require "dapui", require "dap.ui.widgets", require "dap"
end)
if not deps_ok then
    return
end

local dapui_opts = {
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "stacks", size = 0.4 },
        { id = "watches", size = 0.3 },
        { id = "breakpoints", size = 0.3 },
        -- "breakpoints",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        -- "console",
        { id = "repl", size = 0.5 },
        { id = "scopes", size = 0.5 },
      },
      size = 0.4, -- 25% of total lines
      position = "bottom",
    },
  },
}

dap_virtual_text.setup()
dapui.setup(dapui_opts)

local map = vim.keymap.set

local function c(func, opts)
    return function()
        func(opts)
    end
end

map("n", "<leader>d.", c(dap.run_to_cursor))
map("n", "<leader>dJ", c(dap.down))
map("n", "<leader>dK", c(dap.up))
map("n", "<leader>dL", function()
    dap.list_breakpoints()
    vim.cmd.copen()
end)
map("n", "<leader>dX", function()
    dap.terminate()
    -- dapui.close()
end)

map("n", "<leader>da", c(dap.toggle_breakpoint))
map("n", "<leader>dc", c(dap.continue))
map("n", "<leader>dh", c(dap.step_back))
map("n", "<leader>dj", c(dap.step_into))
map("n", "<leader>dk", c(dap.step_out))
map("n", "<leader>dl", c(dap.step_over))
map("n", "<leader>dr", c(dap.run_last))
map("n", "<leader>dx", c(dap.clear_breakpoints))
map("n", "<leader>dR", c(dap.toggle_repl))

map("v", "<M-e>", c(dapui.eval))
map("n", "<leader>d?", c(dapui_widgets.hover))

dap.listeners.after.event_initialized["dapui_config"] = c(dapui.open)
dap.listeners.before.event_terminated["dapui_config"] = c(dapui.close)
dap.listeners.before.event_exited["dapui_config"] = c(dapui.close)
dap.listeners.after.event_loadedSource["dapui_config"] = c(dapui.open)


vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "WarningMsg" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "MatchParen", linehl = "CursorLine" })

dap.set_log_level('TRACE')

-- TODO: add <cexpr> to watch expressions
