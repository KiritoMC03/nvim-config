return {
    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = "default" },

            appearance = {
                nerd_font_variant = "regular",
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                -- completion = {
                    -- enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
                -- },
                -- providers = {
                    -- lsp = { fallback_for = { "lazydev" } },
                    -- lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
                -- },
            },
        },
        opts_extend = { "sources.default" },
    },
}
