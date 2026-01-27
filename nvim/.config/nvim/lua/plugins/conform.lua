return {
  {
    'stevearc/conform.nvim',
    -- event = { ""}
    cmd = 'ConformInfo',
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        typescript = { 'prettier' },
        c = { 'clang_format' },
      },

      formatters = {
        clang_format = {
          prepend_args = { '--style=file', '--fallback-style=mozilla' },
        },
      },
    },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true })
        end,
        mode = { 'n' },
        desc = 'Format buffer',
      },
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true }, function(err)
            if not err then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
            end
          end)
        end,
        mode = { 'v' },
        desc = 'Leave v-mode after range format.',
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
