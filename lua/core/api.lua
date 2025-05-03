--- @class sic.core.api
local api = {}

--#region Debug

local debug = require("core.debug")
api.debug = debug

--#endregion

--#region Read only

function api.read_only(t)
	local proxy = {}
	local mt = {
		__index = t,
		__newindex = function()
			error("attempt to update a read-only table", 2)
		end,
	}
	setmetatable(proxy, mt)
	return proxy
end
local read_only = api.read_only

--#endregion

--#region Fs

--- Recursively goes through `source` and subdirectories, and collects a list of plugin spec files, excluding empty folders or folders that only contains `init.lua` files
--- @param source string relative to ~config/lua/ directory
--- @return sic.core.plugins.spec[] specs
function api.collect_plugin_specs_recursively(source)
	source = source:gsub("/$", "")
	local uv = vim.loop
	local path = vim.fn.stdpath("config") .. "/" .. "lua" .. "/" .. source
	local dir = uv.fs_opendir(path, nil, 1000)
	if not dir then
		return {}
	end

	local entries = uv.fs_readdir(dir)
	if not entries then
		return {}
	end

	--- @type sic.core.plugins.spec[]
	local result = {}
	local has_specs = false

	for _, entry in ipairs(entries) do
		if entry.type == "directory" then
			local sub_path = source .. "/" .. entry.name
			local nesteds = api.collect_plugin_specs_recursively(sub_path)
			for _, nested in ipairs(nesteds) do
				table.insert(result, nested)
			end
		elseif entry.name ~= "init.lua" then
			has_specs = true
		end
	end

	if has_specs then
		local spec = { import = source:gsub("/", ".") }
		table.insert(result, spec)
	end

	return result
end

--#endregion

local event_prefix = "SIC_"
api.event_prefix = read_only(event_prefix)
api.events = read_only({
	INIT = event_prefix .. "Init",
	CONFIG_LOADED = event_prefix .. "ConfigLoaded",
})

return api
