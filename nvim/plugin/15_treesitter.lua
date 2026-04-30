local now, gh, on_packchanged, new_autocmd = Config.now, Config.gh, Config.on_packchanged, Config.new_autocmd

local ensure_installed = {
  'bash',
  'c',
  'comment',
  'html',
  'javascript',
  'typescript',
  'svelte',
  'json',
  'lua',
  'python',
  'regex',
  'glsl',
  'yaml',
  'css',
  'scss',
  'qmljs',
  'rust',
  'sql',
  'terraform',
  'markdown',
  'vimdoc',
  'toml',
  'javascript',
  'dockerfile',
  'make',
  'go',
}

now(function()
  vim.pack.add({
    { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  })

  local not_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end

  local to_install = vim.tbl_filter(not_installed, ensure_installed)

  if #to_install > 0 then
    require('nvim-treesitter').install(to_install)
  end

  local filetypes = {}
  for _, lang in ipairs(ensure_installed) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
end)

new_autocmd('FileType', ensure_installed, function(ev)
  vim.treesitter.start(ev.buf)

  --folds
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo[0][0].foldmethod = 'expr'
  vim.wo[0][0].foldlevel = 99

  -- indent - experimental
  if ev.match ~= 'lua' then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end, 'Start treesitter. Enable folds, indent.')

on_packchanged('nvim-treesitter', { 'update' }, function(ev)
  if not ev.data.active then
    vim.cmd.packadd('nvim-treesitter')
  end
  vim.cmd('TSUpdate')
end, 'Start and update treesitter')
