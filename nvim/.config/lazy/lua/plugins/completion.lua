return {
	{
		'hrsh7th/nvim-cmp',
		event = "InsertEnter",
    version = false,
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-omni',
			'hrsh7th/cmp-cmdline',
			'andersevenrud/cmp-tmux',
      'onsails/lspkind.nvim'
		},
    opts = function()
      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()
      local types = require("cmp.types")
      local str = require("cmp.utils.str")

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      return {
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        sources = cmp.config.sources({
          { name = 'nvim_lua' },
          -- { name = 'zsh' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'tmux' },
          -- { name = 'omni' },
          { name = 'buffer', keyword_length = 4 },
          { name = 'vim-dadbod-completion' }
        }),

        formatting = {
          format = require('lspkind').cmp_format({
            -- with_text = true,
            mode = 'symbol_text',
            menu = {
              buffer = '[buf]',
              nvim_lua = '[api]',
              nvim_lsp = '[LSP]',
              luasnip = '[snip]',
              path = '[path]',
              ['vim-dadbod-completion'] = '[db]'
            },
            maxwidth = 80,
            ellipsis_char = '...',
            before = function(entry, vim_item)
              local word = entry:get_insert_text()
              if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                word = vim.lsp.util.parse_snippet(word)
              end
              word = str.oneline(word)
              if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                word = word .. '~'
                vim_item.abbr = word
              end
                return vim_item
            end
          }),
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText'
          }
        },
        sorting = defaults.sorting,
        -- sorting = {
        --   comparators = {
        --     cmp.config.compare.offset,
        --     cmp.config.compare.exact,
        --     cmp.config.compare.score,
        --     function(entry1, entry2)
        --       local _, entry1_under = entry1.completion_item.label:find "^_+"
        --       local _, entry2_under = entry2.completion_item.label:find "^_+"
        --       entry1_under = entry1_under or 0
        --       entry2_under = entry2_under or 0
        --       if entry1_under > entry2_under then
        --         return false
        --       elseif entry1_under < entry2_under then
        --         return true
        --       end
        --     end,
        --     cmp.config.compare.kind,
        --     cmp.config.compare.sort_text,
        --     cmp.config.compare.length,
        --     cmp.config.compare.order,
        --     }
        -- },
        window = {
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          },
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
          }),
          ["<C-p>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert
          }),
          ["<C-n>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert
          }),
          ['<C-y>'] = cmp.mapping.confirm({
            select = true,
          }),
          ['<C-q>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<C-space>'] = cmp.mapping.complete(),
          -- ["<Tab>"] = cmp.config.disable,
        },
    }
  end
	},
}
