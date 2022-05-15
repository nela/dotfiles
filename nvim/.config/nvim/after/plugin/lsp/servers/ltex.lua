local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local ltex_settings = {
  ltex = {
    enabled = { 'latex', 'tex', 'bib', 'markdown' },
    language = 'en-GB',
    diagnosticSeverity = 'information',
    setenceCacheSize = 2000,
    additionalRules = {
      enablePickyRules = true,
    },
    trace = { server = 'verbose' },
    dictionary = {},
    enabledRules = {},
    disabledRules = {},
    hiddenFalsePositives = {},
  }
}

ltex_settings.ltex.disabledRules['en-GB'] = { 'PASSIVE_VOICE' }
ltex_settings.ltex.enabledRules['en-GB'] = { 'TEXT_ANALYSIS' }

lspconfig.ltex.setup {
  settings = ltex_settings
}
