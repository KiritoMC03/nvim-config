local M = {}

function M.save_cfg_file(config)
	local json = vim.fn.json_encode(config)
	local path = vim.fn.stdpath("config") .. "/user_config.json"
	vim.fn.writefile({ json }, path)
end

-----

function M.load_cfg_file()
	local path = vim.fn.stdpath("config") .. "/user_config.json"
	if vim.fn.filereadable(path) == 1 then
		local lines = vim.fn.readfile(path)
		local ok, decoded = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
		if ok and type(decoded) == "table" then
			return decoded
		end
	end
	return {} -- fallback to empty config
end

return M
