--[[ local function substitute(str)
  str = str:gsub("%%", vim.fn.expand "%")
  str = str:gsub("$fileBase", vim.fn.expand "%:r")
  str = str:gsub("$filePath", vim.fn.expand "%:p")
  str = str:gsub("$file", vim.fn.expand "%")
  str = str:gsub("$dir", vim.fn.expand "%:p:h")
  str = str:gsub("#", vim.fn.expand "#")
  str = str:gsub("$altFile", vim.fn.expand "#")

  return cmd
end

vim.api.nvim_create_user_command("Build", function()

end) ]]

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
      inlay_hints = { inline = false }
    }
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_ops = require("util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_ops or {}, { server = opts }))
          return false -- why false?
        end
      }
    }
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        vim.print("no codelldb")
        -- local command =
        require("dap").adapters["codelldb"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = os.getenv("XDG_DATA_HOME") .. '/codelldb/adapter/codelldb',
            args = {
              -- "--liblldb",
              -- "/Users/nela/.local/share/codelldb/lldb/lib/liblldb.dylib",
              "--port",
              "${port}"
            }
          }
        }
      end

      for _, lang in ipairs({ "c", "cpp"--[[ , "rust"  ]]}) do
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
