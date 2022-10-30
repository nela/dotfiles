local ok, leap = pcall(require, "leap")
if not ok then
    return
end

vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'LeapMatch', {
  fg = 'white',
  bold = true,
  nocombine = true,
})

leap.opts.highlight_unlabeled_phase_one_targets = true
leap.add_default_mappings()
