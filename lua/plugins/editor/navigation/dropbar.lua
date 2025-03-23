return {
    {
        "Bekaboo/dropbar.nvim",
        lazy = false,
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        config = function(_, opts)
            require("dropbar").setup(opts)
            vim.g.dropbarapi = require("dropbar.api")
        end,
        keys = {
            {
                "<leader>;",
                "<cmd>lua vim.g.dropbarapi.pick()<CR>",
                desc = "Pick symbols in winbar",
            },
            {
                "[;",
                "<cmd>lua vim.g.dropbarapi.goto_context_start()<CR>",
                desc = "Go to start of current context",
            },
            {
                "];",
                "<cmd>lua vim.g.dropbarapi.select_next_context()<CR>",
                desc = "Select next context",
            },
        },
    },
}
