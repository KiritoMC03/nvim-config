local M = {}

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<S-f>", "*", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-s>", ":ConfigUI<CR>")

--------

function M.switch_lines()
	vim.opt.relativenumber = not vim.wo.relativenumber:get()
	vim.opt.number = not vim.wo.number:get()
end
vim.keymap.set("n", "<leader>dl", M.switch_lines, { desc = "Switch lines mode" })

--------

---@param use_sys_clipboard boolean
function M.switch_yank_sys(use_sys_clipboard)
	local prefix = ''
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

--------

---@param enabled boolean
function M.switch_ctrl_z(enabled)
	local modes = { "n", "i", "v" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(
				mode,
				"<C-z>",
				mode == "i" and "<C-o>u" or "" .. "u",
				{ noremap = true, silent = true, desc = "Undo" }
			)
		else
			pcall(vim.keymap.del, mode, "<C-z>")
		end
	end
end

--------

---@param enabled boolean
function M.switch_undo_stack(enabled)
	local modes = { "n" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(
				mode,
				"<leader>u",
				function ()
					require("config.utils.root").popups.show_undo_popup(vim.api.nvim_get_current_buf())
				end,
				{ desc = "Show undo stack" }
			)
		else
			pcall(vim.keymap.del, mode, "<leader>u")
		end
	end
end

--------

---@param enabled boolean
function M.switch_ctrl_s(enabled)
	local modes = { "n", "i", "v" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(mode, "<C-s>", "<Cmd>w<CR>", { noremap = true, silent = true, desc = "Save" })
			vim.keymap.set(mode, "<A-s>", "<Cmd>wa<CR>", { noremap = true, silent = true, desc = "Save all" })
		else
			pcall(vim.keymap.del, mode, "<C-s>")
			pcall(vim.keymap.del, mode, "<A-s>")
		end
	end
end

--------

local map_go_line = function(keys, label, motion)
	vim.keymap.set("n", "<leader>j" .. keys, function()
		local n = tonumber(vim.fn.input(label))
		if n then
			vim.cmd("normal! " .. n .. motion)
		end
	end, { desc = label })
end

map_go_line("j", "Jump down by: ", "j")
map_go_line("k", "Jump up by: ", "k")

--------

return M
