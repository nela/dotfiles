local gruv_normal = {
  outerbg = '#282828', --instead of color3
  fg2    = '#282828',
  fg1    = '#ddc7a1',
  innerbg = nil,
  black =   '#282828',
  red =     '#cc241d',
  green =   '#98971a',
  yellow =  '#d79921',
  blue =    '#458588',
  magenta = '#b16286',
  cyan =    '#689d6a',
  gray =   '#a89984',
  orange = '#d65d0e',
}

local gruv_dim = {
  outerbg = '#282828', --instead of color3
  fg2    = '#282828',
  fg1    = '#ddc7a1',
  innerbg = nil,
  black = '#282828',
  red = '#9d0006',
  green = '#b57614',
  yellow = '#b57614',
  blue = '#076678',
  magenta = '#8f3f71',
  cyan = '#427b58',
  orange = '#af3a03',
  white = '#bdae93',
}

local theme = function(_colors)
  return {
    inactive = {
      a = { fg = _colors.fg1, bg = _colors.outerbg, }, --gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    visual = {
      a = { fg = _colors.fg2, bg = _colors.orange, }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    replace = {
      a = { fg = _colors.fg2, bg = _colors.magenta, }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    normal = {
      a = { fg = _colors.fg2, bg = _colors.gray, }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    insert = {
      a = { fg = _colors.fg2, bg = _colors.blue, }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    command = {
      a = { fg = _colors.fg2, bg = _colors.green, }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
  }
end

-- :h filename-modifiers
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  lsp_exists = function ()
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then return false end
    return true
  end
}

local mode = { 'mode', fmt = function(str) return str:sub(1,1) end, }

local filesize = {
	'filesize',
	cond = conditions.buffer_not_empty,
	padding = { left = 2, right = 1 },
	color = { fg = gruv_normal.gray }
}

local filename =	{
	'filename',
	cond = conditions.buffer_not_empty,
	padding = 1,
	file_satus = true,
	shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
	symbols = { modified = ' [+]', readonly = ' [-]', unnamed = '[No Name]' },
	color = { fg = gruv_normal.gray }
}

local branch = {
	'branch',
	icon = " ", --icon = '',
	padding = 1,
	color = { fg = gruv_normal.gray }
}

local diff = {
	'diff',
	-- { added = ' ', modified = '柳 ', removed = ' ' },
	symbols = { added = " ", modified = " ", removed = " " },
	padding = 1,
	diff_color = {
	  added = { fg = gruv_dim.green },
	  modified = { fg = gruv_dim.magenta },
	  removed = { fg = gruv_dim.red },
	},
	cond = conditions.hide_in_width,
}

local lsp = {
	function()
	  local msg = ''
	  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
	  local clients = vim.lsp.get_active_clients()
	  if next(clients) == nil then
	    return msg
	  end
	  for _, client in ipairs(clients) do
	    local filetypes = client.config.filetypes
	    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
	      return client.name
	    end
	  end
	  return msg
	end,
	icon = ' ',
	color = { fg = gruv_normal.gray, }, --gui = 'bold'
}

local diagnostic = {
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	symbols = { error = ' ', warn = ' ', info = ' ' },
	diagnostics_color = {
		error = { fg = gruv_dim.red },
		warn = { fg = gruv_dim.orange },
		info = { fg = gruv_dim.blue },
		hint = { fg = gruv_dim.green }
	},
}

local location = { 'location', separator = '' }

local navic = require("nvim-navic")
local navic_sec = { navic.get_location, cond = navic.is_available }

local config = {
  options = {
    theme = theme(gruv_normal),
		section_separators = '',
		component_separators = '',
    disabled_filetypes = { 'NvimTree' },
    always_divide_middle = true,
    globalstatus = true
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = { mode },
    lualine_b = { filesize, filename },
    lualine_c = { lsp, diagnostic },
    lualine_x = { navic_sec, branch, diff },
    lualine_y = { location },
    lualine_z = { 'progress' },
    -- These will be filled later
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = { },
    lualine_b = { filesize, filename },
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = { 'progress' },
  },
  extensions = { 'quickfix', 'fugitive', }
}

require('lualine').setup(config)
