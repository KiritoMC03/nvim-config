return {
    -- Setup nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "L3MON4D3/LuaSnip",
            -- "saadparwaiz1/cmp_luasnip",
        },

        opts = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            -- local defaults = require("cmp.config.default")()
            local auto_select = true
            -- local luasnip = require("luasnip")

            return {
                auto_brackets = {},
                completion = {
                    completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                },
                preselect = cmp.PreselectMode.Item,
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Esc>"] = cmp.mapping.abort(),
                    ["<Down>"] = cmp.mapping.select_next_item(),
                    ["<Up>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    -- { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            }
        end,
    }
}
