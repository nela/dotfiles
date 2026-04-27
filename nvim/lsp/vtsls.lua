local vue_language_server_path = os.getenv('XDG_DATA_HOME') .. '/pnpm/global/5/node_modules/@vue/language-server'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local jsts_settings = {
  updateImportsOnFileMove = { enabled = 'always' },
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'literals' },
    variableTypes = { enabled = false },
    -- enumMemberValues = { enabled = true },
    -- parameterTypes = { enabled = true },
    -- propertyDeclarationTypes = { enabled = true },
  },
  tsserver = {
    globalPlugins = {
      vue_plugin,
    },
  },
}

---@type vim.lsp.Config
return {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.jsx',
    'vue',
  },
  root_dir = function(bufnr, cb)
    local fname = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))

    local ts_root = vim.fs.find('tsconfig.json', { upward = true, path = fname })[1]
    -- Use the git root to deal with monorepos where TypeScript is installed in the root node_modules folder.
    local git_root = vim.fs.find('.git', { upward = true, path = fname })[1]

    if git_root then
      cb(vim.fn.fnamemodify(git_root, ':h'))
    elseif ts_root then
      cb(vim.fn.fnamemodify(ts_root, ':h'))
    end
  end,
  settings = {
    complete_function_calls = true,
    typescript = jsts_settings,
    javascript = jsts_settings,
    --[[ vtsls = { -- set up by nvim-vtsls
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    } ]]
  },
}
