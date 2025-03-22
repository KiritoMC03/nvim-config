return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = {
        "LazyFile",
        "VeryLazy",
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
    },
    config = function (_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
