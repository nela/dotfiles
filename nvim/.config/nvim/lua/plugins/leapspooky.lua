return {
  {
    'ggandor/leap.nvim',
    keys = {
      {
        's',
        mode = {
          'n', --[[ "x", "o" ]]
        },
        desc = 'Leap forward to',
      },
      {
        'S',
        mode = {
          'n', --[[ "x", "o" ]]
        },
        desc = 'Leap backward to',
      },
      {
        'gs',
        mode = {
          'n', --[[ "x", "o" ]]
        },
        desc = 'Leap from windows',
      },
    },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
      vim.api.nvim_set_hl(0, 'LeapMatch', {
        fg = 'white',
        bold = true,
        nocombine = true,
      })
    end,
    opts = {
      highlight_unlabeled_phase_one_targets = true,
    },
  },
  {
    'ggandor/leap-spooky.nvim',
    event = 'VeryLazy',
    opts = {
      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      preview_filter = function(ch0, ch1, ch2)
        return not (ch1:match('%s') or ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
      end,
      equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
    },
    dependencies = { 'ggandor/leap.nvim' },
    config = function()
      require('leap-spooky').setup({})
    end,
  },
}
