local now, gh = Config.now, Config.gh

now(function()
  vim.pack.add({ gh('MeanderingProgrammer/render-markdown.nvim') })
end)
