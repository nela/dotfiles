return {
  { 'tpope/vim-fugitive', cmd = { 'G', 'Gw' } },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
      end
    }
  },
  {
    'sindrets/diffview.nvim', cmd = { 'DiffviewOpen' },
    opts = {
      file_panel = {
        win_config = function ()
          local width = math.floor((vim.go.columns/9)*2)
          return {
            position = 'left',
            width = width
          }
        end
      },
      keymaps = {
        view = {
          { "<tab>", "<s-tab>", false },
          -- ["<tab>"] = false,
          -- ["<s-tab>"] = false,
          { "n", "]m", function() require('diffview.actions').select_next_entry() end, { desc = "Open the diff for the next file" } },
          { "n", "[m", function() require('diffview.actions').select_prev_entry() end, { desc = "Open the diff for the previous file" } }
        },
        file_panel = {
          { "<tab>", "<s-tab>", false },
          { "n", "]m", function() require('diffview.actions').select_next_entry() end, { desc = "Open the diff for the next file" } },
          { "n", "[m", function() require('diffview.actions').select_prev_entry() end, { desc = "Open the diff for the previous file" } }
        }
      }
    }
  }
}
