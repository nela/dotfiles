
print("here")

local add_keymaps = function(bufnr)
  local buf_set_keymap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end
  buf_set_keymap("n", "<A-o>", require("jdtls").organize_imports)
  buf_set_keymap("n", "crv", require("jdtls").extract_variable())
  buf_set_keymap("v", "crv", require("jdtls").extract_variable(true))
  buf_set_keymap("n", "crc", require("jdtls").extract_constant())
  buf_set_keymap("v", "crc", require("jdtls").extract_constant(true))
  buf_set_keymap("v", "crm", require("jdtls").extract_method(true))
end

local add_commands = function()
  vim.api.nvim_create_user_command("JdtTestClass", require("jdtls").test_class, {})
  vim.api.nvim_create_user_command("JdtTestNearestMethod", require("jdtls").test_nearest_method, {})
end

local sys_apendix = nil
if vim.fn.has("mac") then
  sys_apendix = "/config_mac"
else
  sys_apendix = "/config_linux"
end

local helpers = {
  java_home = os.getenv('JAVA_HOME'),
  data = os.getenv('XDG_DATA_HOME'),
  project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  repos = os.getenv('XDG_REPO_HOME'),
}

local paths = {
  sys_config = helpers.data .. '/nvim/lsp_servers/jdtls' .. sys_apendix,
  jdtls_jar = helpers.data .. '/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
  eclipse_jdtls_workspace = helpers.data .. '/eclipse_jdtls_workspaces/' .. helpers.project_name,
  java_debug = helpers.repos .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
  vscode_java_test = helpers.repos .. '/vscode-java-test/server/*.jar',
}

local bundles = { vim.fn.glob(paths.java_debug) };
vim.list_extend(bundles, vim.split(vim.fn.glob(paths.vscode_java_test), "\n"))

local jdtls = require('jdtls')
local lsp_bindings = require("nelsp.bindings")
local dap_bindings = require("neldap.bindings")

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
    '-jar', paths.jdtls_jar,
    '-configuration', paths.sys_config,
    '-data', paths.eclipse_jdtls_workspace --'/path/to/unique/per/project/workspace/folder'
  },
  root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew'}),
  settings = {
    java = {},
  },
  init_options = {
    bundles = bundles,
  },
  on_attach = function(client, bufnr)

    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls.setup.add_commands()
    jdtls.update_project_config()

    lsp_bindings.buf_set_keymaps(bufnr)
    lsp_bindings.set_commands()
    add_keymaps(bufnr)
    add_commands()
    dap_bindings.buf_set_keymaps(bufnr)
  end
}

jdtls.start_or_attach(config)
vim.cmd('source ' .. os.getenv('NVIM') .. '/opt/dapbindings.vim')
