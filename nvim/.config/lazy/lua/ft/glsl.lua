return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "glsl" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        glsl_analyzer = {
          cmd = { os.getenv('XDG_DATA_HOME') .. "/lsp/glsl_analyzer/bin/glsl_analyzer"},
          filetypes = { "glsl", "vert", "frag" }
        }
      },
    }
  }
}
