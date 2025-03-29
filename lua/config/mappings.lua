local M = {}

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<S-f>", "*", { noremap = true, silent = true })

--------

function M.switch_lines()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
	vim.opt.number = not vim.opt.number:get()
end
vim.keymap.set("n", "<leader>dl", M.switch_lines, { desc = "Switch lines mode" })

--------

function M.switch_yank_sys(use_sys_clipboard)
	local prefix = {}
	if use_sys_clipboard then
		prefix = '"+'
	else
		prefix = ""
	end
	vim.keymap.set("n", "y", prefix .. "y")
	vim.keymap.set("n", "yy", prefix .. "yy")
	vim.keymap.set("n", "Y", prefix .. "Y")
	vim.keymap.set("x", "y", prefix .. "y")
	vim.keymap.set("x", "Y", prefix .. "Y")
end

function M.switch_ctrl_s(enabled)
	local modes = { "n", "i", "v" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(mode, "<C-s>", "<Cmd>w<CR>", { noremap = true, silent = true, desc = "Save" })
		else
			pcall(vim.keymap.del, mode, "<C-s>")
		end
	end
end

return M
