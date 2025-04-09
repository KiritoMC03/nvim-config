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
        keys = {
            -- stylua: ignore start 
            -- { "<leader>nb", function() require("easy-dotnet").build_default_quickfix() end, desc = "build" },
            { "<leader>.netB", function() require("easy-dotnet").build_quickfix() end, desc = "build solution" },
            { "<leader>.netn", function() require("easy-dotnet").run_default() end, desc = "run" },
            { "<leader>.netR", function() require("easy-dotnet").run_solution() end, desc = "run solution" },
            { "<leader>.netx", function() require("easy-dotnet").clean() end, desc = "clean solution" },
            { "<leader>.neta", "<cmd>Dotnet new<cr>", desc = "new item" },
            { "<leader>.nett", "<cmd>Dotnet testrunner<cr>", desc = "open test runner" },
            -- stylua: ignore end
        },
    },
}
