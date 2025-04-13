return {
    {
        "GustavEikaas/easy-dotnet.nvim",
		enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
        lazy = true,
        cmd = "Dotnet",
        opts = {
            -- terminal = function(path, action)
            --     local commands = {
            --         run = function()
            --             return "dotnet run --project " .. path
            --         end,
            --         test = function()
            --             return "dotnet test " .. path
            --         end,
            --         restore = function()
            --             return "dotnet restore " .. path
            --         end,
            --         build = function()
            --             return "dotnet build " .. path
            --         end,
            --     }
            --     local cmd = commands[action]() .. "\r"
            --     Snacks.terminal.open(cmd)
            -- end,
            test_runner = {
                viewmode = "float",
                icons = {
                    project = "󰗀",
                },
            },
        },
        keys = require("config.mappings").easy_dotnet,
    },
}
