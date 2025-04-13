--- @class PrefsScope
--- @field label string
--- @field key string
--- @field prefs Prefs[]

--- @class Prefs
--- @field label string
--- @field key string
--- @field type PrefType | nil
--- @field default boolean | string
--- @field options function | table | nil
--- @field apply_on_change boolean | nil

--- @class Config
--- @field system_theme boolean
---	@field prefer_dark boolean,
---	@field preload_colorschemes boolean
---	@field relative_number boolean,
---	@field use_sys_clipboard boolean,
---	@field use_ctrl_s boolean,
---	@field use_ctrl_z boolean,
---	@field inlay_hints boolean,
---	@field show_diag_on_hover boolean,
---	@field show_undo_stack boolean,
---	@field colorscheme string,

--- @class PrefLineState
--- @field type PrefType | SpecialLine
--- @field key string
--- @field option_name string | nil
--- @field apply_on_change boolean | nil
--- @field radio_opened boolean | nil

--- @alias PrefType 'toggle'|'radio'
--- @alias SpecialLine 'radio_label' | 'apply_on_change_toggle' | 'none'

--- @class ConfigWin
--- @field pref_line_states PrefLineState[]
local M = {
	pref_line_states = {},
}

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
		{
			label = "Preload colorschemes (after restart only)",
			key = "preload_colorschemes",
			default = false,
		},
		{
			label = "Colorscheme",
			key = "colorscheme",
			type = "radio",
			default = "gruvbox",
			options = function()
				return require("plugins.appearance.colorschemes")
			end,
			apply_on_change = true,
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
		{
			label = "Use ctrl+Z",
			key = "use_ctrl_z",
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
		{
			label = "Show diagnostics on hover",
			key = "show_diag_on_hover",
			default = true,
		},
		{
			label = "Show undo stack",
			key = "show_undo_stack",
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
---@class NuiLine: any
local Line = require("nui.line")
local Event = require("nui.utils.autocmd").event
local path = "/user_config.json"
local prefs_popup_offser = 1
local tab = "	"
local ui_win = nil

-------

--- @param config any
--- @param pref any
--- @param bufnr number
--- @param pos number
--- @param apply_on_change boolean
--- @return NuiLine line
local function render_toggle(config, pref, bufnr, pos, apply_on_change)
	local checked = config[pref.key]
	local line = Line()
	line:append(tab .. pref.label .. " [" .. (checked and "✅" or "❌") .. "]")
	line:render(bufnr, -1, pos)
	M.pref_line_states[pos] = {
		type = "toggle",
		key = pref.key,
		apply_on_change = apply_on_change,
	}
	return line
end

-------

--- @param config any
--- @param pref any
--- @param bufnr number
--- @param pos number
--- @param apply_on_change boolean
--- @return NuiLine[] lines
local function render_radio(config, pref, bufnr, pos, apply_on_change)
	local lines = {}
	local label = Line()
	label:append(tab .. pref.label .. ":")
	label:render(bufnr, -1, pos)
	table.insert(lines, label)
	local radio_opened = M.pref_line_states[pos] and M.pref_line_states[pos].radio_opened or false
	M.pref_line_states[pos] = {
		type = "radio_label",
		key = pref.label,
		radio_opened = radio_opened,
	}

	local current = config[pref.key]
	local options = pref.options
	if type(options) == "function" then
		options = options()
	end
	if M.pref_line_states[pos].radio_opened then
		for _, option in ipairs(options) do
			pos = pos + 1
			local is_selected = (current == option.name)
			local symbol = is_selected and "(●)" or "( )"
			local line = Line()
			line:append(tab .. tab .. symbol .. " " .. option.name)
			line:render(bufnr, -1, pos)
			table.insert(lines, line)
			M.pref_line_states[pos] = {
				type = "radio",
				key = pref.key,
				option_name = option.name,
				apply_on_change = apply_on_change,
			}
		end
	end
	return lines
end

-------

--- @param pref any
--- @param bufnr number
--- @param pos number
--- @return boolean apply_on_change
local function render_apply_on_change_toggle(pref, bufnr, pos, target)
	local checked = M.pref_line_states[pos] and M.pref_line_states[pos].apply_on_change or false
	local line = Line()
	line:append(tab .. "Apply '" .. target .. "' on change " .. (checked and "✅" or "❌"), "Comment")
	line:render(bufnr, -1, pos)

	M.pref_line_states[pos] = {
		type = "apply_on_change_toggle",
		key = pref.key,
		apply_on_change = checked,
	}
	return checked
end

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
		prefs_popup,
	}
end

-------

--- @param bufnr number
--- @param scopes PrefsScope[]
local function render_scopes(bufnr, scopes)
	for i, scope in ipairs(scopes) do
		local line = Line()
		line:append(i .. ". ", "Comment")
		line:append(scope.label)
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
		space:append("")
		space:render(bufnr, -1, i)
	end
	local clear_after = -1
	local last_line = prefs_popup_offser + 1
	for _, pref in ipairs(content.prefs) do
		local pos = last_line
		local apply_on_change = false
		if pref.apply_on_change == true then
			apply_on_change = render_apply_on_change_toggle(pref, bufnr, pos, pref.label)
			pos = pos + 1
			last_line = last_line + 1
		end
		if pref.type == "radio" then
			local lines = render_radio(config, pref, bufnr, pos, apply_on_change)
			last_line = last_line + #lines
		else
			render_toggle(config, pref, bufnr, pos, apply_on_change)
			last_line = last_line + 1
		end
		clear_after = last_line - 1
	end
	vim.api.nvim_buf_set_lines(bufnr, clear_after, -1, false, {})
end

-------

--- @param bufnr number
local function clear_popup(bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
end

------

--- @param on_submit function
function M.open_config_window(on_submit)
	if ui_win and vim.api.nvim_win_is_valid(ui_win) then
		vim.api.nvim_set_current_win(ui_win)
		return
	end

	M.config = vim.tbl_deep_extend("force", M.default_config, storage.load_cfg_file(path))
	local r = markup()
	M.layout = r[1]
	M.scopes_popup = r[2]
	M.prefs_popup = r[3]

	M.scopes_popup:map("n", "<CR>", function()
		vim.api.nvim_set_current_win(M.prefs_popup.winid)
	end)
	M.prefs_popup:map("n", "<Esc>", function()
		vim.api.nvim_set_current_win(M.scopes_popup.winid)
	end)
	M.prefs_popup:map("n", "<BS>", function()
		vim.api.nvim_set_current_win(M.scopes_popup.winid)
	end)
	M.prefs_popup:map("n", "<CR>", function()
		local row, col = unpack(vim.api.nvim_win_get_cursor(M.prefs_popup.winid))
		local line_state = M.pref_line_states[row]
		local key = line_state.key
		if line_state.type == "none" then
			return
		elseif line_state.type == "toggle" then
			M.config[key] = not M.config[key]
		elseif line_state.type == "radio_label" then
			M.pref_line_states[row].radio_opened = not line_state.radio_opened
		elseif line_state.type == "radio" then
			M.config[key] = line_state.option_name
		elseif line_state.type == "apply_on_change_toggle" then
			M.pref_line_states[row].apply_on_change = not line_state.apply_on_change
		else
			vim.notify("[ConfigUI] Wrong config line kind", vim.log.levels.ERROR)
		end

		render_prefs(M.prefs_popup.bufnr, scopes_def[M.current_scope], M.config)
		vim.api.nvim_win_set_cursor(M.prefs_popup.winid, { row, col })

		if line_state.apply_on_change then
			on_submit(M.config)
			vim.wo.number = false
			vim.wo.relativenumber = false
		end
	end)

	M.scopes_popup:on({ Event.CursorMoved }, function()
		local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
		M.current_scope = row
		M.pref_line_states = {}
		clear_popup(M.prefs_popup.bufnr)
		render_prefs(M.prefs_popup.bufnr, scopes_def[row], M.config)
	end)
	M.scopes_popup:on({ Event.BufUnload }, function()
		storage.save_cfg_file(M.config)
		on_submit(M.config)
	end)

	M.layout:mount()
	ui_win = M.scopes_popup.winid
	render_scopes(M.scopes_popup.bufnr, scopes_def)
end

-------

---@return Config
function M.get_saved()
	return vim.tbl_deep_extend("force", M.default_config, storage.load_cfg_file())
end

-------

return M
