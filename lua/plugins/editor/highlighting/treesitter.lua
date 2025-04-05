return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = {
            "LazyFile",
            "VeryLazy",
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
        },
        lazy = vim.fn.argc(-1) == 0,
        init = function (plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts_extend = { "ensure_installed" },
        opts = {
            auto_install = true,
            ensure_installed = {
                "c_sharp",
                "xml",
                "yaml",
                "rust",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline"
            },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },

            -- nvim-treesitter-refactor:
            refactor = {
                highlight_current_scope = true,
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },

				-- rename with coc.nvim is preffered way now
                -- smart_rename = {
                --     enable = false,
                --     keymaps = {
                --         smart_rename = "rr",
                --     },
                -- },
            },
        },
        config = function (_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },
}
