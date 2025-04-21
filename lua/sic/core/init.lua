local api = require("sic.core.api")
local config = require("sic.core.config")
local debug = require("sic.core.debug")
local events = require("sic.core.events")
local modules = require("sic.core.modules")
local plugins = require("sic.core.plugins")

local sic = {}

--- Initializes the SuckItCorp core system
function sic.init()
	debug.info("Initializing SuckItCorp...")

	-- Emit INIT event
	events.emit(api.events:get().INIT)

	-- Bootstrap plugin manager
	plugins.bootstrap()

	-- Collect plugin specs
	--- @type sic.core.plugins.spec[]
	local specs = {}

	if config.plugins.load_defaults then
		for _, path in ipairs(config.plugins.defaults_paths) do
			local specs_for_path = api.collect_plugin_specs_recursively(path)
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
	events.emit(api.events:get().CONFIG_LOADED)

	debug.info("SuckItCorp initialized.")
end

return sic
