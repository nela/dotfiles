return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>nt", "<cmd>NvimTreeToggle<cr>", "n", { noremap = true } },
    { "<leader>rf", "<cmd>NvimTreeRefresh<cr>", "n", { noremap = true } },
    { "<leader>nf", "<cmd>NvimTreeFindFile<cr>",  "n", { noremap = true } },
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

      vim.keymap.del("n", "<tab>", { buffer = bufnr })
      vim.keymap.set("n", "<M-p>", api.node.open.preview, opts("Open Preview"))
    end
  }
}
