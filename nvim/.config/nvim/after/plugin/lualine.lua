local set_theme = function()
  local theme
  local current_os = os.getenv("OSTYPE")
  print(current_os)
  if  string.find(current_os, 'linux-gnu') then
    theme = 'nord'
  elseif string.find(current_os, 'darwin') then
    theme = 'gruvbox'
  end
  return theme
end

require('lualine').setup {
  options = {
    theme = 'gruvbox',

    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    --   component_separators = {left = '', right = ''},
    --   section_separators = {left = '', right = ''},
    disabled_filetypes = {},  -- filetypes to diable lualine on
    always_divide_middle = true,
    -- When true left_sections (a,b,c) can't
    --   -- take over entiee statusline even
    --   -- when none of section x, y, z is present.
  },
  extensions = {'quickfix', 'fugitive', 'nvim-tree'}
}


