require 'nvim-treesitter.configs'.setup {
  ensure_installed =
    {  "bash",
      "bibtex",
      "c",
      "comment",
      "cpp",
      "css",
      "go",
      "graphql",
      "html",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "julia",
      "kotlin",
      "latex",
      "lua",
      "python",
      "regex",
      "rst",
      "rust",
      "supercollider",
      "svelte",
      "tsx",
      "typescript",
      "yaml",
      "hcl"
  }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },

  indent = { enable = true },

  playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<Cr>',
        show_help = '?',
      },
    },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<Cr>',
      scope_incremental = '<Cr>',
      node_incremental = '<Tab>',
      node_decremental = '<S-Tab>'
    }
  }
}
