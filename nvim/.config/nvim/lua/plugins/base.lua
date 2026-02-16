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
      { ']a', '<Plug>(unimpaired-bnext)', { 'n', 'x' } },
      { '[a', '<Plug>(unimpaired-bprevious)', { 'n', 'x' } },
      { ']m', '<Plug>(unimpaired-directory-next)', { 'n', 'x' } },
      { '[m', '<Plug>(unimpaired-directory-previous)', { 'n', 'x' } },
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
  },
}
