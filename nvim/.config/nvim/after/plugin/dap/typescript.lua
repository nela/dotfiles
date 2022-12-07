local deps_ok, js_debug, dap, util = pcall(function()
  return require "dap-vscode-js", require "dap", require("lspconfig.util")
end)
if not deps_ok then
  return
end

local root_files = {
  "package.json"
}

js_debug.setup {
  debugger_cmd = { "js-debug-adapter" },
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
}

for _, lang in ipairs { "typescript", "javascript" } do
  dap.configurations[lang] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "[pwa-node] Launch file",
      cwd = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h"))
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "[pwa-node] Attach",
      processId = require("dap.utils").pick_process,
      cwd = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h"))
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Test",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand"
      },
      rootPath = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")),
      cwd = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")),
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen"
    },
  }
end
