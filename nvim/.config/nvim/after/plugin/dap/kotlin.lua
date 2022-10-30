local ok, dap = pcall(require, 'dap')
if not ok then return end


dap.adapters.kotlin = {
    type = 'executable',
    command = os.getenv('XDG_REPO_HOME') .. '/kotlin-debug-adapter/adapter/build/install/adapter/bin/kotlin-debug-adapter',
    options = {
        -- cwd = os.getenv('XDG_REPO_HOME') .. '/kotlin-debug-adapter/adapter/build/install/adapter/bin',
        -- detached = false,
        initialize_timeout_sec = 15,
        disconnect_timeout_sec = 15,
    },
    id = 'mykotlin',
    auto_continue_if_many_stopped = false,
}
-- dap.adapters.kotlin = {
--     type = 'server',
--     host = "127.0.0.1",
--     port = "12345"
-- }

local root_files = {
    'settings.gradle',
    'settings.gradle.kts',
    'build.xml',
    'pom.xml'
}

local fallback = {
    'build.gradle',
    'build.gradle.kts',
    '.git'
}

dap.configurations.kotlin = {
    {
        type = 'kotlin',
        request = 'launch',
        name = "Kotlin",
        projectRoot = '/home/nela/projects/ktest/app',
        mainClass = 'ktest.AppKt',
        auto_continue_if_many_stopped = false,
    }
}
