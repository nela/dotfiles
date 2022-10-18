vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.opt.shortmess:append 'c'

local lspkind = require 'lspkind'
lspkind.init()

local cmp = require 'cmp'

cmp.setup {
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close()
    },
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ['<C-q>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-space>'] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.config.disable,
  },
  sources = {
    { name = 'nvim_lua' },
    -- { name = 'zsh' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'tmux' },
    { name = 'omni' },
    { name = 'buffer', keyword_length = 5 },
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own. <-- Shameless copy from TJ, really this whole config
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    }
  },
  -- snippet plugin here
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  formatting = {
    format = lspkind.cmp_format {
      -- with_text = true,
      -- mode = 'sy'
      -- menu = {
      --   buffer = '[buf]',
      --   nvim_lsp = '[LSP]',
      --   nvim_lua = '[api]',
      --   path = '[path]',
      --   luasnip = '[snip]',
      --   -- gh_issues = '[issues]',
      -- },
    },
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
}
