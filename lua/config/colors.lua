local M = {}

vim.opt.termguicolors = true

function M.set_coloscheme(scheme)
	scheme = scheme or "vscode"
	local ok = pcall(vim.cmd.colorscheme, scheme)
	if not ok then
		vim.notify("Failed to set " .. scheme .. " scheme", vim.log.levels.WARN)
	elseif scheme ~= "vscode" then
		pcall(vim.cmd.colorscheme, scheme)
	end

	-- vim.api.nvim_set_hl(0, "Normal", {bg = "#120E27"})
	-- vim.api.nvim_set_hl(0, "NormalFloat", {bg = "#0E0A23"})
	-- vim.api.nvim_set_hl(0, "ColorColumn", {bg = "none"})
	-- vim.api.nvim_set_hl(0, "LineNr", {bg = "none"})
end

return M
