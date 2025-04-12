local os = require("config.utils.root").os

--- @return table | string | boolean build_command
local function build()
	if true then
		return false
	else
		local target = ""
		local artifact = ""
		local mv_to = "target/release/blink_cmp_fuzzy"
		if os.is_win() then
			target = "x86_64-pc-windows-msvc"
			artifact = "target/x86_64-pc-windows-msvc/release/blink_cmp_fuzzy.dll"
			mv_to = mv_to .. ".dll"
		end
		print("rustup target add " .. target)
		print("cargo build --release --target " .. target)
		print("mv " .. artifact .. " " .. mv_to)
		return {
			"rustup target add " .. target,
			"cargo build --release --target " .. target,
			"move " .. artifact .. " " .. mv_to,
		}
	end
end

return {
    {
        "saghen/blink.cmp",
        -- enabled = false,
        lazy = false,
        -- dependencies = { "rafamadriz/friendly-snippets" },
        version = "*",
        build = build(),

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
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
