local ls = require "luasnip"
-- local t = ls.text_node
local types = require "luasnip.util.types"

-- local snips = require("luasnip_snippets").load_snippets()

-- for k, v in pairs(snips) do ls.add_snippets(k, v) end

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
}

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  print(vim.inspect(ls.expand_or_jumpable()))
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({"i", "s"}, "<C-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({"i", "s"}, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })




local snippet = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep


local lua_snippets = {
  snippet("lf", fmt(
      [[
        local {} = function({})
          {}
        end
      ]],
      {
        i(1), i(2, "params"), i(0)
      }
    )
  ),
  snippet("req", fmt('local {} = require("{}")',
      {
        i(1), rep(1)
      }
    )
  )
}

ls.add_snippets("lua", lua_snippets)

--
--
-- ls.add_snippets("all", {
--
--   snippet("trig", {
--      i(1),
--      f(function(args, snip, user_arg_1) return args[1][1] .. user_arg_1 end,
--          {1},
--          { user_args = {"Will be appended to text from i(0)"}}),
--      i(0)
--   }),
--   snippet("expand", { t "what" }),
--
--         snippet("ternary", {
--             -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
--             i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
--         })
-- })
--
--
-- ls.add_snippets("lua", {
--
--   snippet("lf", {
--     t "local ",
--     i(1),
--     t " = function(",
--     i(2),
--     t { ")" , "" },
--     i(0),
--     t { "\t", "" },
--     t "end"
--   }),
--
-- })
