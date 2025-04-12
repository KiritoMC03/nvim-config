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
		keys = {
            -- stylua: ignore start
            { "[d", function() vim.lsp.diagnostic.goto_prev()end, desc = "lsp goto prev diagnostic" },
            { "]d", function() vim.lsp.diagnostic.goto_next()end, desc = "lsp goto next diagnostic" },
            { "gD", "<cmd>Trouble lsp_declarations<cr>", desc = "lsp declaration" },
            { "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "lsp definition" },
            { "gi", "<cmd>Trouble lsp_implementations<cr>", desc = "lsp implementation" },
            { "gk", function() vim.lsp.buf.hover()end, desc = "lsp hover" },
            { "gr", "<cmd>Trouble lsp_references<cr>", desc = "lsp references" },
            { "gy", "<cmd>Trouble lsp_type_definitions<cr>", desc = "lsp type definition" },
            -- stylua: ignore start
        },
	},
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},
}

