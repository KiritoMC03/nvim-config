local servers = {
	lua_ls = {},
	omnisharp = {},
	-- csharp_ls = {},
}

local additional_tools = {
	"netcoredbg",
	"csharpier",
	"stylua",
	"xmlformatter",
	"fixjson",
}

local ensure_installed = vim.list_extend(vim.tbl_keys(servers), additional_tools)

---@param capabilities table | nil
---@return table
local function merge_lsp_capabilities(capabilities)
	capabilities = capabilities or {}
	local blink_there_is, blink = pcall(require, "blink.cmp")
	if blink_there_is then
		capabilities = blink.get_lsp_capabilities(capabilities)
	end

	return capabilities
end

return {
	{
		"williamboman/mason.nvim",
		config = true,
		-- event = "VeryLazy",
		-- lazy = true,
		opts = {
			max_concurrent_installers = 10,
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "",
				},
				border = "single",
			},
			registries = {
				"github:mason-org/mason-registry",
				"github:syndim/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		-- event = "VeryLazy",
		-- lazy = true,
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		opts = {
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = merge_lsp_capabilities(server.capabilities)
					require("lspconfig")[server_name].setup(server)
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = merge_lsp_capabilities(nil),
						settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,

				["omnisharp"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.omnisharp.setup({
						capabilities = merge_lsp_capabilities(nil),
						-- enable_roslyn_analysers = true,
						-- enable_import_completion = true,
						-- organize_imports_on_format = true,
						-- enable_decompilation_support = true,
						-- filetypes = {
						-- 	"cs",
						-- 	"vb",
						-- 	"csproj",
						-- 	"sln",
						-- 	"slnx",
						-- 	"props",
						-- 	"csx",
						-- 	"targets",
						-- 	"tproj",
						-- 	"slngen",
						-- 	"fproj",
						-- },
					})
				end,
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			ensure_installed = ensure_installed,
			run_on_start = true,
		},
	},
}
