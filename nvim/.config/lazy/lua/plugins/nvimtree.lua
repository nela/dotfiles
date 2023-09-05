return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    renderer = {
      indent_markers = { enable = true },
      icons = { show = { folder_arrow = false } }
    },
    filters = { custom = { ".^git$" } },
    git = { ignore = false },
    view = {
      width = function ()
        return math.floor((vim.go.columns/9)*2)
      end,
      number = false,
      -- mappings = { custom_only = true }
    },
    hijack_directories = {
      enable = true,
      auto_open = true
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true
        }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.del('n', '<tab>', { buffer = bufnr })
      vim.keymap.set('n', '<M-p>', api.node.open.preview, opts('Open Preview'))
      vim.keymap.set('n', '<leader>nt', '<cmd>NvimTreeToggle<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>rf', '<cmd>NvimTreeRefresh<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>nf', '<cmd>NvimTreeFindFile<cr>', { noremap = true })
    end
  }
}
