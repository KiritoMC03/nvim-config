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
	capabilities = vim.tbl_deep_extend("keep", capabilities, vim.lsp.protocol.make_client_capabilities() or {})
	local blink_there_is, blink = pcall(require, "blink.cmp")
	if blink_there_is then
		capabilities = blink.get_lsp_capabilities(capabilities)
	end

	return capabilities
end

--- @param buf_path string
--- @param bufnr number
--- @return string
local function get_omnisharp_root_dir(buf_path, bufnr)
	local startup_dir = vim.fn.getcwd(-1)
	if vim.fn.filereadable(startup_dir .. ".vimnetproj") then
		return startup_dir
	else
		return require("lspconfig").util.root_pattern(buf_path)
	end
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
						-- single_file_support = true,
						cmd = { vim.fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp" },
						capabilities = merge_lsp_capabilities(nil),
						root_dir = get_omnisharp_root_dir,
						-- enable_roslyn_analysers = true,
						-- enable_import_completion = true,
						-- organize_imports_on_format = true,
						-- enable_decompilation_support = true,
						-- on_attach = function(client, bufnr)
						-- 	local function buf_set_option(...)
						-- 		vim.api.nvim_buf_set_option(bufnr, ...)
						-- 	end
						-- 	buf_set_option("omnisharp", "omnisharp")
						-- end,
						filetypes = {
							"cs",
							"vb",
							"csproj",
							"sln",
							"slnx",
							"props",
							"csx",
							"targets",
							"tproj",
							"slngen",
							"fproj",
						},
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
