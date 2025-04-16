local keys_utils = require("config.utils.keys")
local header = {
	[[  /$$$$$$                      /$$             /$$$$$$ /$$            /$$$$$$                               ]],
	[[ /$$__  $$                    | $$            |_  $$_/| $$           /$$__  $$                              ]],
	[[| $$  \__/ /$$   /$$  /$$$$$$$| $$   /$$        | $$ /$$$$$$        | $$  \__/  /$$$$$$   /$$$$$$   /$$$$$$ ]],
	[[|  $$$$$$ | $$  | $$ /$$_____/| $$  /$$/        | $$|_  $$_/        | $$       /$$__  $$ /$$__  $$ /$$__  $$]],
	[[ \____  $$| $$  | $$| $$      | $$$$$$/         | $$  | $$          | $$      | $$  \ $$| $$  \__/| $$  \ $$]],
	[[ /$$  \ $$| $$  | $$| $$      | $$_  $$         | $$  | $$ /$$      | $$    $$| $$  | $$| $$      | $$  | $$]],
	[[|  $$$$$$/|  $$$$$$/|  $$$$$$$| $$ \  $$       /$$$$$$|  $$$$/      |  $$$$$$/|  $$$$$$/| $$      | $$$$$$$/]],
	[[ \______/  \______/  \_______/|__/  \__/      |______/ \___/         \______/  \______/ |__/      | $$____/ ]],
	[[                                                                                                  | $$      ]],
	[[                                                                                                  | $$      ]],
	[[                                                                                                  |__/      ]],
}

--- @param key string
--- @param txt string
--- @param fake_key string | nil
--- @param force_bind boolean | nil
local function button(key, txt, fake_key, force_bind)
	local keys_list = keys_utils.replace_spec_with_icons(fake_key or key)
	local opts = {
		position = "center",
		shortcut = keys_list,
		cursor = 3,
		width = 32,
		align_shortcut = "right",
		hl_shortcut = "Keyword",
	}

	if force_bind then
		opts.keymap = { "n", fake_key, key, { noremap = true, silent = true, nowait = true } }
	end

	return {
		type = "button",
		val = txt,
		on_press = function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "m", true)
		end,
		opts = opts,
	}
end

return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		--- @module "config.mappings"
		local mappings = require("config.mappings")
		local dashboard = require("alpha.themes.dashboard")
		local screen_height = vim.fn.winheight(0)
		local content_height = #header + #dashboard.section.buttons.val
		local padding = math.floor((screen_height - content_height) / 2.5)

		dashboard.section.header.val = header

		local buttons = {
			button("<cmd>ene <CR>", " New file", "e", true),
		}
		for _, v in ipairs(mappings.main_keys_list) do
			table.insert(buttons, button(v.key, v.label))
		end
		dashboard.section.buttons.val = buttons

		dashboard.config.layout = {
			{ type = "padding", val = padding },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			dashboard.section.footer,
		}

		require("alpha").setup(dashboard.config)
	end,
}
