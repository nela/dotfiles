local telly = require('telescope')

telly.setup {
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

require('telescope').load_extension('fzf')

-- local telly_builtin = telly.builtin() -- require("telescope.builtin")
-- local telly_builtin = telly('builtin')
local telly_builtin = require("telescope.builtin")
local M = {}

M.search_dotfiles = function()
  telly_builtin.find_files({
    prompt_title = "Dotfiles",
    cwd = vim.env.DOTS,
    hidden = true
  })
end

M.search_nvimfiles = function()
  telly_builtin.find_files({
    prompt_title = "Neovim Files",
    cwd = vim.env.NVIM,
    hidden = true
  })
end

M.search_zshfiles = function()
  telly_builtin.find_files({
    prompt_title = "Zsh Files",
    cwd = vim.env.DOTS,
    search_dirs = { vim.env.ZSH, vim.env.DOTS .. "/scripts" },
    hidden = true
  })
end

return M

-- vim.api.nvim_set_keymap('n', '<leader>zsh', '<cmd> search_zsh<CR>', { silent = true, noremap = true } )
