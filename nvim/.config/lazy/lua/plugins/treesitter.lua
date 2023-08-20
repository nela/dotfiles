local load_textobjects = false

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function()
          require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
          load_textobjectss = true
        end,
      }
    },
    cmd = { 'TSUpdateSync', 'TSInstall' },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "html",
        "java",
        "javascript",
        "json",
        "kotlin",
        "latex",
        "lua",
        "python",
        "regex",
        -- "rst",
        -- "rust",
        -- "supercollider",
        -- "svelte",
        "tsx",
        "typescript",
        "yaml",
      },
      highlight = { enable = true, additional_vim_regex_highlighting = true, },
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
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
      rainbow = {
        enable = true,
        extended_mode = true, -- highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than n lines, int
      }
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end
  }
}
