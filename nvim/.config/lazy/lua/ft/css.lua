local util = require("lspconfig.util")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "scss", "css" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {
          settings = {
            css = {
              lint = { unknownAtRules = "ignore" },
              validate = true },
            scss = {
              lint = { unknownAtRules = "ignore" },
              validate = true
            },
          },
          cmd = { "vscode-css-language-server", "--stdio" }
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
              },
              validate = true
            }
          },
          cmd = { "tailwindcss-language-server", "--stdio" },
          filetypes = { "svelte", "css", "scss", "html", "postcss", "javascript", "typescript" },
          root_dir = util.root_pattern('tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts', 'package.json')
        }
      }
    }
  }
}
