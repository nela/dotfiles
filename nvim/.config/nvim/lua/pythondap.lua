local dap = require('dap')

local cmd = os.getenv('NELAPYS') .. '/debugpy/bin/python'
print(cmd)

dap.adapters.python = {
  type = 'executable';
  command = os.getenv('NELAPYS') .. '/debugpy/bin/python';
  args = { '-m', 'debugpy.adapter' };
}


dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      local venv = os.getenv('VIRTUAL_ENV')
      if (venv ~= nil and venv ~= '') then
        return string.format('%s/bin/python', venv)
      elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return error('Unable to locate virtual environment for the current project', 2)
      end
    end;
  },
}

vim.cmd('source ' .. os.getenv('NVIM') .. '/opt/dapbindings.vim')
