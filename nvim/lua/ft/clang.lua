return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" }
      }
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = { inline = false },
      ast = {
      --These require codicons (https://github.com/microsoft/vscode-codicons)
      role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    }
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        -- local command =
        require("dap").adapters["codelldb"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = os.getenv("XDG_DATA_HOME") .. '/codelldb/adapter/codelldb',
            args = {
              "--port",
              "${port}"
            }
          }
        }
      end

      for _, lang in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}"
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}"
          }
        }
      end
    end
  }
}
