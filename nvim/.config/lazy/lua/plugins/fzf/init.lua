return {
  {
    "ibhagwan/fzf-lua",
    --event = "VeryLazy",

    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    --config = function()
    -- calling `setup` is optional for customization
      --require("fzf-lua").setup({})
    --end

    keys = {
      { "<leader>fb", function() require("fzf-lua").buffers() end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>zsh", function() require("fzf-lua").files({cwd = os.getenv("DOTS") .. "/zsh"}) end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>ff", function() require("fzf-lua").files() end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>sg", function() require'fzf-lua'.grep({ multiprocess=true, debug=true }) end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>lg", function() require'fzf-lua'.live_grep_native({ multiprocess=true, debug=true }) end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>cp", function() require("fzf-lua").complete_path() end, { "n", "v", "i" }, silent = true, desc = "Fuzzy complete path" },
    },
    opts = {
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
          ["<C-r>"] = "preview-page-reset",
        },
      },
      grep = {
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob '!{node_modules/,.git/}' -e",
      }
    }
  }
}
