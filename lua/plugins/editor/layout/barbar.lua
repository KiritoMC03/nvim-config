local key_opts = {
	noremap = true,
	silent = true,
}

local function generate_gotos(up_to)
	local keys = {}
	for i = 1, up_to do
		table.insert(keys, {
			"<A-" .. i .. ">",
			"<Cmd>BufferGoto " .. i .. "<CR>",
			desc = "Go to tab" .. i,
			key_opts,
		})
	end
	return keys
end

return {
	"romgrk/barbar.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		animation = true,
	},
	keys = vim.list_extend({
		{
			"<A-.>",
			"<Cmd>BufferNext<CR>",
			key_opts,
		},
		{
			"<A-,>",
			"<Cmd>BufferPrevious<CR>",
			key_opts,
		},
	}, generate_gotos(9)),
}
