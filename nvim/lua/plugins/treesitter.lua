return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = { "go", "gomod", "gowork", "gosum" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
