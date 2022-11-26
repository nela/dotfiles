local ok, dap_python = pcall(require, "dap-python")
if not ok then
    return
end

dap_python.setup(os.getenv('NELAPYS') .. '/debugpy/bin/python')
