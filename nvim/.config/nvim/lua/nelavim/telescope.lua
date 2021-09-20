local M = {}

M.search_dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "< Dotfiles >",
    cwd = vim.env.DOTFILES,
    hidden = true
  })
end

return M
