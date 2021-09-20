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
    hijack_netrw = true
}

vim.api.nvim_set_keymap('n', '<leader>nt', ':NvimTreeToggle <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rf', ':NvimTreeRefresh <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>nf', ':NvimTreeFindFile <CR>', { noremap = true })

vim.cmd([[
  highlight NvimTreeFolderIcon guibg=white
]])

-- vim.g.nvim_tree_bindings = {
--
--   --["<CR>"] = ":YourVimFunction()<cr>",
--   --["u"] = ":lua require'some_module'.some_function()<cr>",
--
--   -- default mappings
--   ["<CR>"]           = tree_cb("edit"),
--   ["o"]              = tree_cb("edit"),
--   ["<2-LeftMouse>"]  = tree_cb("edit"),
--   ["<2-RightMouse>"] = tree_cb("cd"),
--   ["<leader>cd"]     = tree_cb("cd"),
--   ["<C-]>"]          = tree_cb("cd"),
--   ["v"]          = tree_cb("vsplit"),
--   ["h"]          = tree_cb("split"),
--   ["<C-t>"]          = tree_cb("tabnew"),
--   ["<"]              = tree_cb("prev_sibling"),
--   [">"]              = tree_cb("next_sibling"),
--   ["<BS>"]           = tree_cb("close_node"),
--   ["<S-CR>"]         = tree_cb("close_node"),
--   ["<Tab>"]          = tree_cb("preview"),
--   ["I"]              = tree_cb("toggle_ignored"),
--   ["H"]              = tree_cb("toggle_dotfiles"),
--   ["R"]              = tree_cb("refresh"),
--   ["N"]              = tree_cb("create"),
--   ["dd"]              = tree_cb("remove"),
--   ["r"]              = tree_cb("rename"),
--   ["<C-r>"]          = tree_cb("full_rename"),
--   ["x"]              = tree_cb("cut"),
--   ["c"]              = tree_cb("copy"),
--   ["p"]              = tree_cb("paste"),
--   ["[c"]             = tree_cb("prev_git_item"),
--   ["]c"]             = tree_cb("next_git_item"),
--   ["-"]              = tree_cb("dir_up"),
--   ["q"]              = tree_cb("close"),
-- }
