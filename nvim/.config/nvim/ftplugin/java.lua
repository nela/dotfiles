local has = function(x)
  return vim.fn.has(x) == 1
end

local java_home = os.getenv('JAVA_HOME')
local xdg_data_home = os.getenv('XDG_DATA_HOME')
local jdtls_jar = xdg_data_home .. '/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local eclipse_jdtls_workspace = xdg_data_home .. '/eclipse_jdtls_workspaces/' .. project_name
local sys_config = xdg_data_home .. '/nvim/lsp_servers/jdtls'

local java_debug = os.getenv('REPOS') .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'

if has('mac') then
  sys_config = sys_config .. '/config_mac'
else
  sys_config = sys_config .. '/config_linux'
end

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

  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {}
  },

  init_options = {
    bundles = {
      vim.fn.glob(java_debug)
    }
  },
  on_attach = function(client, bufnr)
    require('jdtls').setup_dap({ hotcoderreplace = 'auto' })
    require('jdtls.setup').add_commands()
  end
}

require('jdtls').start_or_attach(config)
