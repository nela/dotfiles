return {
  {
    'norcalli/nvim-colorizer.lua',
    cmd = { 'ColorizerAttachToBuffer', 'ColorizerToggle' },
    opts = {
      'css',
      'css_fn',
      'hsl_fn',
      'rgb_fn',
    },
    main = 'colorizer',
  },
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'original'
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_enable_bold = 0
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_dim_inactive_windows = 1
      vim.g.gruvbox_material_ui_contrast = 'high'

      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      --[[ vim.g.gruvbox_material_colors_override = {
        bg0 = { '#141617', '234' },
        bg1 = { '#141617', '235' },
      } ]]

      --[[ if vim.fn.has('mac') then
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_disable_italic_comment = 0
        vim.g.gruvbox_material_virtual_text = 1
      else
        vim.g.gruvbox_material_enable_italic = 0
        vim.g.gruvbox_material_disable_italic_comment = 1
      end ]]

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {}),
        pattern = 'gruvbox-material',
        callback = function()
          local config = vim.fn['gruvbox_material#get_configuration']()
          local palette =
            vim.fn['gruvbox_material#get_palette'](config.background, config.foreground, config.colors_override)
          local set_hl = vim.fn['gruvbox_material#highlight']

          set_hl('NormalFloat', palette.fg0, palette.none)
          set_hl('FloatShadow', palette.fg0, palette.bg_dim)
          set_hl('FloatTitle', palette.orange, palette.bg_dim)
          set_hl('FloatFooter', palette.orange, palette.bg_dim)
          set_hl('FloatBorder', palette.fg0, palette.bg_dim)
          set_hl('Pmenu', palette.none, palette.bg0)
          -- set_hl('PmenuExtra', palette.none, palette.bg_dim)
          set_hl('CursorLine', palette.none, palette.bg0)
        end,
      })

      vim.cmd.colorscheme('gruvbox-material')
    end,
  },
}
