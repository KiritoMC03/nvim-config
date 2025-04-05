local autocmd = {}

local hints = require("config.utils.root").hints

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(args)
		hints.toggle_inlay_hint(vim.g.config_win.inlay_hints)
	end,
})

return autocmd
