-- vim.print("anisble ft")
vim.filetype.add({
  pattern = {
    [".*/tasks/.*.[yml|yaml]"] = "yaml.ansible",
    [".*/defaults/.*.[yml|yaml]"] = "yaml.ansible",
    [".*/meta/.*.[yml|yaml]"] = "yaml.ansible",
    [".*/molecule/.*/.*.[yml|yaml]"] = "yaml.ansible",
    [".*/handlers/.*.[yml|yaml]"] = "yaml.ansible",
    [".*/templated/.*.[yml|yaml]"] = "yaml.ansible"
  },
})
