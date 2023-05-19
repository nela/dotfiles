local ok, null_ls = pcall(require, "null-ls")
if not ok then
    return
end

null_ls.setup {
  sources = {
    -- null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.diagnostics.actionlint,
    -- null_ls.builtins.diagnostics.codespell,
    null_ls.builtins.diagnostics.gitlint,
    null_ls.builtins.diagnostics.eslint_d,
    -- null_ls.builtins.diagnostics.misspell,
    null_ls.builtins.diagnostics.selene,
    null_ls.builtins.diagnostics.shellcheck,
    -- null_ls.builtins.diagnostics.yamllint,
    -- null_ls.builtins.formatting.cbfmt,
    -- null_ls.builtins.formatting.jq,
    --[[ null_ls.builtins.formatting.ktlint.with({
      timeout = 10000
    }), ]]
    -- null_ls.builtins.formatting.markdownlint,
    -- null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.stylua,
  },
  on_attach = require("nelsp.on_attach"),
  log_level = "trace"
}
