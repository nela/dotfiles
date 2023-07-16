local jdtls = require('jdtls')
local lsp_bindings = require("nelsp.bindings")
local dap_bindings = require("neldap.bindings")

local add_keymaps = function(bufnr)
  local buf_set_keymap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end
  buf_set_keymap("n", "<A-o>", function() jdtls.organize_imports() end)
  buf_set_keymap("n", "crv", function() jdtls.extract_variable() end)
  buf_set_keymap("v", "crv", function() jdtls.extract_variable(true) end)
  buf_set_keymap("n", "crc", function() jdtls.extract_constant() end)
  buf_set_keymap("v", "crc", function() jdtls.extract_constant(true) end)
  buf_set_keymap("v", "crm", function() jdtls.extract_method(true) end)
end

local add_commands = function()
  vim.api.nvim_create_user_command("JdtTestClass", jdtls.test_class, {})
  vim.api.nvim_create_user_command("JdtTestNearestMethod", jdtls.test_nearest_method, {})
end

local sys_apendix = nil
if vim.fn.has("mac") then
  sys_apendix = "/config_mac"
else
  sys_apendix = "/config_linux"
end

local jdtls_version = "1.18.0"
local helpers = {
  java_home = os.getenv('JAVA_HOME'),
  data_home = os.getenv('XDG_DATA_HOME'),
  project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  jdtls_path = os.getenv('XDG_DATA_HOME') .. "/lsp_servers/jdtls-" .. jdtls_version,
}

local paths = {
  sys_config = helpers.jdtls_path .. sys_apendix,
  jdtls_jar = helpers.jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
  eclipse_jdtls_workspace = helpers.data_home .. '/eclipse_jdtls_workspaces/' .. helpers.project_name,
  java_debug = helpers.data_home .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
  vscode_java_test = helpers.data_home .. '/vscode-java-test/server/*.jar',
}

local bundles = { vim.fn.glob(paths.java_debug) };
vim.list_extend(bundles, vim.split(vim.fn.glob(paths.vscode_java_test), "\n"))

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
    add_commands()
    add_keymaps(bufnr)
    lsp_bindings.set_commands()
    lsp_bindings.set_buf_keymap(bufnr)
    dap_bindings.set_buf_keymap(bufnr)

    require("nvim-navic").attach(client, bufnr)
    -- require("aerial").on_attach(client, bufnr)
  end
}

jdtls.start_or_attach(config)
