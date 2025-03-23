return {
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        dependencies = {
            "saghen/blink.cmp",
        },
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            config = {
                capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
                handlers = {
				    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			    },
                settings = {
                    ["csharp|inlay_hints"] = {
                        -- csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        -- csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        -- csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                        -- csharp_enable_inlay_hints_for_types = true,
                        -- dotnet_enable_inlay_hints_for_indexer_parameters = true,
                        -- dotnet_enable_inlay_hints_for_literal_parameters = true,
                        -- dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                        -- dotnet_enable_inlay_hints_for_other_parameters = true,
                        -- dotnet_enable_inlay_hints_for_parameters = true,
                        -- dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                        -- dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                        -- dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                    },
                    ["csharp|highlighting"] = {
                        dotnet_highlight_related_regex_components = true,
                        dotnet_highlight_related_json_components = true,
                    },
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true,
                        dotnet_enable_tests_code_lens = true,
                    },
                    ["csharp|completion"] = {
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                        dotnet_show_name_completion_suggestions = true,
                    },
                    ["csharp|symbol_search"] = {
                        dotnet_search_reference_assemblies = true,
                    },
                },
            },
        },
        config = function (_, opts)
            require("roslyn").setup(opts)
            vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave" }, {
                pattern = "*.cs",
                callback = function(args)
                    local clients = vim.lsp.get_clients({ bufnr = args.buf })
                    for _, client in ipairs(clients) do
                        if client.name == "roslyn" then
                            vim.lsp.codelens.refresh({ bufnr = args.buf })
                            vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = args.buf })
                        end
                    end
                end,
            })
        end
    },
}
