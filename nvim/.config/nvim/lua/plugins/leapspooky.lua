return {
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    config = function(_, opts)

      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set('n',             'gs', '<Plug>(leap-from-window)')

      vim.keymap.set({'x', 'o'},      'x', '<Plug>(leap-forward-till)')
      vim.keymap.set({'x', 'o'},      'X', '<Plug>(leap-backward-till)')

      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
      vim.api.nvim_set_hl(0, 'LeapMatch', {
        fg = 'white',
        bold = true,
        nocombine = true,
      })
      require('leap.user').set_repeat_keys('<enter>', '<backspace>')
    end,
    opts = {
      highlight_unlabeled_phase_one_targets = true,
      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      preview = function(ch0, ch1, ch2)
        return not (
          ch1:match('%s')
          or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
        )
      end
    },
    equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' },
  },
  {
    'ggandor/leap-spooky.nvim',
    event = 'VeryLazy',
    opts = {
      -- Additional text objects, to be merged with the default ones.
      -- E.g.: {'iq', 'aq'}
      extra_text_objects = nil,
      -- Mappings will be generated corresponding to all native text objects,
      -- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.
      -- Special line objects will also be added, by repeating the affixes.
      -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
      -- window.
      affixes = {
        -- The cursor moves to the targeted object, and stays there.
        magnetic = { window = 'm', cross_window = 'M' },
        -- The operation is executed seemingly remotely (the cursor boomerangs
        -- back afterwards).
        remote = { window = 'r', cross_window = 'R' },
      },
      -- Defines text objects like `riw`, `raw`, etc., instead of
      -- targets.vim-style `irw`, `arw`. (Note: prefix is forced if a custom
      -- text object does not start with "a" or "i".)
      prefix = false,
      -- The yanked text will automatically be pasted at the cursor position
      -- if the unnamed register is in use.
      paste_on_remote_yank = false,
    },
    dependencies = {
      url = "https://codeberg.org/andyg/leap.nvim",
    },
    config = function()
      require('leap-spooky').setup({})
    end,
  },
}
