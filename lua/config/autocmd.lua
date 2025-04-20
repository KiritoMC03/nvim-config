local autocmd = {}

local hints = require("utils.hints")

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		hints.toggle_inlay_hint(vim.g.config_win.inlay_hints)
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	callback = function ()
		vim.diagnostic.open_float({
			focusable = false,
			border = "rounded",
			prefix = "🔍 ",
		})
	end
})

return autocmd
