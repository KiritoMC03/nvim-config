return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		auto_preview = true
	},
    keys = require("config.mappings").trouble,
}
