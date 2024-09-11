return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          -- prefix = "x",
          prefix = "icons",
          format = function(diagnostic)
              -- Use shorter, nicer names for some sources:
              local special_sources = {
                  ['Lua Diagnostics.'] = 'lua',
                  ['Lua Syntax Check.'] = 'lua',
              }

              local source = special_sources[diagnostic.source] or diagnostic.source
              return string.format('%s[%s] ', source, diagnostic.code)
          end,
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LS P server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        -- exclude = { "lua" }
      },

      -- add any global capabilities here
      -- capabilities = {},
      -- Automatically format on save
      -- autoformat = true,
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = false,
      -- options for vim.lsp.buf.format `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = { formatting_options = nil, timeout_ms = nil, },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        -- jsonls = {},
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)

      local util = require('util')

      util.lsp.setup()
      --register handlers
      require("plugins.lsp.handlers")
      require("plugins.lsp.ui")

      --setup keymaps
      util.lsp.on_attach(function(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      util.lsp.on_dynamic_capability(require('plugins.lsp.keymaps').on_attach)

      if opts.inlay_hints.enabled then
        util.lsp.on_supports_method('textDocument/inlayHint' , function(_, buffer)
          vim.print('running inlay hint function')
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude or {}, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      if util.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      local setup = function(server)
        local server_opts = vim.tbl_deep_extend( 'force', {
          capabilities = vim.deepcopy(capabilities)
        }, servers[server] or {})

        if server_opts.enabled == false then return end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          setup(server)
        end
      end
    end
  }
}
