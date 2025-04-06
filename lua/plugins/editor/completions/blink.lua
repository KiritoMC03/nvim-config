return {
    {
        "saghen/blink.cmp",
        enabled = false,
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "*",
        build = "cargo build --release",

        -- -@module 'blink.cmp'
        -- -@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",
                ["<CR>"] = {
                    function(cmp)
                      if cmp.snippet_active() then return cmp.accept()
                      else return cmp.select_and_accept() end
                    end,
                    'snippet_forward',
                    'fallback',
                },
                ["<Esc>"] = {
                    'cancel',
                    'fallback',
                },
            },
            appearance = {
                nerd_font_variant = "regular",
            },
            completion = {
                trigger = {
                    prefetch_on_insert = true,
                    show_on_keyword = true,
                    show_on_trigger_character = true,
                    show_on_blocked_trigger_characters = { '\n', '\t', '.' },
                },
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    auto_show = true,
                },
                documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 500,
                },
                ghost_text = {
                    enabled = false,
                },
            },
            -- sources = {
                -- default = { "lsp", "path", "snippets", "buffer" },
                -- omnisharp = { enabled = true, priority = 1000 },
            -- },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
        },
        opts_extend = { "sources.default" },
    },
}
