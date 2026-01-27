---@type table<vim.lsp.Config>
return {
  {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    init_options = {
      command = { 'golangci-lint', 'run', '--output.json.path=stdout', '--show-stats=false' },
    },
    root_marker = {
      '.golangci.yml',
      '.golangci.yaml',
      '.golangci.toml',
      '.golangci.json',
      'go.work',
      'go.mod',
      '.git',
    },
  },
  {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    -- - root_dir (use "gF" to view): ../lsp/gopls.lua:88
  },
}
