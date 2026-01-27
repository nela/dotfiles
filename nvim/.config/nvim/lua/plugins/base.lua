return {
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    -- stylua: ignore
    init = function() vim.g.startuptime_tries = 100 end,
  },
  { 'nvim-lua/plenary.nvim', branch = 'master' }, --branch master for latest codecompanion
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-abolish', event = 'VeryLazy' },
  {
    'tpope/vim-unimpaired',
    event = 'VeryLazy',
    keys = {
      --[[ { "]g", "<Plug>(unimpaired-move-down)", { "n", "x" } },
      { "[g", "<Plug>(unimpaired-move-up)", { "n", "x" } }, ]]
      { ']a', '<Plug>(unimpaired-bnext)', { 'n', 'x' } },
      { '[a', '<Plug>(unimpaired-bprevious)', { 'n', 'x' } },
    },
  },
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'zegervdv/nrpattern.nvim' }, -- TODO LazyLoad
  { 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
  { 'windwp/nvim-autopairs', opts = { map = '<M-w>' }, event = 'InsertEnter' },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function(_) end,
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', mode = 'n', desc = 'Comment toggle current line' },
      { 'gc', mode = { 'n', 'o' }, desc = 'Comment toggle linewise' },
      { 'gc', mode = 'x', desc = 'Comment toggle linewise (visual)' },
      { 'gbc', mode = 'n', desc = 'Comment toggle current block' },
      { 'gb', mode = { 'n', 'o' }, desc = 'Comment toggle blockwise' },
      { 'gb', mode = 'x', desc = 'Comment toggle blockwise (visual)' },
    },
    event = 'BufReadPost',
    -- stylua: ignore
    config = function(opts, _) require("Comment").setup(opts) end,
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
    'AndrewRadev/bufferize.vim',
    config = function()
      vim.g.bufferize_command = 'enew'
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'bufferize',
        command = 'setlocal wrap',
      })
    end,
  },
  {
    'stevearc/overseer.nvim',
    opts = {},
  }
}
