return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-dap.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cd %localappdata%\\nvim-data\\lazy\\telescope-fzf-native.nvim && make && cd -",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			{ "nvim-telescope/telescope-project.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "debugloop/telescope-undo.nvim" },
		},
		keys = {
			{
				"<leader>ff",
				":Telescope find_files<CR>",
				desc = "Find Files",
			},
			{
				"<leader>fp",
				"<cmd>Telescope project display_type=full<cr>",
				desc = "Find Plugin File",
			},
            {
                "<leader>ft",
                ":Telescope live_grep<CR>",
                desc = "Find text everywhere",
            },
            {
                "<leader>fh",
                ":Telescope current_buffer_fuzzy_find<CR>",
                desc = "Find in file",
            },
		},
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
			extensions = {
				project = {
					base_dirs = {
						"D:/",
					},
				},
				undo = {
					use_delta = true,
					side_by_side = true,
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.4,
					},
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("dap")
			telescope.load_extension("project")
			telescope.load_extension("undo")
		end,
	},
}
