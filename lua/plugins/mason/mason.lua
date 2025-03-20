return {
    {
        "williamboman/mason.nvim",
        -- event = "VeryLazy",
        lazy = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        -- event = "VeryLazy",
        lazy = true,
        dependencies = {
            "williamboman/mason.nvim"
        },
        opts = {
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
                "omnisharp",
            },
        },
    },
}
