local api = require("core.api")
local config = require("core.config")
local debug = require("core.debug")
local events = require("core.events")
local modules = require("core.modules")
local plugins = require("core.plugins")

debug.info("Initializing SIC...")

-- Emit INIT event
events.emit(api.events.INIT)

-- Bootstrap plugin manager
plugins.bootstrap()

-- Collect plugin specs
--- @type sic.core.plugins.spec[]
local specs = {}

for i, s in ipairs(require("utils.lazy_").generate_lazy_import_specs()) do
	print(s.import)
end

if config.plugins.load_defaults then
	for _, path in ipairs(config.plugins.defaults_paths) do
		local specs_for_path = api.collect_plugin_specs_recursively(path)
		for index, spe in ipairs(specs_for_path) do
			
			print(spe.import)
		end
		vim.list_extend(specs, specs_for_path)
	end
end

-- Setup Lazy.nvim with collected specs
local ok, lazy = pcall(require, "lazy")
if not ok then
	debug.error("Failed to load lazy.nvim")
	return
end

config.lazy.spec = specs
lazy.setup(config.lazy)
debug.info("lazy.nvim initialized with " .. #specs .. " specs.")

-- Load all modules
local failed_modules = modules.load_all()
if #failed_modules > 0 then
	debug.warn("Some modules failed to load.")
end

-- Emit CONFIG_LOADED event
events.emit(api.events.CONFIG_LOADED)

debug.info("SIC initialized.")

-- -- Configure startup
-- vim.loader.enable()
--
-- -- vim.g.loaded_netrw = 1
-- -- vim.g.loaded_netrwPlugin = 1
--
-- -- Load utils
--
-- require("utils.state")
-- local utils_lazy = require("utils.lazy_")
-- local utils_hints = require("utils.hints")
--
-- -- Prepare Lazy
--
-- utils_lazy.lazy_bootstrap()
--
-- -- Setup options
--
-- require("config.options")
--
-- -- Setup Lazy
--
-- -- Setup custom events
-- local lazy_events = require("config.lazy_events")
-- lazy_events.setup()
--
-- require("lazy").setup({
-- 	spec = utils_lazy.generate_lazy_import_specs(),
-- 	install = { colorscheme = { "vscode" } },
-- 	change_detection = {
-- 		notify = false,
-- 	},
-- 	performance = {
-- 		rtp = {
-- 			-- disable some rtp plugins
-- 			disabled_plugins = {
-- 				"gzip",
-- 				-- "matchit",
-- 				-- "matchparen",
-- 				"man",
-- 				"rplugin",
-- 				"netrwPlugin",
-- 				"tarPlugin",
-- 				"tohtml",
-- 				"tutor",
-- 				"zipPlugin",
-- 			},
-- 		},
-- 	},
-- })
--
-- -- Other configs
-- local mappings = require("config.mappings")
-- require("config.autocmd")
-- require("telescope").load_extension("fzf")
-- local config_win = require('config.config_win')
-- local colors = require("config.colors")
--
-- --- @module 'config.config_win'
-- --- @param config Config
-- local function handle_config(config)
-- 	vim.g.config_win = config
-- 	-- theme
-- 	if config.system_theme then
-- 		vim.cmd("silent! Lazy reload auto-dark-mode.nvim")
-- 		require("auto-dark-mode").setup()
-- 	else
-- 		if config.prefer_dark then
-- 			vim.api.nvim_set_option_value("background", "dark", {})
-- 		else
-- 			vim.api.nvim_set_option_value("background", "light", {})
-- 		end
-- 	end
--
-- 	vim.g.theme = config.colorscheme
-- 	vim.g.linetheme = config.colorscheme
-- 	colors.set_coloscheme(config.colorscheme)
--
-- 	-- lines
-- 	if config.relative_number and not vim.wo.relativenumber then
-- 		mappings.switch_lines()
-- 	elseif not config.relative_number and not vim.wo.number then
-- 		mappings.switch_lines()
-- 	end
--
-- 	-- clipboard
-- 	mappings.switch_yank_sys(config.use_sys_clipboard)
--
-- 	-- File ops
-- 	mappings.switch_ctrl_s(config.use_ctrl_s)
-- 	mappings.switch_ctrl_z(config.use_ctrl_z)
-- 	mappings.switch_undo_stack(config.show_undo_stack)
--
-- 	-- Inlay hints
-- 	utils_hints.toggle_inlay_hint(config.inlay_hints)
-- end
--
-- handle_config(config_win.get_saved())
-- vim.api.nvim_create_user_command("ConfigUI", function ()
--     config_win.open_config_window(handle_config)
-- end, {})
