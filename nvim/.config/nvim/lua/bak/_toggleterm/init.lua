require('toggleterm').setup {

  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,

  open_mapping = [[<C-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '1', -- the degree by which o darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not theopen mapping applies in insert mode
  persist_size = true,
  -- direction = 'vertical' | 'horizontal' | 'wndow' | 'float',
  close_on_exit = true, -- close the terminal wndow when the process exits
  shell = vim.o.shell, -- change the default shll

  -- This field is only relevant if direction i set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'vim_open_win'
    -- see :h nvim_open_win for details on bordrs however
    -- the 'curved' border is a custom border tpe
    -- not natively supported but implemented i this plugin.

    border = 'shadow', -- 'single' | 'double' |'shadow' | 'curved', -- | ... other options supported by win open
    width = 45,
    height = 30,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
