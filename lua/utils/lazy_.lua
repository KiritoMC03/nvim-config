local M = {}

function M.lazy_bootstrap()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			lazyrepo,
			lazypath,
		})
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end

	vim.opt.rtp:prepend(lazypath)
end

function M.generate_lazy_import_specs()
	local specs = {}

	local function add_specs_from_dir(path)
		local uv = vim.loop
		local stats = uv.fs_readdir(uv.fs_opendir(vim.fn.stdpath("config") .. "/" .. "lua" .. "/" .. path, nil, 1000))
		if not stats then
			return
		end
		for _, stat in ipairs(stats) do
			if stat.type == "directory" then
				local new_import_path = path .. "/" .. stat.name
				table.insert(specs, { import = new_import_path:gsub("/", ".") })
				add_specs_from_dir(new_import_path)
			elseif stat.name == "init.lua" then
				table.remove(specs) -- removes last element
			end
		end
	end

	add_specs_from_dir("plugins")
	return specs
end

return M
