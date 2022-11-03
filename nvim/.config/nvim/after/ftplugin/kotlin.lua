local ok, dap = pcall(require, 'dap')
if not ok then return end

local util = require('lspconfig.util')

-- local function enrich_dap_config(_config, on_config)
--   if _config.mainClass
--     and _config.projectRoot
--     and _config.modulePaths ~= nil
--     and _config.classPaths ~= nil then
--     on_config(_config)
--     return
--   end
--
--   local config = vim.deepcopy(_config)
--   config.projectRoot = '/home/nela/projects/ktest/app'
--   config.mainClass = 'ktest.AppKt'
--
--   on_config(config)
-- end

local root_files = {
  -- Single-module projects
  {
    'build.xml', -- Ant
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
  },
  -- Multi-module projects
  { 'build.gradle', 'build.gradle.kts' },
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

local resolve_mainclass = function()
    local root_dir = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h'))
    local cmd = '! grep "fun" -r ' .. root_dir
    local grep_res = vim.api.nvim_exec(cmd, true)
    local files = {}
    for f in string.gmatch(grep_res, '([%w+/]+[%w+.]kt)') do
        if not contains(files, f) then
            table.insert(files, f)
        end
    end

    local main_file
    if #files > 1 then
        vim.ui.select(files, { prompt = "Select main class file" }, function(choice)
            main_file = choice
        end)
    else
        main_file = files[1]
    end
    print(main_file)
end

resolve_mainclass()

dap.adapters.kotlin = {
    type = 'executable',
    command = os.getenv('XDG_REPO_HOME') .. '/kotlin-debug-adapter/adapter/build/install/adapter/bin/kotlin-debug-adapter',
    auto_continue_if_many_stopped = false,
    options = {
        -- cwd = os.getenv('XDG_REPO_HOME') .. '/kotlin-debug-adapter/adapter/build/install/adapter/bin',
        -- detached = false,
        initialize_timeout_sec = 15,
        disconnect_timeout_sec = 15,
        auto_continue_if_many_stopped = false,
    },
}

dap.configurations.kotlin = {
    {
        type = 'kotlin',
        request = 'launch',
        name = "Kotlin",
        projectRoot = util.root_pattern(root_files)(vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h')),
        mainClass = 'ktest.AppKt',
        auto_continue_if_many_stopped = false,
    }
}
