local now, gh = Config.now, Config.gh

vim.pack.add({
  gh('yioneko/nvim-vtsls'),
})
local function make_default_locations_handler(prompt)
  local fzf = require('fzf-lua')

  -- preprocess only to call load icons
  -- fzf.make_entry.preprocess({ formatter = { 'path.filename_first', 2 }, file_icons = true })
  return function(err, locations, ctx, config)
    config = config or {}
    if err then
      error(err)
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end

    if not locations or vim.tbl_isempty(locations) then
    elseif #locations == 1 then
      vim.lsp.util.show_document(locations[1], client.offset_encoding, { focus = true, reuse_win = config.reuse_win })
    else
      local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
      local cwd = vim.loop.cwd()

      local entries = {}
      for _, entry in ipairs(items) do
        if entry then
          entry = fzf.make_entry.lcol(entry, {})
          entry = fzf.make_entry.file(entry, { cwd = cwd, file_icons = true, color_icons = true, path_shorten = true })

          table.insert(entries, entry)
        end
      end

      fzf.fzf_exec(entries, { prompt = prompt .. '>', previewer = 'builtin' })
    end
  end
end

require('nvim-vstls').setup({
  handlers = {
    file_references = make_default_locations_handler('File References'),
    source_definition = make_default_locations_handler('Source Definitions'),
  },
})
