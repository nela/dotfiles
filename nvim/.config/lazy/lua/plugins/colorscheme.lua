return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    -- config = function() vim.cmd([[ colorscheme gruvbox-material ]]) end,
    init = function()
    	vim.g.gruvbox_material_palette = "original"
    	vim.g.gruvbox_material_background = "hard"
    	vim.g.gruvbox_material_transparent_background = 1
    	vim.g.gruvbox_material_better_performance = 1
    	vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

    	if vim.fn.has("mac") then
    		vim.g.gruvbox_material_enable_italic = 1
    		vim.g.gruvbox_material_disable_italic_comment = 0
    		vim.g.gruvbox_material_virtual_text = 1
    	else
    		vim.g.gruvbox_material_enable_italic = 0
    		vim.g.gruvbox_material_disable_italic_comment = 1
    	end
    end
  }
}
