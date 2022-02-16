  local has = function(x)
  return vim.fn.has(x) == 1
end

local java_home = os.getenv('JAVA_HOME')
local xdg_data_home = os.getenv('XDG_DATA_HOME')
local repos = os.getenv('REPOS')

local jdtls_jar = xdg_data_home .. '/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local eclipse_jdtls_workspace = xdg_data_home .. '/eclipse_jdtls_workspaces/' .. project_name
local sys_config = xdg_data_home .. '/nvim/lsp_servers/jdtls'

local java_debug = repos .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
local vscode_java_test = repos .. '/vscode-java-test/server/*.jar'

if has('mac') then
  sys_config = sys_config .. '/config_mac'
else
  sys_config = sys_config .. '/config_linux'
end

local bundles = {
    vim.fn.glob(java_debug),
};
vim.list_extend(bundles, vim.split(vim.fn.glob(vscode_java_test), "\n"))

local jdtls = require('jdtls')

local config = {
  cmd = {
    -- java_home .. '/bin/java',
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', jdtls_jar,
    '-configuration', sys_config,
    '-data', eclipse_jdtls_workspace --'/path/to/unique/per/project/workspace/folder'
  },

  root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew'}),

  settings = { java = {} },

  init_options = { bundles = bundles },

  on_attach = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls.setup.add_commands()
    jdtls.update_project_config()
  end
}

jdtls.start_or_attach(config)

-- vim.cmd('source ' .. os.getenv('NVIM') .. '/opt/dapbindings.vim')
