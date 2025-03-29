local M = {}
local options = {
	{
		label = "Use system theme",
		key = "system_theme",
		default = true,
	},
	{
		label = "Prefer dark theme",
		key = "prefer_dark",
		default = true,
	},
	{
		label = "Relative lines number",
		key = "relative_number",
		default = true,
	},
}

local config = {}
for _, opt in ipairs(options) do
	config[opt.key] = opt.default or false
end

local storage = require("config.utils.storage")
local path = "/user_config.json"
local current_line = 1
local buf, win

-----

local function render_options()
	local lines = {}
	for i, opt in ipairs(options) do
		local checked = config[opt.key] and "[x]" or "[ ]"
		table.insert(lines, string.format(" %s %s", checked, opt.label))
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_win_set_cursor(win, { current_line, 0 })
end

-----

local function toggle_current_option()
	local opt = options[current_line]
	if opt then
		config[opt.key] = not config[opt.key]
		render_options()
	end
end

-----

function M.open_config_window(on_submit)
	config = vim.tbl_deep_extend("force", config, storage.load_cfg_file(path))

	buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = true

	local width = 40
	local height = #options + 2
	local ui = vim.api.nvim_list_uis()[1]
	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	win = vim.api.nvim_open_win(buf, true, {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
	})

	render_options()

	-- Map keys inside buffer
	vim.keymap.set("n", "j", function()
		current_line = math.min(current_line + 1, #options)
		vim.api.nvim_win_set_cursor(win, { current_line, 0 })
	end, { buffer = buf })

	vim.keymap.set("n", "k", function()
		current_line = math.max(current_line - 1, 1)
		vim.api.nvim_win_set_cursor(win, { current_line, 0 })
	end, { buffer = buf })

	vim.keymap.set("n", "<CR>", function()
		toggle_current_option()
	end, { buffer = buf })

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
		storage.save_cfg_file(config, path)
		if on_submit then
			on_submit(config)
		else
			print("There is no config handler" .. vim.inspect(config))
		end
	end, { buffer = buf })
end

return M
