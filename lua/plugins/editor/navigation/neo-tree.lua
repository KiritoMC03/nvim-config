return {
    	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
        lazy = false,
        config = true,
        opts = {
            filesystem = {
                filtered_items = {
                    visible = true,
                    show_hidden_count = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
            },
            buffers = {
                follow_current_file = { enable = true }
            },
        },
        keys = {
            {
                "<leader>nf",
                ":Neotree left focus<CR>",
                desc = "Explorer focus",
            },
            {
                "<leader>nt",
                ":Neotree left toggle<CR>",
                desc = "Explorer toggle",
            },
            {
                "<leader>fr",
                ":Neotree reveal<CR>",
                desc = "Reveal file",
            },
        },
	},

}
