--- @class sic.core.modules.Module
--- @field name string The unique name of the module.
--- @field load_fn fun(): boolean, string|nil Loads the module. Returns true on success, or false and error message.

--- @type sic.core.modules.Module[]
local list = {}
local debug = require("core.debug")

--- @class sic.core.modules
local modules = {}

--- @param module sic.core.modules.Module
function modules.register(module)
	local name = module.name
	if list[name] then
		debug.warn("Module '" .. name .. "' is already registered. Overwriting.")
	end
	list[name] = module
end

--- @return sic.core.modules.Module[] failed_to_load
function modules.load_all()
	local failed = {}
	for name, module in pairs(list) do
		local ok, err = module.load_fn()
		if not ok then
			table.insert(failed, module)
			debug.error("Module '" .. name .. "' failed to load: " .. err)
		else
			debug.info("Module '" .. name .. "' loaded successfully.")
		end
	end
	return failed
end

--- @return boolean is_loaded
function modules.load(name)
	local module = list[name]
	if not module then
		debug.warn("Module '" .. name .. "' is not registered.")
		return false
	end
	local ok, err = module.load_fn()
	if not ok then
		debug.error("Module '" .. name .. "' failed to load: " .. err)
		return false
	else
		debug.info("Module '" .. name .. "' loaded successfully.")
		return true
	end
end

return modules
