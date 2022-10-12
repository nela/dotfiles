local layout_actions = require "telescope.actions.layout"

local keymap_set = function(lhs, rhs)
  vim.keymap.set("n", lhs, rhs)
end

local dots = nil

if vim.env.DOTS ~= nil then
  dots = vim.env.DOTS
else
  dots = "~/dotfiles"
end

local M = {}

local keymaps = function()
  keymap_set("<leader>ff", function() require('telescope.builtin').find_files() end)
  keymap_set("<leader>fg", function() require('telescope.builtin').live_grep() end)
  keymap_set("<leader>fb", function() require('telescope.builtin').buffers() end)
  keymap_set("<leader>fw", function() require('telescope.builtin').file_browser() end)
  keymap_set("<leader>fh", function() require('telescope.builtin').help_tags() end)
  keymap_set("<leader>gf", function() require('telescope.builtin').git_files() end)
  keymap_set("<leader>.gf", function() require('telescope.builtin').git_files({ use_buffer_cwd = true }) end)
  keymap_set("<leader>fc", function() require('telescope.builtin').commands() end)
  keymap_set("<leader>fr", function() require('telescope.builtin').registers() end)
  keymap_set("<leader>jl", function() require('telescope.builtin').jumplist() end)
  keymap_set("<leader>dot", function() require('nelescope.helpers').search_directory('Dotfiles', dots) end)
  keymap_set("<leader>zsh", function() require('nelescope.helpers').search_directory('Zsh', dots..'/zsh') end)
  keymap_set("<leader>vim", function() require('nelescope.helpers').search_directory('Nvim', dots..'/nvim/.config/nvim') end)
  keymap_set("<leader>fs", function() require('nelescope.autosession').search_sessions() end)
  keymap_set("<leader>.gc", function() require("telescope.builtin").git_commits() end)
  keymap_set("<leader>bc", function() require("telescope.builtin").git_bcommits() end)
  keymap_set("<leader>gs", function() require("telescope.builtin").git_stash() end)
end

M.setup = function()

  require("telescope").setup {
    defaults = {
      prompt_prefix = "❯ ",
      selection_caret = "❯ ",
      file_sorter = require("telescope.sorters").get_fzy_sorter,
      color_devicons = true,
      path_display = { truncate = 3 },
      -- winblend = 2,
      set_env = { ["COLORTERM"] = "truecolor" },
      sorting_strategy = "descending",
      layout_strategy = "flex",
      layout_config = {
        flex = {
          flip_columns = 161, -- half 27" monitor, scientifically calculated
        },
        horizontal = {
          preview_cutoff = 0,
          preview_width = 0.6,
        },
        vertical = {
          preview_cutoff = 0,
          preview_height = 0.65,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      mappings = {
        i = {
          ["<C-h>"] = "which_key",
          ["<C-l>"] = layout_actions.toggle_preview,
          ["<C-b>"] = "delete_buffer",
        },
        n = {
          ["<C-h>"] = "which_key",
          ["<C-l>"] = layout_actions.toggle_preview,
          ["<C-b>"] = "delete_buffer",
        }
      },
      dynamic_preview_title = true,
      file_ignore_patterns = {  "./.git", "^.git", "node_modules", "__pycache__", "terragrunt%-cache" }
    },
    pickers = {
      find_files = {
        hidden = true,
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      },
    },
  }

  keymaps()

  require("telescope").load_extension("fzf")

end

return M
