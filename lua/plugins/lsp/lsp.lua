return {
    {
		"neovim/nvim-lspconfig",
		-- event = { "BufReadPre", "BufNewFile" },
		-- event = "VeryLazy",
		lazy = false,
		dependencies = {
            { "williamboman/mason.nvim", config = true },
            { "williamboman/mason-lspconfig.nvim" },
            { "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		config = function()
            local mason = require("mason")
            local mason_tool_installer = require("mason-tool-installer")
            local mason_lspconfig = require("mason-lspconfig")

            local servers = {
                lua_ls = {},
            }

            local ensure_installed = vim.tbl_keys(servers)
            vim.list_extend(ensure_installed, {
                "csharpier", -- c# formatter
                "netcoredbg", -- c# debugger
                "prettier", -- prettier formatter
                "rustywind", -- tailwind class sorter
                "stylua", -- lua formatter
                "xmlformatter", -- xml formatter
            })

            mason.setup {
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
                },
            }
            mason_tool_installer.setup { ensure_installed = ensure_installed }
            mason_lspconfig.setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            }
        end,
	},
}




	-- 		local capabilities = require('cmp_nvim_lsp').default_capabilities()
	-- 		local lspconfig = require('lspconfig')

	-- 		lspconfig.lua_ls.setup({
	-- 			capabilities = capabilities
	-- 		})

	-- 		lspconfig.omnisharp.setup({
	-- 			capabilities = capabilities,
	-- 			enable_roslyn_analysers = true,
	-- 			enable_import_completion = true,
	-- 			organize_imports_on_format = true,
	-- 			enable_decompilation_support = true,
	-- 			filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets', 'tproj', 'slngen', 'fproj' },
	-- 		})

	-- 		lspconfig.powershell_es.setup({
	-- 			capabilities = capabilities,
	-- 			bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
	-- 			init_options = {
	-- 				enableProfileLoading = false,
	-- 			}
	-- 		})

	-- 		lspconfig.pylsp.setup({
	-- 			capabilities = capabilities,
	-- 		})

	-- 		lspconfig.yamlls.setup({
	-- 			capabilities = capabilities
	-- 		})

	-- 		lspconfig.buf_ls.setup({
	-- 			capabilities = capabilities
	-- 		})

	-- 		lspconfig.bicep.setup({
	-- 			capabilities = capabilities
	-- 		})

	-- 		lspconfig.lemminx.setup({
	-- 			capabilities = capabilities
	-- 		})

	-- 		lspconfig.pylsp.setup({
	-- 			capabilities = capabilities
	-- 		})

	-- 		-- lspconfig.codeql.setup({
	-- 		-- 	capabilities = capabilities
	-- 		-- })

	-- 		vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
	-- 		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	-- 		-- vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, {})
	-- 	end
	-- },
	-- {
	-- 	'nvimtools/none-ls.nvim',
	-- 	-- event = { "BufReadPre", "BufNewFile" },
	-- 	lazy = true,
	-- 	-- event = "VeryLazy",
	-- 	config = function()
	-- 		local null_ls = require('null-ls')
	-- 		null_ls.setup({
	-- 			sources = {
	-- 				-- null_ls.builtins.formatting.stylua,
	-- 				-- null_ls.builtins.formatting.csharpier,
	-- 				-- null_ls.builtins.formatting.yamlfmt,
	-- 				-- null_ls.builtins.formatting.black,
	-- 				-- null_ls.builtins.formatting.isort,
	-- 			}
	-- 		})
	-- 		vim.keymap.set('n', '<leader>lff', function() vim.lsp.buf.format({ async = true }) end,
	-- 			{ desc = "Format document" })
	-- 		vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = "Rename Symbol" })
	-- 		vim.keymap.set({ 'n', 'i' }, '<f2>', vim.lsp.buf.rename, { desc = "Rename Symbol" })
	-- 		vim.keymap.set({ 'n', 'i' }, '<f12>', vim.lsp.buf.definition, { desc = "Go to Definition" })
	-- 		vim.keymap.set({ 'n' }, '<leader>ld', vim.lsp.buf.definition, { desc = "Go to Definition" })
	-- 		vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, { desc = "Go to Implementation" })
	-- 		vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, { desc = "Signature Help" })
	-- 		vim.keymap.set('n', '<leader>lsR', vim.lsp.buf.references, { desc = "To to References" })
	-- 		-- vim.keymap.set({ 'n' }, '<leader>lsD', ":Trouble document_diagnostics<CR>", { desc = "Toggle Document Diagnostics" })
	-- 		vim.keymap.set({ 'n' }, '<leader>lsD', ":Trouble diagnostics<CR>", { desc = "Toggle Document Diagnostics" })
	-- 		vim.keymap.set('n', '<leader>lsI', ':Trouble lsp_implementations<CR>',
	-- 			{ desc = "Toggle LSP References" })
	-- 		vim.keymap.set('n', '<leader>lsd', ":Trouble lsp_definitions<CR>", { desc = "Toggle LSP Definitions" })
	-- 	end
	-- },
	-- {
	-- 	"jay-babu/mason-null-ls.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	-- event = { 'VeryLazy' },
	-- 	-- enabled = false,
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 		"nvimtools/none-ls.nvim",
	-- 		-- "neovim/nvim-lspconfig"
	-- 	},
	-- 	config = function()
	-- 		require('mason-null-ls').setup({
	-- 			automatic_setup = true
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require('lsp_lines').setup()

	-- 		vim.diagnostic.config({
	-- 			virtual_lines = false,
	-- 			virtual_text = true,
	-- 		})

	-- 		local function toggleLines()
	-- 			local new_value = not vim.diagnostic.config().virtual_lines
	-- 			vim.diagnostic.config({ virtual_lines = new_value, virtual_text = not new_value })
	-- 			return new_value
	-- 		end

	-- 		vim.keymap.set('n', '<leader>lu', toggleLines, { desc = "Toggle Underline Diagnostics", silent = true })
	-- 	end
	-- },
-- }
