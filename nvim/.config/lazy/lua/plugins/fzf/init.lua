return {
  {
    "ibhagwan/fzf-lua",
    lazy = "BufReadPost",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        dir = '~/.local/share/fzf',
        cond = [[ vim.fn.has('mac') != 1]],
      },
      {
        dir = '/usr/local/opt/fzf',
        cond = [[ vim.fn.has('mac') == 1]],
      }
    },
    keys = {
      { "<leader>fb", function() require("fzf-lua").buffers() end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>fr", function() require("fzf-lua").registers() end, { "n", "v", "i" }, silent = true, desc = "Fuzzy complete path" },
      {
        "<leader>zsh",
        function() require("fzf-lua").files({ cwd = os.getenv("DOTS") .. "/zsh" }) end,
        { "n", "v" },
        silent = true,
        desc = "Fuzzy complete path"
      },
      { "<leader>dot", function() require("fzf-lua").files({cwd = os.getenv("DOTS") }) end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      { "<leader>vim", function() require("fzf-lua").files({cwd = os.getenv("NVIM")}) end, { "n", "v" }, silent = true, desc = "Fuzzy complete path" },
      {
        "<leader>ff",
        function() require("fzf-lua").files() end,
        { "n", "v" },
        silent = true,
        desc = "Fuzzy complete path"
      },
      {
        "<leader>fa",
        function() require("fzf-lua").files({
          fd_opts = ". --type f --unrestricted --follow -E .DS_Store"
        }) end,
        { "n", "v" },
        silent = true,
        desc = "Fuzzy complete path"
      },
      {
        "<leader>sg",
        function()
          require'fzf-lua'.grep({ multiprocess = true })
        end,
        { "n", "v" },
        silent = true,
        desc = "Static grep"
      },
      {
        "<leader>lg",
        function() require'fzf-lua'.live_grep({ multiprocess = true }) end,
        { "n", "v" },
        silent = true,
        desc = "Live Grep Native"
      },
    },
    opts = {
      fzf_opts = {
        ["--cycle"] = ""
      },
      defaults = {
        formatter = { "path.filename_first", 2 },
        path_shorten = true
      },
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
          ["<C-r>"] = "preview-page-reset",
        },
        fzf = {
          -- ["ctrl-q"] = "select-all+accept"
          ["ctrl-q"] = "toggle-all"
        },
      },
      grep = {
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob '!{node_modules/,.git/}' -e",
        -- fd_opts = ""
        path_shorten = true
      },
      previewers = {
        builtin = {
          title_fnamemodify = function(t, width)
            local min_left_padding = 4
            local min_right_padding = 4
            local max_text_width = width - min_left_padding - min_right_padding

            if #t > max_text_width then
              return "..." .. t:sub(#t - max_text_width + 3 + 1, #t)
            end
            return t
          end,
        }
      }
    },
    --[[ config = function()
      vim.keymap.set({ "n", "v", "i" }, "<C-x><C-p>",
        function() require("fzf-lua").complete_path() end,
        { silent = true, desc = "Fuzzy complete path" }
      )
    end ]]
  }
}
