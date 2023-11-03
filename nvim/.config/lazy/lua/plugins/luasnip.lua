return {
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    event = 'InsertEnter',
    opts = {
      history = true,
      delete_check_events = "TextChanged"
    },
    keys = {
      {
        '<C-j>',
        function()
          return require('luasnip').expand_or_jumpable() and require('luasnip').expand_or_jump()
            or "<C-k>"
        end,
        expr = true, silent = false, mode = {'i', 's' }
      },
      {
        '<C-k>',
        function()
          return require('luasnip').jumpable(-1) and require('luasnip').jump(-1)
            or '<C-k>'
        end,
        expr = true, silent = true, mode = {'i', 's' }
      },
      {
        '<C-l>',
        function()
          return require('luasnip').choice_active() and require('luasnip').change_choice(1)
            or '<C-l>'
        end,
        expr = true, silent = true, mode = {'i', 's' }
      }
    }
  }
}
