return {
    {
        "DNLHC/glance.nvim",
        event = "BufReadPre",
        config = true,
        keys = {
            { "gM", "<cmd>Glance implementations<cr>", desc = "Goto Implementations (Glance)" },
            { "gY", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition (Glance)" },
        },
    },
}
