local ok, dap_python = pcall(require, "dap-python")
if not ok then
    return
end

dap_python.setup(os.getenv('NELAPYS') .. '/debugpy/bin/python')

local configurations = require('dap').configurations.python
for _, configuration in pairs(configurations) do
  configuration.justMyCode = false
end
