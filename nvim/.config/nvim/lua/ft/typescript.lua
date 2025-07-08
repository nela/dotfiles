local function make_default_locations_handler(prompt)
  local fzf = require("fzf-lua")

  -- preprocess only to call load icons
  fzf.make_entry.preprocess({ formatter = { "path.filename_first", 2 }, file_icons = true })
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
        entry = fzf.make_entry.lcol(entry, {})
        entry = fzf.make_entry.file(entry, { cwd = cwd, file_icons = true, color_icons = true, path_shorten = true })
        table.insert(entries, entry)
      end

      fzf.fzf_exec(entries, { prompt = prompt .. ">", previewer = "builtin" })
    end
  end
end

return {
  {
    "yioneko/nvim-vtsls",
    dependencies = { "ibhagwan/fzf-lua" },
    opts = {
      handlers = {
        file_references = make_default_locations_handler("File References"),
        source_definition = make_default_locations_handler("Source Definitions"),
      },
    },
    enabled = true,
    config = function() end
  },
  {
    "joeveiga/ng.nvim",
    --stylua: ignore
    keys = {
      { "<leader>at", function() require("ng").goto_template_for_component({}) end },
      { "<leader>ac", function() require("ng").goto_component_with_template_file({}) end },
      { "<leader>aT", function() require("ng").get_template_tcb() end },
    },
  },
  {
    "mfussenegger/nvim-dap",
    -- optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              os.getenv("XDG_DATA_HOME") .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      for _, language in ipairs({ "typescript", "javascript" }) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  }
}
