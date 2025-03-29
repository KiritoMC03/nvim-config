-- Configure startup
vim.loader.enable()
vim.g.theme = "vscode"
vim.g.linetheme = "vscode"

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Load utils

local utils = require("config.utils.root")

-- Prepare Lazy

utils.lazy.lazy_bootstrap()

-- Setup options

require("config.options")

-- Setup Lazy

-- Setup custom events
local lazy_events = require("config.lazy_events")
lazy_events.setup()

require("lazy").setup({
	spec = utils.lazy.generate_lazy_import_specs(),
	install = { colorscheme = { "vscode" } },
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				"man",
				"rplugin",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- Other configs
require("config.mappings")
require("config.colors")
require("telescope").load_extension("fzf")

function open_config_window()
	---@param config { system_theme: boolean, prefer_dark: boolean, relative_number: boolean }
	utils.config_win.open_config_window(function(config)
		if config.system_theme then
			vim.cmd("silent! Lazy reload auto-dark-mode.nvim")
			require("auto-dark-mode").setup()
		else
			if config.prefer_dark then
				vim.api.nvim_set_option_value("background", "dark", {})
			else
				vim.api.nvim_set_option_value("background", "light", {})
			end
		end
	end)
end

vim.api.nvim_create_user_command("ConfigUI", open_config_window, {})
