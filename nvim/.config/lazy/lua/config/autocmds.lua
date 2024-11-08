
local augroup = function(name)
  vim.api.nvim_create_augroup('nelavim_' .. name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function ()
      vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
  end
})

-- Resize window splits when vim is resized
autocmd("VimResized", {
  group = augroup("split_resize"),
  pattern = "*",
  command = "wincmd =",
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = augroup("relativenumber_toggle"),
  callback = function() vim.opt.relativenumber = true end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = augroup("relativenumber_toggle"),
  callback = function() vim.opt.relativenumber = false end
})

-- update buffer contents if changed outside of vim
autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
    group = augroup("buffer_update"),
    command = "checktime",
})

autocmd("BufWritePre", {
    group = augroup("buffer_update"),
    command = "%s/\\s\\+$//e",
})

-- remove trailing whitespace and empty lines on save
autocmd("BufWritePre", {
  group = augroup("buffer_update"),
  pattern = "*",
  callback = function ()
    -- local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.cmd("%s/\\s\\+$//e") -- whitespaces
    --[[ vim.cmd("undojoin")
    vim.cmd("keepjumps exe '%s/\\($\\n\\s*\\)*\\%$//e'") --empty lines
    vim.cmd("undojoin")
    local eof = vim.api.nvim_buf_line_count(0)
    if eof < row then
      row = eof
      col = 0
    end
    vim.api.nvim_win_set_cursor(0, { row, col }) ]]
  end,
})

-- ensure tabs don't get converted to spaces in Makefiles
autocmd("FileType", {
  group = augroup("makefile_noexpandtab"),
  pattern = "make",
  -- command = "setlocal noexpandtab"
  callback = function() vim.opt.expandtab = false end
})

autocmd("WinEnter", {
  group = augroup("cursor_toggle"),
  pattern = "*",
  command = "setlocal cursorline"
})
autocmd("WinLeave", {
  group = augroup("cursor_toggle"),
  pattern = "*",
  command = "setlocal nocursorline"
})
