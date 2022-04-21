local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

augroup("relativenumber_toggle", {})
aucmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    group = "relativenumber_toggle",
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
    group = "split_resize", pattern = "*", command = "wincmd ="
})

augroup("buffer_update", {})

-- update buffer contents if changed outside of vim
aucmd({ "FocusGained", "BufEnter" }, {
    group = "buffer_update",
    pattern = "*",
    command = ":checktime"
})

aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    callback = function ()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_buf_set_mark(0, "B", cursor[1], cursor[2], {})
    end
})

-- remove trailing whitespace on save
aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    command = "%s/\\s\\+$//e"
})

-- remove trailing blanklines on save
aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    command = "%s#\\($\\n\\s*\\)*\\%$##"
})

aucmd("BufWritePre", {
    group = "buffer_update",
    pattern = "*",
    callback = function ()
      local cursor = vim.api.nvim_get_mark("B", {})
      if cursor[1] < vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
      end
      vim.api.nvim_del_mark("B")
    end
})

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


--[[ vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufLeave", "FocusLost", "FocusGained",
    "InsertEnter", "InsertLeave"}, {
    group = "RelativeNumberToggle",
    -- pattern = "TelescopePrompt",
    -- command = "let b:RelativeNumberToggle=0"
    callback = function (params)
        if vim.api.nvim_buf_get_option(params.buf, "filetype") == "TelescopePrompt" then
            vim.b.RelativeNumberToggle = 0
        end
    end
}) ]]

--[[ vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "FocusLost", "FocusGained",
    "InsertEnter", "InsertLeave"}, {
    group = "RelativeNumberToggle",
    pattern = "*",
    callback = function (params)
        if vim.api.nvim_buf_get_option(params.buf, "filetype") ~= "TelescopePrompt" then
                print("changing")
                vim.opt.relativenumber = not vim.opt.relativenumber:get()
        else
                print("Telescope")
        end

            -- print(vim.opt.relativenumber)
        -- for _, v in pairs({"TelescopePrompt"}) do
        --     if v ==  vim.api.nvim_buf_get_option(params.buf, 'filetype') then
        --         return
        --     end
        -- end
        -- if vim.api.nvim_buf_get_option(params.buf, 'filetype') ~= "TelescopePrompt" then
        --     vim.opt.relativenumber = not vim.opt.relativenumber:get()
        -- end

        print(vim.opt.relativenumber:get())
    end
}) ]]
