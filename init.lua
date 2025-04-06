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
local mappings = require("config.mappings")
require("config.colors")
require("config.autocmd")
require("telescope").load_extension("fzf")
local config_win = require('config.config_win')

--- @module 'config.config_win'
--- @param config Config
local function handle_config(config)
	vim.g.config_win = config
	-- theme
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

	-- lines...
	if config.relative_number and not vim.wo.relativenumber then
		mappings.switch_lines()
	elseif not config.relative_number and not vim.wo.number then
		mappings.switch_lines()
	end

	-- clipboard
	mappings.switch_yank_sys(config.use_sys_clipboard)

	-- File ops
	mappings.switch_ctrl_s(config.use_ctrl_s)
	mappings.switch_ctrl_z(config.use_ctrl_z)
	mappings.switch_undo_stack(config.show_undo_stack)

	-- Inlay hints
	utils.hints.toggle_inlay_hint(config.inlay_hints)
end

handle_config(config_win.get_saved())
vim.api.nvim_create_user_command("ConfigUI", function ()
    config_win.open_config_window(handle_config)
end, {})
