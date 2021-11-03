require 'nvim-treesitter.configs'.setup {
  ensure_installed = {  "bash",
                        "bibtex",
                        "c",
                        "c_sharp",
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
                        "yaml"
                      }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = { enable = true, disable = {} },
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
        goto_node = '<cr>',
        show_help = '?',
      },
    }
}
