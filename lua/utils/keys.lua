--- @alias SpecName string
--- @alias Icon string

--- @class Keys
--- @field spec_icons table<SpecName, Icon>
local M = {
	spec_icons = {
		Up = " ",
		Down = " ",
		Left = " ",
		Right = " ",
		C = "󰘴 ",
		M = "󰘵 ",
		D = "󰘳 ",
		S = "󰘶 ",
		CR = "󰌑 ",
		Esc = "󱊷 ",
		ScrollWheelDown = "󱕐 ",
		ScrollWheelUp = "󱕑 ",
		NL = "󰌑 ",
		BS = "󰁮",
		Space = "󱁐 ",
		Tab = "󰌒 ",
		F1 = "󱊫",
		F2 = "󱊬",
		F3 = "󱊭",
		F4 = "󱊮",
		F5 = "󱊯",
		F6 = "󱊰",
		F7 = "󱊱",
		F8 = "󱊲",
		F9 = "󱊳",
		F10 = "󱊴",
		F11 = "󱊵",
		F12 = "󱊶",
	},
}

--- Gets termcodes of keys in string
--- @param keys string
--- @return string termcodes
function M.termcodes(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

--- Normalizes the keymap
--- @param keymap string
--- @return string normalized
function M.normalize(keymap)
	return vim.fn.keytrans(M.termcodes(keymap))
end

--- Returns the keys of a keymap, taking multibyte and special keys into account
--- @param keymap string
--- @param opts? {normalized?: boolean}
--- @return string[] keys
function M.split_into_keys(keymap, opts)
	keymap = opts and opts.normalized == false and keymap or M.normalize(keymap)
	local ret = {} ---@type string[]
	local bytes = vim.fn.str2list(keymap) ---@type number[]
	local special = nil ---@type string?
	for _, byte in ipairs(bytes) do
		local char = vim.fn.nr2char(byte) ---@type string
		if char == "<" then
			special = "<"
		elseif special then
			special = special .. char
			if char == ">" then
				ret[#ret + 1] = special == "<lt>" and "<" or special
				special = nil
			end
		else
			ret[#ret + 1] = char
		end
	end

	return ret
end

--- Replaces special keys like <CR> or <Space> with icons
--- @param keymap string
--- @return string keys
function M.replace_spec_with_icons(keymap)
  local splited = M.split_into_keys(keymap)
  local ret = vim.tbl_map(function(key)
    local inner = key:match("^<(.*)>$")
    if not inner then
      return key
    end
    if inner == "NL" then
      inner = "C-J"
    end
    local parts = vim.split(inner, "-", { plain = true })
    for i, part in ipairs(parts) do
      if i == 1 or i ~= #parts or not part:match("^%w$") then
        parts[i] = M.spec_icons[part] or parts[i]
      end
    end
    return table.concat(parts, "")
  end, splited)
  return table.concat(ret, "")
end

return M
