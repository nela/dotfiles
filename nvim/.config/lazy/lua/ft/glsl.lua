return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        --[[ glsl_analyzer = {
          cmd = { os.getenv('XDG_DATA_HOME') .. '/lsp/glsl_analyzer/bin/glsl_analyzer' },
        } ]]
        glslls = {
          cmd = { os.getenv('XDG_DATA_HOME') .. '/lsp/glsl-language-server/build/glslls', '--stdin' },
          filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" }
        }
      }
    }
  }
}
