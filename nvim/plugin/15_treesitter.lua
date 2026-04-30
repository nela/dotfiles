local now, gh = Config.now, Config.gh

now(function()
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

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter',
    group = vim.api.nvim_create_augroup('nelavim:start_treesitter', { clear = true }),
    pattern = filetypes,
    callback = function(ev)
      vim.treesitter.start(ev.buf)

      --folds
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldlevel = 99

      -- indent - experimental
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.spec.kind
      if name == 'nvim_treesitter' and kind == 'update' then
        if not ev.data.active then
          vim.cmd.packadd('nvim-treesitter')
        end
        vim.cmd('TSUpdate')
      end
    end,
  })
end)
