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

return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local dashboard = require("alpha.themes.dashboard")
		local screen_height = vim.fn.winheight(0)
		local content_height = #header + #dashboard.section.buttons.val
		local padding = math.floor((screen_height - content_height) / 2.5)

		dashboard.section.header.val = header

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
