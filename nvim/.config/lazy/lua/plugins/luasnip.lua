return {
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    event = 'InsertEnter',
    opts = function()
      local types = require('luasnip.util.types')
      return {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = {
                { ' <- Current Choice', 'NonTest' }
              }
            }
          }
        }
      }
    end,
    keys = {
      {
        '<c-k>',
        function()
          if require('luasnip').expand_or_jumpable() then
            require('luasnip').expand_or_jump()
          end
        end,
        expr = true, silent = true, mode = {'i', 's' }
      },
      {
        '<c-j>',
        --if .expand_or_jumpable() then
        function() require('luasnip').jump(-1) end,
        expr = true, silent = true, mode = {'i', 's' }
      },
      {
        '<c-l>',
        function()
          if require('luasnip').choice_active() then
            require('luasnip').change_choice(1)
          end
        end,
        expr = true, silent = true, mode = {'i', 's' }
      }
    }
  }
}
