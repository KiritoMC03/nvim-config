--- @class sic.core.api
local api = {}

--#region Debug

local debug = require("sic.core.debug")
api.debug = debug

--#endregion

--#region ReadOnly

local ReadOnly = {}
ReadOnly.__index = ReadOnly
api.ReadOnly = ReadOnly

--- Creates read-only wrapper for any T. You must use :get() instead of direct read
--- @generic T
--- @param value T
--- @return { get: fun(): T }
function ReadOnly.new(value)
	local self = setmetatable({}, ReadOnly)
	self._value = value
	return self
end

--- Get value
function ReadOnly:get()
	return self._value
end

--- Cannot write
--- @private
function ReadOnly:__newindex(_, key, _)
	debug.error("Cannot modify ReadOnly object (key: " .. tostring(key) .. ")")
end

--- Cannot read directly
--- @private
function ReadOnly:__index(key)
	if key == "get" then
		return rawget(ReadOnly, "get")
	else
		debug.error("Attempt to access protected key '" .. tostring(key) .. "' in ReadOnly")
	end
end

--#endregion

--#region Fs

--- Recursively goes through `dir_path` and subdirectories, and collects a list of plugin spec files, excluding empty folders or folders that only contains `init.lua` files
--- @param dir_path string
--- @return sic.core.plugins.spec[] specs
function api.collect_plugin_specs_recursively(dir_path)
	local uv = vim.loop
	local dir = uv.fs_opendir(dir_path, nil, 1000)
	if not dir then
		return {}
	end

	local entries = uv.fs_readdir(dir)
	if not entries then
		return {}
	end

	--- @type sic.core.plugins.spec[]
	local result = {}
	local has_non_init_content = false
	for _, entry in ipairs(entries) do
		if entry.type == "directory" then
			local sub_path = dir_path .. "/" .. entry.name
			local nested = api.collect_plugin_specs_recursively(sub_path)
			if #nested > 0 then
				--- @type sic.core.plugins.spec
				local spec = { import = sub_path:gsub("/", ".") }
				table.insert(result, spec)
				for _, item in ipairs(nested) do
					table.insert(result, item)
				end
				has_non_init_content = true
			end
		elseif entry.name ~= "init.lua" then
			-- Skip folders that only contain init.lua
			has_non_init_content = true
		end
	end
	-- Only import this folder if it has real content
	if has_non_init_content then
		--- @type sic.core.plugins.spec
		local spec = { import = dir_path:gsub("/", ".") }
		table.insert(result, 1, spec)
	end

	return result
end

--#endregion

local event_prefix = "SIC"
api.event_prefix = ReadOnly.new(event_prefix)
api.events = ReadOnly.new({
	INIT = event_prefix .. "Init",
	CONFIG_LOADED = event_prefix .. "ConfigLoaded",
})

return api
