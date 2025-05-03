--- @class sic.core.config.plugins
--- @field load_defaults boolean
--- @field defaults_paths string[]

--- @class sic.core.config
--- @field plugins sic.core.config.plugins
--- @field lazy LazyConfig
local config = {
	plugins = {
		load_defaults = true,
		--- paths relative to ~config/lua/
		defaults_paths = {
			"plugins",
		},
	},
	lazy = {
		spec = {},
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
	},
}

return config
