local tabpages = vim.api.nvim_list_tabpages()
local win = vim.api.nvim_tabpage_get_win(0)
local currtabpagenr = vim.api.nvim_get_current_tabpage()

local separator = function(index, is_selected)
  return (index < #tabpages and '%#TabLine#|' or '')
end

local title = function(bufnr)
  -- local filename = vim.api.nvim_buf_get_name(bufnr)
  local filename = vim.fn.bufname(bufnr)
  local buftype = vim.fn.getbufvar(bufnr, '&buftype')
  local filetype = vim.fn.getbufvar(bufnr, '&filetype')
  local bufmodified = vim.fn.getbufvar(bufnr, '&mod')

  if filetype == 'TelescopePrompt' then
    return 'telescope'
  elseif filetype == 'fugitive' then
    return 'fugitive'
  elseif filetype == 'git' then
    return 'git'
  elseif filetype == 'packer' then
    return 'packer'
  elseif filename:sub(filename:len()-2, filename:len()) == "FZF" then
    return 'fzf'
  elseif buftype == 'quickfix' then
    return 'quickfix'
  elseif buftype == 'help' then
    return 'help:' .. vim.fn.fnamemodify(filename, ':t:r')
  elseif buftype == 'terminal' then
    return vim.fn.fnamemodify(vim.env.SHELL, ':t')
  elseif filename == "" then
    return "[Something Darkside]"
  else
    return vim.fn.fnamemodify(filename, ':p:t')
  end
end


local tabline = function()
  local result = ''
  print(tabpages)
  vim.pretty_print(tabpages)
  for index, tab in ipairs(tabpages) do

    local winnr = vim.api.nvim_tabpage_get_win(tab)
    local bufnr = vim.api.nvim_win_get_buf(winnr)

    local is_selected = currtabpagenr == index
    print(currtabpagenr)
    print(index)
    print(is_selected)

    -- result = result .. '%#TabLineFill# '
    -- result = result .. (is_selected and '%#TabLineSelSpacing#' or '%#TabLineSpacing#')
    result = result .. (is_selected and "%#TabLineSel#" or "%#TabLine#")
    result = result .. '%' .. index .. 'T ' .. title(bufnr) .. ' ' .. separator(index)
    -- result = result .. (is_selected and '%#TabLineSelSpacing#' or '%#TabLineSpacing#')

    -- result = result .. "%#TabLineSpacing#"

  end
  result = result .. "%T%#TabLineFill#%="
  print(result)
  return result
end

-- vim.opt.tabline = tabline()
