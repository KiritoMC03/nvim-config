-- Configure startup
vim.loader.enable()

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1


-- Prepare Lazy

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  	local out = vim.fn.system({
  		"git",
  		"clone",
  		"--filter=blob:none",
  		"--branch=stable",
  		lazyrepo,
  		lazypath
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

-- Setup options

require("config.options")

-- Setup Lazy

require("lazy").setup({
	spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { import = "lazyvim.plugins.extras" },
		{ import = "plugins" },
	},
	install = { colorscheme = { "vscode" } },
	change_detection = {
		notify = false
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
	}
})


-- Other configs
require("config.files")
require("config.mappings")
require("config.colors")

-- LSP
require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", "D:/LspServers/omnisharp-win-x64/OmniSharp.exe" },
}

-- local pid = vim.fn.getpid()

-- local omnisharp_bin = "D:/LspServers/omnisharp-win-x64/OmniSharp.exe"

-- require'lspconfig'.omnisharp.setup{
--  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) }
--   -- Additional configuration can be added here
-- }
