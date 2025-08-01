local filetypes = {
  'bash',
  'c',
  'comment',
  'html',
  'javascript',
  'typescript',
  'tsx',
  'svelte',
  -- "java",
  'json',
  -- "kotlin",
  -- "latex",
  'lua',
  'python',
  'regex',
  'glsl',
  -- "rst",
  'rust',
  'supercollider',
  'svelte',
  'yaml',
  'css',
  'scss',
  'qmljs',
  'ron',
  'rust',
  'toml',
  'sql',
  'terraform',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline event = "VeryLazy",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    cmd = { 'TSUpdateSync', 'TSInstall' },
    ft = filetypes,
    opts = {
      ensure_installed = filetypes,
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      indent = { enable = true },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<Cr>',
          show_help = '?',
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<Cr>',
          scope_incremental = '<Cr>',
          node_incremental = '<Tab>',
          node_decremental = '<S-Tab>',
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
      rainbow = {
        enable = true,
        extended_mode = true, -- highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 10000, -- Do not enable for files with more than n lines, int
      },
      autotag = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = false, -- provided by mini.ai
          lookahead = true, -- jump forward to textobj, similar to targets.vim
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
          include_surrounding_whitespace = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>p'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>P'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']a'] = '@parameter.inner',
            [']f'] = '@function.outer',
            -- ["]]"] = "@class.outer",
            [']z'] = '@fold',
            [']i'] = '@conditional.outer',
          },
          goto_next_end = {
            [']A'] = '@parameter.inner',
            [']F'] = '@function.outer',
            -- ["]["] = "@class.outer",
            [']I'] = '@conditional.outer',
          },
          goto_previous_start = {
            ['[a'] = '@parameter.inner',
            ['[f'] = '@function.outer',
            -- ["[["] = "@class.outer",
            ['[i'] = '@conditional.outer',
          },
          goto_previous_end = {
            ['[A'] = '@parameter.inner',
            ['[F'] = '@function.outer',
            -- ["[]"] = "@class.outer",
            ['[I'] = '@conditional.outer',
          },
          -- next closest, either start or end
          --[[ goto_next = {
            [']l'] = '@loop.*',
          },
          goto_previous = {
            ['[l'] = '@loop.*',
          }, ]]
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    config = function()
      local util = require('util')
      if util.is_loaded('nvim-treesitter') then
        local opts = util.get_opts('nvim-treesitter')
        require('nvim-treesitter.configs').setup({ textobjects = opts.textobjects })
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      -- separator = '-',
      on_attach = function(bufnr)
        local config = vim.fn['gruvbox_material#get_configuration']()
        local palette =
          vim.fn['gruvbox_material#get_palette'](config.background, config.foreground, config.colors_override)
        vim.cmd.highlight('TreesitterContext guibg=' .. palette.bg0[1])
        vim.cmd.highlight('TreesitterContextBottom  guibg=' .. palette.bg0[1])
        vim.cmd.highlight(
          'TreesitterContextLineNumberBottom  guibg=' .. palette.bg_dim[1] .. ' guifg=',
          palette.orange[1]
        )
        vim.keymap.set('n', '<leader>cc', function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end, { silent = true, buffer = bufnr })
        return true
      end,
    },
  },
  {
    'stevearc/aerial.nvim',
    event = { 'VeryLazy' },
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },

    keys = {
      {
        '<leader>af',
        function()
          local data = require('aerial.data')
          local backends = require('aerial.backends')
          local fzf_lua = require('fzf-lua')
          local lspkind = require('lspkind')

          local bufnr = vim.api.nvim_get_current_buf()
          local be = backends.get()
          if not be then
            vim.notify('no supported')
            return
          elseif not data.has_symbols(bufnr) then
            be.fetch_symbols_sync(bufnr, {})
          end

          if not data.has_symbols(bufnr) then
            vim.notify('no symbols')
            return
          end
          local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.')

          local symbols = data.get_or_create(bufnr)
          local entries = {}
          for _, sym in symbols:iter({ skip_hidden = false }) do
            local symbolkind = lspkind.symbolic(sym.kind) or sym.kind
            table.insert(entries, {
              line = string.format('%s %s %s:%d:%d', symbolkind, sym.name, fname, sym.lnum, math.max(sym.lnum - 20, 1)),
              lnum = sym.lnum,
              col = sym.col,
            })
          end

          local contents = {}
          for _, ent in ipairs(entries) do
            table.insert(contents, ent.line)
          end

local builtin = require("fzf-lua.previewer.builtin")
local MyPreviewer = builtin.buffer_or_file:extend()

function MyPreviewer:new(o, opts, fzf_win)
  MyPreviewer.super.new(self, o, opts, fzf_win)
  setmetatable(self, MyPreviewer)
  return self
end

---@param entry_str string
function MyPreviewer:parse_entry(entry_str)
  -- Assume an arbitrary entry in the format of 'file:line'

  -- local _, line = entry_str:match("([^:]+):?(.*)")
local line, col = entry_str:match(".*:(%d+):(%d+)")
  -- local linecol =
  return {
    path = fname,
    line =  tonumber(line),
    col = tonumber(col)
  }
end

          if next(contents) == nil then
            vim.notify('no symbols')
            return
          end

          fzf_lua.fzf_exec(contents, {
            prompt = 'Symbols> ',
            fzf_opts = {
              ['--delimiter'] = ' ',
              ['--with-nth'] = '1,2',
            },
            -- preview = 'bat {3} --style=plain,numbers --color=always --highlight-line={4} --line-range={5}:256',
            previewer = MyPreviewer,

            actions = {
              ['enter'] = function(selected, _)
                local sel = selected[1]
                for _, entry in ipairs(entries) do
                  if entry.line == sel then
                    vim.cmd("normal! m'")
                    vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
                    vim.cmd('normal! zz')
                    return
                  end
                end
              end,
            },
          })
        end,
        'n',
      },
    },
    opts = {
      nav = {
        win_opts = {
          winblend = 0,
        },
      },
      icons = {
        Collapsed = '❯', -- '▶'
      },
    },
  },
}
