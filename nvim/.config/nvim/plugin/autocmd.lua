local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

augroup("relativenumber_toggle", {})
aucmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    group = "relativenumber_toggle",
    -- TODO find some patterns!
    pattern = "*",
    command = "set relativenumber"
    -- callback = function() vim.opt.relativenumber = true end,
})

aucmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    group = "relativenumber_toggle",
    pattern = "*",
    command = "set norelativenumber"
    -- callback = function() vim.opt.relativenumber = false end
})

-- Resize window splits when vim is resized
augroup("split_resize", {})
aucmd("VimResized", {
    group = "split_resize", pattern = "*", command = "wincmd =",
    -- describe = "Resize window splits when vim is resized"
})

augroup("buffer_update", {})

-- update buffer contents if changed outside of vim
aucmd({ "FocusGained", "BufEnter" }, {
    group = "buffer_update",
    pattern = "*",
    command = ":checktime",
    -- describe = "Update buffer contents if changed outside of vim"
})

--[[ aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    callback = function ()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_buf_set_mark(0, "C", cursor[1], cursor[2], {})
    end,
    -- describe = "Save cursor position in order to retrieve it afterwards"
}) ]]

-- remove trailing whitespace on save
aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    command = "%s/\\s\\+$//e",
    -- describe = "Remove trailing whitespaces on save"
})

--[[ aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    callback = function()
        -- vim.cmd.keepjumps({ args = { "%s/\\($\\n\\s*\\)*\\%$//e" } })
        vim.cmd("keepjumps %s/\\($\\n\\s*\\)*\\%$//e")
        vim.cmd.undojoin()
    end,
    -- describe = "Remove trailing blank lines on save"
}) ]]

--[[ aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    callback = function ()
      local cursor = vim.api.nvim_get_mark("C", {})
      if cursor ~= nil and cursor[1] < vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
        vim.api.nvim_del_mark("C")
      end
    end
}) ]]


-- ensure tabs don't get converted to spaces in Makefiles
augroup("makefile_tab", {})
aucmd("FileType", { group = "makefile_tab", pattern = "make", command = "setlocal noexpandtab"})

augroup("cursor_toggle", {})
aucmd("WinEnter", { group = "cursor_toggle", pattern = "*", command = "setlocal cursorline"})
aucmd("WinLeave", { group = "cursor_toggle", pattern = "*", command = "setlocal nocursorline"})

augroup("highlight_yank", {})
aucmd("TextYankPost", {
    group = "highlight_yank",
    pattern = "*",
    callback = function ()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
    end
})

-- or filetype config?
augroup("nvimtree", {})
aucmd("BufNew", {
    group = "nvimtree",
    pattern = "NvimTree",
    command = "set signcolumn=no"
})
