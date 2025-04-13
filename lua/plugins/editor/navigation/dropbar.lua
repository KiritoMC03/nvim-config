return {
	{
		"Bekaboo/dropbar.nvim",
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		opts = {
            menu = {
                win_configs = {
                    -- none / single / double / rounded / solid / shadow
                    border = 'rounded',
                    style = 'minimal',
                },
            },
			sources = {
				path = {
					max_depth = 8,
				},
				treesitter = {
					valid_types = {
						"class",
						"struct",
						"scope",
						"property",
						"constructor",
						"enum",
						"function",
						"h1_marker",
						"h2_marker",
						"h3_marker",
						"h4_marker",
						"h5_marker",
						"h6_marker",
						"interface",
						"method",
						"namespace",
						"package",
						-- "goto_statement",
						-- "operator",
						-- "block_mapping_pair",
						-- "array",
						-- "boolean",
						-- "break_statement",
						-- "call",
						-- "case_statement",
						-- "constant",
						-- "continue_statement",
						-- "delete",
						-- "do_statement",
						-- "element",
						-- "enum_member",
						-- "event",
						-- "for_statement",
						-- "if_statement",
						-- "keyword",
						-- "macro",
						-- "null",
						-- "number",
						-- "pair",
						-- "reference",
						-- "repeat",
						-- "return_statement",
						-- "rule_set",
						-- "specifier",
						-- "switch_statement",
						-- "table",
						-- "type",
						-- "type_parameter",
						-- "unit",
						-- "value",
						-- "variable",
						-- "while_statement",
						-- "declaration",
						-- "field",
						-- "identifier",
						-- "object",
						-- "statement",
					},
				},
				lsp = {
					valid_symbols = {
						"File",
						"Module",
						"Namespace",
						"Package",
						"Class",
						"Method",
						"Property",
						"Constructor",
						"Enum",
						"Interface",
						"Function",
						"Struct",
						-- 'Field',
						-- 'Variable',
						-- 'Constant',
						-- 'String',
						-- 'Number',
						-- 'Boolean',
						-- 'Array',
						-- 'Object',
						-- 'Keyword',
						-- 'Null',
						-- 'EnumMember',
						-- 'Event',
						-- 'Operator',
						-- 'TypeParameter',
					},
				},
			},
		},
		config = function(_, opts)
			require("dropbar").setup(opts)
			vim.g.dropbarapi = require("dropbar.api")
		end,
		keys = require("config.mappings").dropbar,
	},
}
