return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"mason.nvim",
		},
		lazy = "VeryLazy",
		cmd = "ConformInfo",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				cs = { "csharpier" },
				json = { "fixjson" },
			},
		},
        keys = require("config.mappings").conform,
	},
}
