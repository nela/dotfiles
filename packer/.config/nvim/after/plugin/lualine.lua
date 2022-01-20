local gruv = {
	outerbg = '#282828', --instead of color3
	fg2    = '#282828',
	midgray = '#504945',
	fg1    = '#ddc7a1',
	innerbg = nil,
	-- color3 = '#32302f',
	gray = '#a89984',
	-- fg3       = '#bcc0b6',
	blue = '#7daea3',
	green = '#a9b665',
	orange = '#d8a657',
	purple = '#d3869b',
	red = '#ea6962',
  -- fg4       = '#bbc27f',
  -- violet   = '#c091b1', -- I like this color
}
--[[ local colors1 = {
						darkgray = "#16161d",
						gray = "#727169",
						innerbg = nil,
						outerbg = "#16161D",
						normal = "#7e9cd8",
						insert = "#98bb6c",
						visual = "#ffa066",
						replace = "#e46876",
						command = "#e6c384",
				} ]]

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
                a = { fg = _colors.fg2, bg = _colors.purple, }, -- gui = "bold" },
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

local colors2 = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}
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
}

--[[ local progress_bar = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end ]]


print(conditions.check_git_workspace())

local mode = {
	'mode',
	fmt = function(str) return str:sub(1,1) end,
}

local filesize = {
	'filesize',
	cond = conditions.buffer_not_empty,
	padding = { left = 2, right = 1 },
	color = { fg = gruv.gray }
}

local filename =	{
	'filename',
	cond = conditions.buffer_not_empty,
	padding = 1,
	file_satus = true,
	shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
	symbols = { modified = ' [+]', readonly = ' [-]', unnamed = '[No Name]' },
	color = { fg = gruv.gray }
}

local branch = {
	'branch',
	icon = "",
	padding = 1,
	color = { fg = gruv.gray }
} --icon = '',

local diff = {
	'diff',
	-- { added = ' ', modified = '柳 ', removed = ' ' },
	symbols = { added = " ", modified = " ", removed = " " },
	padding = 1,
	diff_color = {
	  added = { fg = gruv.green },
	  modified = { fg = gruv.purple },
	  removed = { fg = gruv.red },
	},
	cond = conditions.hide_in_width,
}

local lsp = {
	function()
	  local msg = 'no active lsp'
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
	color = { fg = gruv.gray, }, --gui = 'bold'
}

local diagnostic = {
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	symbols = { error = ' ', warn = ' ', info = ' ' },
	diagnostics_color = {
		error = { fg = gruv.red },
		warn = { fg = gruv.orange },
		info = { fg = gruv.blue },
		hint = { fg = gruv.green }
	},
}

--[[ local progress = {
	progress_bar,
} ]]

local location = {
	'location',
	separator = ''
}

local ins_separator = function ()
	if conditions.check_git_workspace() then
		return [[|]]
	end
end

local lsp_progress = {
	'lsp_progress',
	color = { fg = gruv.violet }
}

local config = {
  options = {
    theme = theme(gruv),
		section_separators = '',
		component_separators = '',
    disabled_filetypes = {},
    always_divide_middle = true,
	},

	 sections = {
    -- these are to remove the defaults
    lualine_a = { mode },
    lualine_b = { filesize, filename },
    lualine_c = { branch, diff, },
		lualine_x = { lsp, 'lsp_progress', diagnostic	},
    lualine_y = { location },
		lualine_z = { 'progress' },
    -- These will be filled later
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = { mode },
    lualine_b = { filesize, filename },
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = { 'progress' },
	},
  extensions = {'quickfix', 'fugitive', }
}


require('lualine').setup(config)


