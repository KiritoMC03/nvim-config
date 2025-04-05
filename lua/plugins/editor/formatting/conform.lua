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
			},
		},
        keys = {
            {
                '<leader>cf',
                function ()
                    require('conform').format()
                end,
                desc = 'Format code',
            },
        },
	},
}
