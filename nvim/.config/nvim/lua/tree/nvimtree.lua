-- local winwidt = function()
--   return vim.api.nvim_win_get_width(0)/2
-- end

require('nvim-tree').setup {
  -- nvim_tree_disable_netrw = true,
  disable_netrw = true,
  hijack_netrw = true,
  view = {
    width = math.floor(vim.api.nvim_win_get_width(0)/5),
      --43, --(winwidth(0)/5),
    number = false,
    mappings = {
      custom_only = true,
      list = {
          { key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
          { key = {"O"},                          action = "edit_no_picker" },
          { key = {"<2-RightMouse>", "<C-]>"},    action = "cd" },
          { key = "<C-v>",                        action = "vsplit" },
          { key = "<C-x>",                        action = "split" },
          { key = "<C-t>",                        action = "tabnew" },
          { key = "<",                            action = "prev_sibling" },
          { key = ">",                            action = "next_sibling" },
          { key = "P",                            action = "parent_node" },
          { key = "<BS>",                         action = "close_node" },
          { key = "<M-p>",                        action = "preview" },
          { key = "K",                            action = "first_sibling" },
          { key = "J",                            action = "last_sibling" },
          { key = "I",                            action = "toggle_ignored" },
          { key = "H",                            action = "toggle_dotfiles" },
          { key = "R",                            action = "refresh" },
          { key = "a",                            action = "create" },
          { key = "d",                            action = "remove" },
          { key = "D",                            action = "trash" },
          { key = "r",                            action = "rename" },
          { key = "<C-r>",                        action = "full_rename" },
          { key = "x",                            action = "cut" },
          { key = "c",                            action = "copy" },
          { key = "p",                            action = "paste" },
          { key = "y",                            action = "copy_name" },
          { key = "Y",                            action = "copy_path" },
          { key = "gy",                           action = "copy_absolute_path" },
          { key = "[c",                           action = "prev_git_item" },
          { key = "]c",                           action = "next_git_item" },
          { key = "-",                            action = "dir_up" },
          { key = "s",                            action = "system_open" },
          { key = "q",                            action = "close" },
          { key = "g?",                           action = "toggle_help" },
      }
    }
  },
  renderer = {
    indent_markers = {
      enable = true
    }
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
}

vim.api.nvim_set_keymap('n', '<leader>nt', ':NvimTreeToggle <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rf', ':NvimTreeRefresh <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>nf', ':NvimTreeFindFile <CR>', { noremap = true })
