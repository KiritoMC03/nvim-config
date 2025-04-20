local self = {}
local fn = require("utils.fn")

---@param target_bufnr number
function self.show_undo_popup(target_bufnr)
	local Popup = require("nui.popup")
	local Line = require("nui.line")

	local history = vim.fn.undotree()
	local popup = Popup({
		border = {
			style = "rounded",
			text = { top = " Undo Stack ", top_align = "center" },
		},
		position = "50%",
		size = {
			width = 25,
			height = math.min(10, math.max(1, #history.entries)),
		},
		enter = true,
		focusable = true,
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	})

	popup:mount()

	local lines = {}
	local entries = fn.reverseTable(history.entries)

	for _, entry in ipairs(entries or {}) do
		local line = Line()
		local mark = (entry.seq == history.seq_cur) and "👉 " or "   "
		local ts = os.date("%H:%M:%S", entry.time or os.time())
		line:append(mark .. "[" .. entry.seq .. "]", "Comment")
		line:append(" at " .. ts, "Normal")
		table.insert(lines, line)
	end

	for i, line in ipairs(lines) do
		line:render(popup.bufnr, -1, i, 0)
	end

	popup:map("n", "q", function()
		popup:unmount()
	end)
	popup:map("n", "<CR>", function ()
		local line_nr = vim.api.nvim_win_get_cursor(popup.winid)[1]
		local line = vim.api.nvim_buf_get_lines(popup.bufnr, line_nr - 1, line_nr, false)[1]

		local target_entry = tonumber(string.match(line, "%[(%d+)%]"))
		local offset = history.seq_cur - target_entry

		vim.api.nvim_set_current_buf(target_bufnr)
		if offset > 0 then
			for _ = 1, offset, 1 do
				vim.cmd("undo")
			end
		else
			for _ = 1, -offset, 1 do
				vim.cmd("redo")
			end
		end
		popup:unmount()
	end)
end

return self
