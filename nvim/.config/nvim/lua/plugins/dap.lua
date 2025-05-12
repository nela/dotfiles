
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    event = { "BufReadPre" },
    keys = function(_, keys)
      local dap = require("dap")
      return {
        { "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() dap.continue() end, desc = "Continue" },
        { "<leader>dC", function() dap.run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() dap.goto_() end, desc = "Go to line (no execute)" },
        { "<leader>di", function() dap.step_into() end, desc = "Step Into" },
        { "<leader>dj", function() dap.down() end, desc = "Go up in current stacktrace." },
        { "<leader>dk", function() dap.up() end, desc = "Go down in current stacktrace." },
        { "<leader>dl", function() dap.run_last() end, desc = "Run Last" },
        { "<leader>dO", function() dap.step_out() end, desc = "Step Out" },
        { "<leader>do", function() dap.step_over() end, desc = "Step Over" },
        { "<leader>df", function() dap.focus_frame() end, desc = "Move cursor to current dap line." },
        { "<leader>dp", function() dap.pause() end, desc = "Pause" },
        { "<leader>dr", function() dap.repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>ds", function() dap.session() end, desc = "Session" },
        { "<leader>dt", function() dap.terminate() end, desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      }
    end,
    config = function ()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual"} )
      local icons = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
       }

      for name, sign in pairs(icons) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "nvim-neotest/nvim-nio" ,
        "theHamsta/nvim-dap-virtual-text"
      },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {
      force_buffers = true,
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      layouts = {
        {
          elements = {
            { id = "watches", size = 0.23 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.3 },
            { id = "scopes", size = 0.3 },
          },
          position = "left",
          size = 40,
        }, {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 }
          },
          position = "bottom",
          size = 10
        }
      }
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  }
}
