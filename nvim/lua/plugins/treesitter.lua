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
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    -- lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline event = "VeryLazy",
    cmd = { 'TSUpdateSync', 'TSInstall' },
    ft = filetypes,
    opts = {
      ensure_installed = filetypes,
      highlight = { enable = true },
      folds = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter')
      local installed = TS.get_installed('parsers')
      local install = vim.tbl_filter(function(lang)
        if installed[lang] == nil then
          return true
        end
        return false
      end, opts.ensure_installed or {})

      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          TS.update(nil, { summary = true })
        end)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nelavim_treesitter', { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)

          if lang == nil or TS.get_installed('parsers')[lang] == nil then
            return
          end

          if opts.highlight.enable then
            pcall(vim.treesitter.start, ev.buf)
          end

          if opts.fold.enable then
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'
          end

          -- is experimental
          if opts.indent.enable then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    -- event = 'VeryLazy',
    opts = {
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.inner'] = 'V', -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
          include_surrounding_whitespace = true,
        },
        set_jumps = true,
      },
    },
    config = function()
      --swap
      vim.keymap.set('n', '<leader>p', function()
        require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
      end)
      vim.keymap.set('n', '<leader>P', function()
        require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
      end)
      -- move

      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end)
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end)
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end)

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ 'n', 'x', 'o' }, ']i', function()
        require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[i', function()
        require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
      end)
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
    'echasnovski/mini.ai',
    version = '*',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          -- g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
    end,
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

          local builtin = require('fzf-lua.previewer.builtin')
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
            local line, col = entry_str:match('.*:(%d+):(%d+)')
            -- local linecol =
            return {
              path = fname,
              line = tonumber(line),
              col = tonumber(col),
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
