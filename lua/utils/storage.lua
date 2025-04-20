--- @class Storage
--- @field user_config string
local self = {
	user_config = "/user_config.json"
}

function self.save_cfg_file(config)
	local json = vim.fn.json_encode(config)
	local path = vim.fn.stdpath("config") .. self.user_config
	vim.fn.writefile({ json }, path)
end

-----

function self.load_cfg_file()
	local path = vim.fn.stdpath("config") .. self.user_config
	if vim.fn.filereadable(path) == 1 then
		local lines = vim.fn.readfile(path)
		local ok, decoded = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
		if ok and type(decoded) == "table" then
			return decoded
		end
	end
	return {} -- fallback to empty config
end

return self
