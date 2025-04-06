--- @class PrefsScope
--- @field label string
--- @field key string
--- @field prefs Prefs[]

--- @class Prefs
--- @field label string
--- @field key string
--- @field default boolean

local M = {}

--- @type PrefsScope
local appearance = {
	label = "Appearance",
	key = "appearance",
	prefs = {
		{
			label = "Use system theme",
			key = "system_theme",
			default = true,
		},
		{
			label = "Prefer dark theme",
			key = "prefer_dark_theme",
			default = true,
		},
	},
}

--- @type PrefsScope
local system = {
	label = "System",
	key = "system",
	prefs = {
		{
			label = "Use system clipboard",
			key = "use_sys_clipboard",
			default = false,
		},
		{
			label = "Use ctrl+S",
			key = "use_ctrl_s",
			default = false,
		},
	},
}

--- @type PrefsScope
local navigation = {
	label = "Navigation",
	key = "navigation",
	prefs = {
		{
			label = "Relative lines number",
			key = "relative_number",
			default = true,
		},
	},
}

--- @type PrefsScope
local hints = {
	label = "Hints",
	key = "hints",
	prefs = {
		{
			label = "Show inlay hints",
			key = "inlay_hints",
			default = true,
		},
	},
}

--- @type PrefsScope[]
local scopes_def = {
	appearance,
	system,
	navigation,
	hints,
}

M.default_config = {}
for _, scope in ipairs(scopes_def) do
	for _, pref in ipairs(scope.prefs) do
		M.default_config[pref.key] = pref.default
	end
end

local storage = require("config.utils.storage")
local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Text = require("nui.text")
local Line = require("nui.line")
local Split = require("nui.split")
local Event = require("nui.utils.autocmd").event
local path = "/user_config.json"
local prefs_popup_offser = 1

-------

local function markup()
	local scopes_popup = Popup({
		enter = true,
		border = {
			style = "single",
			text = {
				top = "Preferences",
				top_align = "left",
			},
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	})

	local prefs_popup = Popup({
		border = "single",
	})

	local layout = Layout(
		{
			position = "50%",
			size = {
				width = "80%",
				height = "60%",
			},
		},
		Layout.Box({
			Layout.Box(scopes_popup, { size = "30%" }),
			Layout.Box(prefs_popup, { size = "70%" }),
		}, {
			dir = "row",
		})
	)

	return {
		layout,
		scopes_popup,
		prefs_popup
	}
end

-------

--- @param bufnr number
--- @param scopes PrefsScope[]
local function render_scopes(bufnr, scopes)
	for i, scope in ipairs(scopes) do
		local line = Line()
		line:append(i .. ". ", "Comment")
		line:append(scope.label, "Normal")
		line:render(bufnr, -1, i)
	end
end

-------

--- @param bufnr number
--- @param content PrefsScope
--- @param config any
local function render_prefs(bufnr, content, config)
	for i = 1, prefs_popup_offser, 1 do
		local space = Line()
		space:append(" ", "Normal")
		space:render(bufnr, -1, i)
	end
	local clear_after = -1;
	for i, pref in ipairs(content.prefs) do
		clear_after = i
		local checked = config[pref.key]
		local line = Line()
		line:append("	", "Normal")
		line:append(pref.label, "Normal")
		line:append(" [", "Normal")
		line:append(checked and "✅" or "❌", "Normal")
		line:append("]", "Normal")
		line:render(bufnr, -1, i+prefs_popup_offser)
	end
	vim.api.nvim_buf_set_lines(bufnr, clear_after+1, -1, false, {})
end

-------

--- @param bufnr number
local function clear_popup(bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
end

------

--- @param on_submit function
--- @return unknown
function M.open_config_window(on_submit)
	M.config = vim.tbl_deep_extend("force", M.default_config, storage.load_cfg_file(path))
	local r = markup()
	M.layout = r[1]
	M.scopes_popup = r[2]
	M.prefs_popup = r[3]

	M.scopes_popup:map("n", "<CR>", function ()
		vim.api.nvim_set_current_win(M.prefs_popup.winid)
	end)
	M.prefs_popup:map("n", "<Esc>", function ()
		vim.api.nvim_set_current_win(M.scopes_popup.winid)
	end)
	M.prefs_popup:map("n", "<BS>", function ()
		vim.api.nvim_set_current_win(M.scopes_popup.winid)
	end)
	M.prefs_popup:map("n", "<CR>", function ()
		local row, col = unpack(vim.api.nvim_win_get_cursor(M.prefs_popup.winid))
		local index = row - prefs_popup_offser
		local key = scopes_def[M.current_scope].prefs[index].key
		M.config[key] = not M.config[key]
		clear_popup(M.prefs_popup.bufnr)
		render_prefs(M.prefs_popup.bufnr, scopes_def[M.current_scope], M.config)
		vim.api.nvim_win_set_cursor(M.prefs_popup.winid, {row, col})
	end)

	M.scopes_popup:on({ Event.CursorMoved }, function()
		local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
		M.current_scope = row
		render_prefs(M.prefs_popup.bufnr, scopes_def[row], M.config)
	end)
	M.scopes_popup:on({ Event.BufUnload }, function ()
		storage.save_cfg_file(M.config, path)
		on_submit(M.config)
	end)

	M.layout:mount()
	render_scopes(M.scopes_popup.bufnr, scopes_def)

	return M.config
end

-------

function M.get_saved()
	return vim.tbl_deep_extend("force", M.default_config, storage.load_cfg_file(path))
end

-------

return M
