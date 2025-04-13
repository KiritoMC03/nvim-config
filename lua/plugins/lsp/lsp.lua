return {
    {
		"neovim/nvim-lspconfig",
		-- event = { "BufReadPre", "BufNewFile" },
		-- event = "VeryLazy",
		lazy = false,
		dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		keys = require("config.mappings").lsp,
	},
}

