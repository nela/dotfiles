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
      inlay_hints = { enabled = true, },

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
      local util = require("util")

      if util.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      util.on_attach(function(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
        require("plugins.lsp.commands").on_attach(client, buffer)
      end)

      local handlers = require("plugins.lsp.handlers")
      handlers.update_register_capabilities(require("plugins.lsp.keymaps").on_attach)
      handlers.update_rename()
      require("plugins.lsp.ui").redefine_diagnostic_signs()

      vim.diagnostic.config({
        float = {
          show_header = true,
          border = "rounded",
          source = "always",
          -- format = function(d)
          --   local t = vim.deepcopy(d)
          --   local code = d.code or d.user_data.lsp.code
          --   if code then
          --     t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
          --   end
          --   return t.message
          -- end,
        },
        severity_sort = true,
        update_in_insert = false,
      })

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if opts.inlay_hints.enabled and inlay_hint then
        util.on_attach(function(client, buffer)
          if client.supports_method('textDocument/inlayHint') then
            inlay_hint(buffer, true)
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

      util.on_attach(function(_, buf)
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
