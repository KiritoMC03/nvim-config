return {
	{
		"neoclide/coc.nvim",
		-- enabled = false,
		branch = "master",
		build = "npm ci",
		lazy = false,
		dependencies = {
			"windwp/nvim-autopairs",
		},
		init = function()
			vim.g.coc_global_extensions = 'https://github.com/kmz/coc-lua'
		end,
		config = function()
			vim.opt.updatetime = 300
			vim.opt.signcolumn = "yes"

			-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
			vim.api.nvim_create_augroup("CocGroup", {})
			vim.api.nvim_create_autocmd("CursorHold", {
				group = "CocGroup",
				command = "silent call CocActionAsync('highlight')",
				desc = "Highlight symbol under cursor on CursorHold",
			})
		end,
		keys = {
			-- completions
			{
				"<CR>",
				function()
					return vim.fn["coc#pum#visible"]() == 1
						and vim.fn["coc#pum#confirm"]()
						or vim.api.nvim_replace_termcodes("<CR>", true, true, true)
				end,
				mode = "i",
				expr = true,
				silent = true,
				noremap = true,
			},
			-- gotos
			{
				"<C-b>",
				"<Plug>(coc-definition)",
				mode = "n",
				silent = true,
				nowait = true,
			},
			{
				"<C-i>",
				"<Plug>(coc-implementation)",
				mode = "n",
				silent = true,
				nowait = true,
			},
			{
				"<C-r>",
				"<Plug>(coc-references)",
				mode = "n",
				silent = true,
				nowait = true,
			},
			-- refactoring
			{
				"rr",
				"<Plug>(coc-rename)",
				mode = "n",
				silent = true,
			},
			-- formatting
			{
				"<leader>rfs",
				"<Plug>(coc-format-selected)",
				desc = "Format selected code",
				mode = { "x", "n" },
				silent = true,
			},
			{
				"<leader>rfc",
				"<cmd>call CocAction('format')<CR>",
			},
			-- hints
			{
				"<leader>ht",
				"<cmd>CocCommand document.toggleInlayHint<CR>",
				desc = "Toggle inlay hints",
				silent = true,
			},
		},
	},
}
