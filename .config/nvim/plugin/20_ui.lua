local now, now_if_args = Config.now, Config.now_if_args
local gh = Config.gh

require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'dialog',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})

-- Lualine {{{
now(function()
  vim.pack.add({ gh('nvim-lualine/lualine.nvim') })
  local lualine_config = function()
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
            'aerial',
            sep = '  ',
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
  end
  require('lualine').setup(lualine_config())
end)
--}}}

--  NvimTree {{{
now(function()
  vim.pack.add({
    gh('nvim-tree/nvim-web-devicons'),
    gh('nvim-tree/nvim-tree.lua'),
  })

  require('nvim-tree').setup({
    disable_netrw = true,
    hijack_netrw = true,
    renderer = {
      indent_markers = { enable = true },
      icons = { show = { folder_arrow = false } },
    },
    -- filters = { custom = { '.^git$' } },
    git = { ignore = false },
    view = {
      width = function()
        return math.floor((vim.go.columns / 9) * 2)
      end,
      number = false,
    },
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    on_attach = function(bufnr)
      local api = require('nvim-tree.api')
      local function opts(desc)
        return {
          desc = 'nvim-tree: ' .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.del('n', '<tab>', { buffer = bufnr })
      vim.keymap.set('n', '<M-p>', api.node.open.preview, opts('Open Preview'))
      -- vim.keymap.set('n', '<leader>nt', api.tree.toggle, opts('Toggle'))
    end,
  })
  vim.keymap.set('n', '<leader>nt', '<cmd>NvimTreeToggle<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>rf', '<cmd>NvimTreeRefresh<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>nf', '<cmd>NvimTreeFindFile<cr>', { noremap = true })
end)
--  }}}

-- Indent Blankline {{{
now_if_args(function()
  vim.pack.add({ gh('lukas-reineke/indent-blankline.nvim') })
  require('ibl').setup({
    indent = {
      char = '│',
      tab_char = '│',
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        'help',
        'alpha',
        'dashboard',
        'NvimTree',
      },
    },
  })
end)
--- }}}

---  Mini.IndentScope {{{
now_if_args(function()
  vim.pack.add({
    gh('echasnovski/mini.indentscope'),
  })

  require('mini.indentscope').setup({
    symbol = '│',
    options = { try_as_border = true },
  })
end)
---  }}}

--- Tiny inline diagnostic {{{
now_if_args(function()
  vim.pack.add({
    gh('rachartier/tiny-inline-diagnostic.nvim'),
  })

  require('tiny-inline-diagnostic').setup({
    preset = 'classic',
    transparent_bg = true,
    transparent_cursorline = true,
    options = {
      show_source = {
        enabled = true,
      },
      multilines = {
        enabled = true,
        always_show = true,
        trim_whitespaces = true,
        tabstop = 4,
      },
    },
  })
end)
-- }}}

do
  if package.loaded['lualine'] then
    vim.print('lualien loaded')
  else
    vim.print('nolualine')
  end
end

-- Treesitter Context {{{
now_if_args(function()
  vim.pack.add({
    gh('nvim-treesitter/nvim-treesitter-context'),
  })

  require('treesitter-context').setup({
    enable = true,
    on_attach = function(bufnr)
      --[[ local config = vim.fn['gruvbox_material#get_configuration']()
      local palette = vim.fn['gruvbox_material#get_palette'](config.background, config.foreground, config.colors_override)
      vim.cmd.highlight('TreesitterContext guibg=' .. palette.bg0[1])
      vim.cmd.highlight('TreesitterContextBottom  guibg=' .. palette.bg0[1])
      vim.cmd.highlight('TreesitterContextLineNumberBottom  guibg=' .. palette.bg_dim[1] .. ' guifg=', palette.orange[1]) ]]
      vim.keymap.set('n', '<leader>cc', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, buffer = bufnr })
      return true
    end,
  })
end)
-- }}}

--  vim: foldmethod=marker
