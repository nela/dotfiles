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
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LS P server to
      -- provide the inlay hints.
      inlay_hints = { enabled = false, },

      -- add any global capabilities here
      -- capabilities = {},
      -- Automatically format on save autoformat = true,
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues format_notify = false,
      -- options for vim.lsp.buf.format `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = { formatting_options = nil, timeout_ms = nil, },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        -- jsonls = {},

      },
    },
    config = function(_, opts)
      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      require('util').on_attach(function(_, buf)
        local ok, lspsignature = pcall(require, 'lsp_signature')
        if not ok then
          return
        end
        lspsignature.on_attach({
            bind = true,
            handler_opts = {
              border = 'shadow' --'rounded',
            -- floating_window = false,
            -- hint_prefix = "",
            },
          }, buf)
        end
      )

      local setup = function(server)
        local server_opts = vim.tbl_deep_extend( 'force', {
          capabilities = vim.deepcopy(capabilities)
        }, servers[server] or {})

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
