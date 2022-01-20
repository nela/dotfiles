--[[ require('telescope').setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    color_devicons = true,

    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    },

    dynamic_preview_title = true,
    file_ignore_patterns = {  "./.git", "node_modules", "__pycache__", "terragrunt%-cache" }
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
  }
}

require('telescope').load_extension('fzf') ]]
