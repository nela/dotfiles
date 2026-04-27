local now, now_if_args, gh, cb = Config.now, Config.now_if_args, Config.gh, Config.cb

--  Treesitter TextObjects {{{
now_if_args(function()
  vim.pack.add({
    gh('nvim-treesitter/nvim-treesitter-textobjects'),
  })

  vim.keymap.set('n', '<leader>p', function()
    require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
  end)
  vim.keymap.set('n', '<leader>P', function()
    require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
  end)

  vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
    require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
    require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
    require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
    require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
  end)
  -- You can also pass a list to group multiple queries.
  vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
    require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '[o', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
  end)
  -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
  vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, '[s', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start('@local.scope', 'locals')
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
  end)
end)
-- }}}

-- FZf {{{
now(function()
  vim.pack.add({
    gh('ibhagwan/fzf-lua'),
  })

  local fzf = require('fzf-lua')
  fzf.setup({
    --[[ winopts = {
          preview = {
            layout = 'horizontal',
          },
        }, ]]
    fzf_opts = {
      ['--cycle'] = '',
    },
    defaults = {
      -- formatter = { 'path.filename_first', 2 },
      -- path_shorten = true,
    },
    keymap = {
      builtin = {
        ['<C-d>'] = 'preview-page-down',
        ['<C-u>'] = 'preview-page-up',
        ['<C-r>'] = 'preview-page-reset',
      },
      fzf = {
        -- ["ctrl-q"] = "select-all+accept"
        ['ctrl-q'] = 'toggle-all',
      },
    },
    grep = {
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob '!{node_modules/,.git/}' -e",
      -- fd_opts = ""
      path_shorten = true,
    },
    previewers = {
      builtin = {
        title_fnamemodify = function(t, width)
          local min_left_padding = 4
          local min_right_padding = 4
          local max_text_width = width - min_left_padding - min_right_padding

          if #t > max_text_width then
            return '...' .. t:sub(#t - max_text_width + 3 + 1, #t)
          end
          return t
        end,
      },
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<leader>fb', function()
    require('fzf-lua').buffers()
  end, { silent = true, desc = 'Fuzzy open buffers' })

  vim.keymap.set({ 'n', 'v' }, '<leader>fh', function()
    require('fzf-lua').help_tags()
  end, { silent = true, desc = 'Fuzzy help tags' })

  vim.keymap.set({ 'n', 'v', 'i' }, '<leader>fr', function()
    require('fzf-lua').registers()
  end, { silent = true, desc = 'Fuzzy complete registers' })

  vim.keymap.set({ 'n', 'v' }, '<leader>zsh', function()
    require('fzf-lua').files({ cwd = os.getenv('DOTS') .. '/zsh' })
  end, { silent = true, desc = 'Fuzzy find zsh dotfiles' })

  vim.keymap.set({ 'n', 'v' }, '<leader>dot', function()
    require('fzf-lua').files({ cwd = os.getenv('DOTS') })
  end, { silent = true, desc = 'Fuzzy find dotfiles' })

  vim.keymap.set({ 'n', 'v' }, '<leader>vim', function()
    require('fzf-lua').files({ cwd = os.getenv('NVIM') })
  end, { silent = true, desc = 'Fuzzy find nvim files' })

  vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
    require('fzf-lua').files()
  end, { silent = true, desc = 'Fuzzy find files' })

  vim.keymap.set({ 'n', 'v' }, '<leader>fa', function()
    require('fzf-lua').files({ fd_opts = '. --type f --unrestricted --follow -E .DS_Store' })
  end, { silent = true, desc = 'Fuzzy find all files' })

  vim.keymap.set({ 'n', 'v' }, '<leader>sg', function()
    require('fzf-lua').grep({ multiprocess = true })
  end, { silent = true, desc = 'Static grep' })

  vim.keymap.set({ 'n', 'v' }, '<leader>lg', function()
    require('fzf-lua').live_grep({ multiprocess = true })
  end, { silent = true, desc = 'Live grep' })

  vim.keymap.set({ 'n', 'v' }, '<leader>hg', function()
    require('fzf-lua').live_grep({
      multiprocess = true,
      cmd = 'rg --hidden --no-ignore --column --line-number --color=always --smart-case --max-columns=4096',
    })
  end, { silent = true, desc = 'Live grep hidden files' })
end)
-- }}}

-- Leap {{{

now_if_args(function()
  vim.pack.add({
    cb('andyg/leap.nvim'),
  })

  vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
  vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
  vim.keymap.set('n', 'gs', '<Plug>(leap-from-window)')

  vim.keymap.set({ 'x', 'o' }, 'x', '<Plug>(leap-forward-till)')
  vim.keymap.set({ 'x', 'o' }, 'X', '<Plug>(leap-backward-till)')

  vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'LeapMatch', {
    fg = 'white',
    bold = true,
    nocombine = true,
  })
  require('leap.user').set_repeat_keys('<enter>', '<backspace>')

  require('leap').opts.preview = function(ch0, ch1, ch2)
    return not (ch1:match('%s') or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a')))
  end

  do
    local clever = require('leap.user').with_traversal_keys
    vim.keymap.set({ 'n', 'x', 'o' }, '<cr>', function()
      require('leap').leap({
        ['repeat'] = true,
        opts = clever('<cr>', '<bs>'),
      })
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '<cr>', function()
      require('leap').leap({
        ['repeat'] = true,
        opts = clever('<cr>', '<bs>'),
        backward = true,
      })
    end)
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'RemoteOperationDone',
    group = vim.api.nvim_create_augroup('nelavim:leap_remote', {}),
    callback = function(event)
      if vim.v.operator == 'y' and event.data.register == '"' then
        vim.cmd('normal! p')
      end
    end,
  })
end)
-- }}}
