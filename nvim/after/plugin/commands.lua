vim.api.nvim_create_user_command('EnableN00bMode', function()
  vim.opt.mouse = 'a'
end, {})

vim.api.nvim_create_user_command('G', function(opts)
  vim.cmd('botright vertical Git ' .. opts.args)
end, { nargs = '*' })
