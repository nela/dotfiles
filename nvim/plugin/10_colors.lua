local now, new_autocmd = Config.now, Config.new_autocmd
local gh = Config.gh

now(function()
  vim.pack.add({
    gh('sainnhe/gruvbox-material'),
    -- gh('norcalli/nvim-colorizer.lua'),
  })

  vim.g.gruvbox_material_background = 'hard'
  vim.g.gruvbox_material_foreground = 'original'
  vim.g.gruvbox_material_transparent_background = 2
  vim.g.gruvbox_material_enable_bold = 0
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_dim_inactive_windows = 1
  vim.g.gruvbox_material_ui_contrast = 'high'
  vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'

  local cb = function()
    local config = vim.fn['gruvbox_material#get_configuration']()
    local palette = vim.fn['gruvbox_material#get_palette'](config.background, config.foreground, config.colors_override)
    local set_hl = vim.fn['gruvbox_material#highlight']

    set_hl('NormalFloat', palette.fg0, palette.none)
    set_hl('FloatShadow', palette.fg0, palette.bg_dim)
    set_hl('FloatTitle', palette.orange, palette.bg_dim)
    set_hl('FloatFooter', palette.orange, palette.bg_dim)
    set_hl('FloatBorder', palette.fg0, palette.bg_dim)
    set_hl('Pmenu', palette.none, palette.bg0)
    -- set_hl('PmenuExtra', palette.none, palette.bg_dim)
    set_hl('CursorLine', palette.none, palette.bg0)
  end

  new_autocmd('ColorScheme', 'gruvbox-material', cb, 'Custom gruvbox material mods')

  vim.cmd.colorscheme('gruvbox-material')
end)
