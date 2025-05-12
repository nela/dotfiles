local M = {}

M.formatexpr = function()
  if require("util").has('conform.nvim') then
    return require('con')
end

return M
