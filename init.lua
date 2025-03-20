-- Configure startup
vim.loader.enable()

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Load utils

local utils = require("config.utils")

-- Prepare Lazy

utils.lazy_bootstrap()

-- Setup options

require("config.options")

-- Setup Lazy

-- Setup custom events
local lazy_events = require("config.lazy_events")
lazy_events.setup()

require("lazy").setup({
	spec = utils.generate_lazy_import_specs(),
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
require("config.mappings")
require("config.colors")

-- LSP
--require("lspconfig").omnisharp.setup({
--	cmd = { "dotnet", "D:/LspServers/omnisharp-win-x64/OmniSharp.exe" },
--})

-- Telescope
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")

-- local pid = vim.fn.getpid()

-- local omnisharp_bin = "D:/LspServers/omnisharp-win-x64/OmniSharp.exe"

-- require'lspconfig'.omnisharp.setup{
--  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) }
--   -- Additional configuration can be added here
-- }
