return {
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = true,
        keys = {
            {
                "<leader>gv",
                ":BlameToggle window<CR>",
                desc = "Git visualize changes",
            },
        },
    },
}
