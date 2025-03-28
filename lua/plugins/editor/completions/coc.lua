return {
    {
        "neoclide/coc.nvim",
        enabled = false,
        branch = "master",
        build = "npm ci",
        lazy = false,
        dependencies = {
            "windwp/nvim-autopairs",
        },
        keys = {
            {
                '<CR>',
                function()
                    return vim.fn['coc#pum#visible']() == 1
                        and vim.fn['coc#pum#confirm']()
                        or vim.api.nvim_replace_termcodes('<CR>', true, true, true)
                end,
                mode = 'i',
                expr = true,
                silent = true,
                noremap = true,
            },
            {
                '<C-b>',
                '<Plug>(coc-definition)',
                mode = 'n',
                silent = true,
                nowait = true,
            },
            {
                '<C-i>',
                '<Plug>(coc-implementation)',
                mode = 'n',
                silent = true,
                nowait = true,
            },
            {
                '<C-r>',
                '<Plug>(coc-references)',
                mode = 'n',
                silent = true,
                nowait = true,
            },
        },
    }
}
