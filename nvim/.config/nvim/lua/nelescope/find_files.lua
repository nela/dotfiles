local builtin = require("telescope.builtin")
local M = {}

M.search_directory = function(prompt_title, cwd)
  builtin.find_files({
    prompt_title = prompt_title,
    cwd = cwd,
    hidden = true
  })
end

-- M.search_dotfiles = function()
--   builtin.find_files({
--     prompt_title = "Dotfiles",
--     cwd = vim.env.DOTS,
--     hidden = true
--   })
-- end
--
-- M.search_nvimfiles = function()
--   builtin.find_files({
--     prompt_title = "Neovim Files",
--     cwd = vim.env.NVIM,
--     hidden = true
--   })
-- end
--
-- M.search_zshfiles = function()
--   builtin.find_files({
--     prompt_title = "Zsh Files",
--     cwd = vim.env.DOTS,
--     search_dirs = { vim.env.ZSH, vim.env.DOTS .. "/scripts" },
--     hidden = true
--   })
-- end

return M
