return {
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		keys = require("config.mappings").omnisharp_extended,
	},
}
