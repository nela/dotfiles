return {
  {
    "stevearc/conform.nvim",
    -- event = { ""}
    cmd = "ConformInfo",
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        typescript = { 'prettier' }
      },
    },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true }) end,
        mode = { "n" },
        desc = "Format buffer",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true }, function(err)
            if not err then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
          end)
        end,
        mode = { "v" },
        desc = "Leave v-mode after range format."
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  }
}
