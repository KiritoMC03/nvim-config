return {
    "sindrets/diffview.nvim",
    keys = {
        {
            "<leader>gdf",
            ":DiffviewOpen<CR>",
            desc = "Git view difference",
        },
        {
            "<leader>gdh",
            ":DiffviewFileHistory %<CR>",
            desc = "Git file history",
        },
        {
            "<leader>gdc",
            ":DiffviewClose<CR>",
            desc = "Git diff close",
        },
    },
}
