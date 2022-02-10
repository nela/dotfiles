local telly = require("telescope.builtin")
local M = {}

M.search_dotfiles = function()
  telly.find_files({
    prompt_title = "Dotfiles",
    cwd = vim.env.DOTS,
    hidden = true
  })
end

M.search_nvimfiles = function()
  telly.find_files({
    prompt_title = "Neovim Files",
    cwd = vim.env.NVIM,
    hidden = true
  })
end

M.search_zshfiles = function()
  telly.find_files({
    prompt_title = "Zsh Files",
    cwd = vim.env.DOTS,
    search_dirs = { vim.env.ZSH, vim.env.DOTS .. "/scripts" },
    hidden = true
  })
end

return M

-- vim.api.nvim_set_keymap('n', '<leader>zsh', '<cmd> search_zsh<CR>', { silent = true, noremap = true } )
