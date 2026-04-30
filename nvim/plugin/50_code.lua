local now, now_if_args, on_packchanged, gh = Config.now, Config.now_if_args, Config.on_packchanged, Config.gh

now_if_args(function()
  vim.pack.add({
    gh('neovim/nvim-lspconfig'),
    gh('tpope/vim-sleuth'),
    gh('windwp/nvim-autopairs'),
    gh('numToStr/Comment.nvim'),
  })

  require('Comment').setup()
  require('nvim-autopairs').setup()
end)

now_if_args(function()
  vim.pack.add({
    gh('stevearc/conform.nvim'),
  })

  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      c = { 'clang_format' },
      cpp = { 'clang_format' },
    },
    formatters = {
      clang_format = {
        prepend_args = { '--style=file', '--fallback-style=mozilla' },
      },
    },
  })
end)

now(function()
  vim.pack.add({
    gh('tpope/vim-fugitive'),
  })
end)

-- FIXME on_event
now_if_args(function()
  vim.pack.add({
    gh('lewis6991/gitsigns.nvim'),
  })

  require('gitsigns').setup({
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })
    end,
  })
end)

now(function()
  vim.pack.add({
    gh('nvim-lua/plenary.nvim'),
    gh('pwntester/octo.nvim'),
  })

  require('octo').setup({
    picker = 'fzf-lua',
  })
end)

now(function()
  vim.pack.add({
    gh('rafamadriz/friendly-snippets'),
    gh('saghen/blink.lib'),
    gh('saghen/blink.cmp'),
  })

  require('blink.cmp').setup({
    keymap = {
      preset = 'default',
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<C-j>'] = { 'snippet_forward', 'fallback' },
      ['<C-k>'] = { 'snippet_backward', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up' },
      ['<C-d>'] = { 'scroll_documentation_down' },
      ['<C-l>'] = { 'scroll_signature_down' },
      ['<C-h>'] = { 'scroll_signature_up' },
      ['<C-;>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- ['<C-;>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    fuzzy = {
      implementation = 'prefer_rust_with_warning',
    },

    signature = {
      enabled = true,
    },
    completion = {
      menu = {
        border = 'none',
      },
    },
  })
end)

on_packchanged('blink.cmp', { 'install', 'update' }, function(ev)
  vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
end, 'Rebuild blink')
