
local complete_registers = function(opts)
  -- opts = config.normalize_opts(opts, config.globals.registers)
  -- if not opts then return end

  local registers = { [["]], "_", "#", "=", "_", "/", "*", "+", ":", ".", "%" }
  -- named
  for i = 0, 9 do
    table.insert(registers, tostring(i))
  end
  -- alphabetical
  for i = 65, 90 do
    table.insert(registers, string.char(i))
  end

  local utils = require("fzf-lua.utils")
  local shell = require "fzf-lua.shell"

  local function register_escape_special(reg, nl)
    if not reg then return end
    local gsub_map = {
      ["\3"]  = "^C", -- <C-c>
      ["\27"] = "^[", -- <Esc>
      ["\18"] = "^R", -- <C-r>
    }
    for k, v in pairs(gsub_map) do
      reg = reg:gsub(k, utils.ansi_codes.magenta(v))
    end
    return not nl and reg or
        reg:gsub("\n", utils.ansi_codes.magenta("\\n"))
  end


  local prev_act = shell.action(function(args)
    local r = args[1]:match("%[(.*)%] ")
    local _, contents = pcall(vim.fn.getreg, r)
    return contents and register_escape_special(contents) or args[1]
  end, nil, opts.debug)

  local entries = {}
  for _, r in ipairs(registers) do
    -- pcall as this could fail with:
    -- E5108: Error executing lua Vim:clipboard:
    --        provider returned invalid data
    local _, contents = pcall(vim.fn.getreg, r)
    contents = register_escape_special(contents, true)
    if (contents and #contents > 0) or not opts.ignore_empty then
      table.insert(entries, string.format("[%s] %s",
        utils.ansi_codes.yellow(r), contents))
    end
  end

  opts = {
    fzf_opts = {
      ["--no-multi"] = ""
    },
    ---@param selected string: the selected entry or entries
    ---@param opts: fzf-lua caller/provider options
    ---@param line string originating buffer completed line

    ---@param col: originating cursor column location
    ---@return newline: will replace the current buffer line
    ---@return newcol?: optional, sets the new cursor column

    complete = function(selected, opts, line, col)

      local newlines = {}
      local newline
      for _, value in ipairs(selected) do
        local start, _ = value:find("%s+")
        newline = value:sub(start + 1)
        newline:gsub("(.-)\\n", function(part)
        table.insert(newlines, part)
        end)
        print(type(newlines))
        vim.print(newlines)

      end
      return newlines


    end
  }
  --[[ opts.fzf_opts["--no-multi"] = ""
  opts.fzf_opts["--preview"] = prev_act
  opts.complete = true ]]

  require("fzf-lua").fzf_exec(entries, opts)
end





vim.keymap.set("i", "<C-x><C-r>", function() complete_registers({}) end)



vim.keymap.set({ "i" }, "<C-x><C-v>",
  function()
    require("fzf-lua").complete_file({
      cmd = "rg --files",
      winopts = { preview = { hidden = "nohidden" } }
    })

  end, { silent = true, desc = "Fuzzy complete file" })

local test_reg = function()
  local registers = { [["]], "_", "#", "=", "_", "/", "*", "+", ":", ".", "%" }
  -- named
  for i = 0, 9 do
    table.insert(registers, tostring(i))
  end
  -- alphabetical
  for i = 65, 90 do
    table.insert(registers, string.char(i))
  end


end
