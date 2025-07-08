local angularls_cmd = {
  "ngserver",
  "--stdio",
  -- "--tsProbeLocations", find_probes_dir(),
  -- "--ngProbeLocations", find_probes_dir()
  "--tsProbeLocations", '/home/nela/.local/share/asdf/tools/installs/nodejs/22.14.0/lib/node_modules',
  "--ngProbeLocations", '/home/nela/.local/share/asdf/tools/installs/nodejs/22.14.0/lib/node_modules'
}

---@type vim.lsp.Config
return {
  cmd = angularls_cmd,
  root_markers = { 'angular.json' }
  --[[ on_new_config = function(new_config, _)
    new_config.cmd = angularls_cmd
  end ]]
}
