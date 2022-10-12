local M = {}

M.search_directory = function(prompt_title, cwd)
  require("telescope.builtin").find_files({
    prompt_title = prompt_title,
    cwd = cwd,
    hidden = true
  })
end

return M
