return {
  {
    "stevearc/conform.nvim",
    lazy = "VeryLazy",
    cmd = "ConformInfo",
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
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
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opts)
      vim.api.nvim_create_user_command("FormatAsync", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, range = range })
      end, { range = true })
      require("conform").setup(opts)
    end
  }
}
