-- "0 by default, this option shows indent markers when folders are open
vim.g.nvim_tree_indent_markers = 1

--List of filenames that gets highlighted with NvimTreeSpecialFile
vim.g.nvim_tree_special_files = { 'README.md', 'Makefile', 'MAKEFILE', 'Dockerfile' }
-- 0 by default, append a trailing slash to folder names
vim.g.nvim_tree_add_trailing = 1

vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {
      unstaged = '✗',
      staged = '✓',
      unmerged = '',
      renamed = '➜',
      untracked = '★',
      deleted = '',
      ignored = '◌'
      },
    folder = {
      default = '',
      open = '',
      empty = '',
      empty_open = '',
      symlink = '',
      symlink_open = '',
      },
    lsp = {
      hint = '',
      info = '',
      warning = '',
      error = ''
    }
}

require('nvim-tree').setup {
    nvim_tree_disable_netrw = true,
    disable_netrw = true,
    hijack_netrw = true,

    view = {
      width = 40
    }
}

vim.api.nvim_set_keymap('n', '<leader>nt', ':NvimTreeToggle <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rf', ':NvimTreeRefresh <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>nf', ':NvimTreeFindFile <CR>', { noremap = true })

-- vim.cmd([[
--   highlight NvimTreeFolderIcon guibg=white
-- ]])
