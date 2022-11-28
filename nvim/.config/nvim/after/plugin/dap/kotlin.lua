local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local util = require("lspconfig.util")

local root_files = {
  -- Single-module projects
  {
    "build.xml", -- Ant
    "pom.xml", -- Maven
    "settings.gradle", -- Gradle
    "settings.gradle.kts", -- Gradle
  },
  -- Multi-module projects
  { "build.gradle", "build.gradle.kts" },
}

local contains = function(t, e)
  if next(t) == nil then
    return false
  end
  for _, v in ipairs(t) do
    if v == e then
      return true
    end
  end
  return false
end

local function resolve_classname()
  if (vim.bo.filetype ~= "kotlin") then return end
  local root_dir = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h"))
  if root_dir == nil then
    return
  end

  local cmd = '! grep "fun main(args: Array<String>)" -r ' .. root_dir
  local grep_res = vim.api.nvim_exec(cmd, true)
  local files = {}
  local mainfile, pkgname

  for f in string.gmatch(grep_res, "([%w+%p]+[%w+.]kt)") do
    if not contains(files, f) then
      table.insert(files, f)
    end
  end

  if #files > 1 then
    vim.notify("Multiple files contain 'fun main'", vim.log.levels.ERROR)
  else
    mainfile = files[1]
  end
  assert(mainfile, "Could not find a file matching \'fun main(args: Array<String>)\'")

  for line in io.lines(mainfile) do
    local match = line:match("package ([a-z\\.]+)")
    if match then
      pkgname = match
      break
    end
  end
  assert(pkgname, "Could not find package name for current class")
  return pkgname .. "." .. vim.fn.fnamemodify(mainfile, ":t:r") .. "Kt"
end

dap.defaults.kotlin.auto_continue_if_many_stopped = false

dap.adapters.kotlin = {
  type = "executable",
  command = os.getenv("XDG_REPO_HOME")
    .. "/kotlin-debug-adapter/adapter/build/install/adapter/bin/kotlin-debug-adapter",
  options = {
    initialize_timeout_sec = 60,
    disconnect_timeout_sec = 60,
  },
}

--[[ dap.configurations.kotlin = {
  {
    type = "kotlin",
    request = "launch",
    name = "Kotlin",
    projectRoot = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")),
    mainClass = resolve_classname(),
  },
} ]]

-- debug
dap.configurations.kotlin = {
  {
    type = "kotlin",
    request = "attach",
    hostName = "127.0.0.1",
    port = 5005,
    timeout = 20,
    name = "Kotlin",
    projectRoot = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")),
    mainClass = resolve_classname(),
  }
}
