--stylua: ignore
local gruvbox_regular = {
  outerbg = '#282828', --instead of color3
  fg2     = '#282828',
  fg1     = '#ddc7a1',
  innerbg = nil,
  black   = '#282828',
  red     = '#cc241d',
  green   = '#98971a',
  yellow  = '#d79921',
  blue    = '#458588',
  magenta = '#b16286',
  cyan    = '#689d6a',
  gray    = '#a89984',
  orange  = '#d65d0e',
}

--stylua: ignore
local gruv_dim = {
  outerbg = '#282828', --instead of color3
  fg2     = '#282828',
  fg1     = '#ddc7a1',
  innerbg = nil,
  black   = '#282828',
  red     = '#9d0006',
  green   = '#b57614',
  yellow  = '#b57614',
  blue    = '#076678',
  magenta = '#8f3f71',
  cyan    = '#427b58',
  orange  = '#af3a03',
  white   = '#bdae93',
}

local theme = function(_colors)
  return {
    inactive = {
      a = { fg = _colors.fg1, bg = _colors.outerbg }, --gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    visual = {
      a = { fg = _colors.fg2, bg = _colors.orange }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    replace = {
      a = { fg = _colors.fg2, bg = _colors.magenta }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    normal = {
      a = { fg = _colors.fg2, bg = _colors.gray }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    insert = {
      a = { fg = _colors.fg2, bg = _colors.blue }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
    command = {
      a = { fg = _colors.fg2, bg = _colors.green }, -- gui = "bold" },
      b = { fg = _colors.fg1, bg = _colors.outerbg },
      c = { fg = _colors.fg1, bg = _colors.innerbg },
    },
  }
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  lsp_exists = function()
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return false
    end
    return true
  end,
}

local filesize = {
  'filesize',
  cond = conditions.buffer_not_empty,
  padding = { left = 2, right = 1 },
  color = { fg = gruvbox_regular.gray },
}

local filename = {
  'filename',
  cond = conditions.buffer_not_empty,
  padding = 1,
  file_satus = true,
  shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  symbols = { modified = ' [+]', readonly = ' [-]', unnamed = '[No Name]', new = '[New]' },
  color = { fg = gruvbox_regular.gray },
}

local lsp = {
  'lsp_status',
  icon = '', -- f013
  symbols = {
    -- spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
    spinner = {},
    done = '✓',
    separator = ' ',
  },
  -- List of LSP names to ignore (e.g., `null-ls`):
  color = { fg = gruvbox_regular.gray }, --gui = 'bold'
  ignore_lsp = {},
}

local diagnostic = {
  'diagnostics',
  symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
  padding = 1,
  diagnostics_color = {
    error = { fg = gruv_dim.red },
    warn = { fg = gruv_dim.orange },
    info = { fg = gruv_dim.blue },
    hint = { fg = gruv_dim.green },
  },
}

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = function()
      return {
        options = {
          theme = theme(gruvbox_regular),
          section_separators = '',
          component_separators = '',
          disabled_filetypes = { 'NvimTree' },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          -- these are to remove the defaults
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                return str:sub(1, 1)
              end,
            },
          },
          lualine_b = { filesize, filename },
          lualine_c = { lsp, diagnostic },
          lualine_x = {
            {
              'aerial', sep = '  '
            },
            {
              'diff',
              -- symbols    = { added = " ", modified = "" "", removed = " " },
              symbols = { added = ' ', modified = ' ', removed = ' ' },
              padding = 1,
              diff_color = {
                added = { fg = gruv_dim.green },
                modified = { fg = gruv_dim.magenta },
                removed = { fg = gruv_dim.red },
              },
              source = function()
                local status = vim.b.gitsigns_status_dict
                if status then
                  return {
                    added = status.added,
                    modified = status.changed,
                    removed = status.removed,
                  }
                end
              end,
            },
            { 'b:gitsigns_head', icon = '', padding = 1, color = { fg = gruvbox_regular.gray } },
          },
          lualine_y = { { 'location', separator = '', padding = 1 } },
          lualine_z = { { 'progress', padding = 1 } },
        },
        extensions = { 'quickfix', 'fugitive', 'fzf', 'lazy', 'aerial' },
      }
    end,
  }
}
