local ok, winsep = pcall(require, "colorful-winsep")
if not ok then
    return
end

local opts = {
  highlight = {
    -- guifg = "#d65d0e"
    guifg = "#6e3109"
  },

  create_event = function()
    local win_n = require("colorful-winsep.utils").getWinNumber()
    if win_n == 2 then
      local win_id = vim.fn.win_getid(vim.fn.winnr('h'))
      local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), 'filetype')
      if ft == "NvimTree" then
        winsep.NvimSeparatorDel()
      end
    end
  end
}

winsep.setup(opts)
