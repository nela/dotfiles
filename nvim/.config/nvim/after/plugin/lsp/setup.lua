-- Copied from
-- https://github.com/williamboman/nvim-config/blob/main/plugin/lsp/setup.lua
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

-- local path = require("plenary.path")
local util = require("lspconfig.util")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local common_on_attach = require("nelsp.on_attach")

-- Should be unnecessary due to update to default_capabilities
local create_capabilities = function(opts)
  opts = opts or { with_snippet_support = true }
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
  if opts.with_snippet_support then
    vim.list_extend(capabilities.textDocument.completion.completionItem.resolveSupport.properties, {
      "documentation",
      "detail",
      "additionalTextEdits",
    })
  end
  return cmp_nvim_lsp.update_capabilities(capabilities)
end

util.on_setup = util.add_hook_after(util.on_setup, function(config)
  if config.on_attach then
    config.on_attach = util.add_hook_after(config.on_attach, common_on_attach)
  else
    config.on_attach = common_on_attach
  end
  -- local capabilities = create_capabilities()
  -- For Lsp snippet completion
  config.capabilities = vim.tbl_deep_extend("force",
    cmp_nvim_lsp.default_capabilities(),
    config.capabilities or {})
end)

lspconfig.kotlin_language_server.setup({
  cmd = { "/home/nela/kotlin-language-server/server/build/install/server/bin/kotlin-language-server" },
  filetypes = { "kotlin" },
  root_dir = util.root_pattern("pom.xml", "settings.gradle", ".git")
})

require("mason-lspconfig").setup({})

require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({})
  end,
    ["pylsp"] = function()
      lspconfig.pylsp.setup({
        settings = {
          configurationSources = { "flake8" },
          formatCommand = { "black" },
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
              black = { enabled = true },
              isort = { enabled = true, profile = "black"},
              flake8 = { enabled = true },
              -- pylint = {
              --   enabled = true,
              --   -- args = { "--rcfile", "~/volt/data-quality-bid-aggregator/pyproject.toml"}
              -- },
            }
          }
      }
      })
    end,
    ["tsserver"] = function()

      require("typescript").setup {
        server = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      }
  end,
  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup({
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false
          },
          -- format = {
          --   enable = false
          -- },
          diagnostics = {
            globals = "vim"
          }
        }
      }
    })
  end,
  ["ltex"] = function()
    local ltex_settings = {
      ltex = {
        enabled = { 'latex', 'tex', 'bib', 'markdown' },
        language = 'en-GB',
        diagnosticSeverity = 'information',
        setenceCacheSize = 2000,
        additionalRules = {
          enablePickyRules = true,
        },
        trace = { server = 'verbose' },
        dictionary = {},
        enabledRules = {},
        disabledRules = {},
        hiddenFalsePositives = {},
      }
    }
    ltex_settings.ltex.disabledRules['en-GB'] = { 'PASSIVE_VOICE' }
    ltex_settings.ltex.enabledRules['en-GB'] = { 'TEXT_ANALYSIS' }

    lspconfig.ltex.setup({
      settings = ltex_settings
    })
  end,
})

-- hook to nvim-lspconfig
-- require("grammar-guard").init()

-- lspconfig.grammar_guard.setup({
--   cmd = table.concat({ vim.fn.stdpath "data", "mason", "bin", "ltex-ls" }, "/")
-- })
