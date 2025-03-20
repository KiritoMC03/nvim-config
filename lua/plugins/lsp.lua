return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
      opts = {
        automatic_installation = true,
        ensure_installed = {
          --"vtsls",
          --"eslint",
          --"html",
          --"cssls",
          --"svelte",
          --"tailwindcss",
          "lua_ls",
          --"jsonls",
          --"taplo",
          --"yamlls",
          "omnisharp",
          --"powershell_es",
          --"marksman",
          --"lemminx",
          --"rust_analyzer",
        },
      },
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = {
          --"prettier", -- prettier formatter
          --"rustywind", -- tailwind class sorter
          --"stylua", -- lua formatter
          "csharpier", -- c# formatter
          "netcoredbg", -- c# debugger
          "xmlformatter", -- xml formatter
        },
      },
    },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
    config = true,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
    config = true,
  },

  {
    "DNLHC/glance.nvim",
    event = "BufReadPre",
    config = true,
    keys = {
      { "gM", "<cmd>Glance implementations<cr>", desc = "Goto Implementations (Glance)" },
      { "gY", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition (Glance)" },
    },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require "mason-tool-installer"
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        --mason.setup()
        --mason_lspconfig.setup({
        --    ensure_installed = {
        --        "lua_ls",
        --        "omnisharp",
        --    },
        --    automatic_installation = true,
        --})

        local function on_attach(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
        end

        local capabilities = cmp_nvim_lsp.default_capabilities()

        mason_lspconfig.setup_handlers({
            function(server_name)
                if server_name == "omnisharp" then
                    lspconfig.omnisharp.setup({
                        cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settins = {
                            ["omnisharp"] = {
                                enableRoslynAnalyzers = true,
                                analyzeOpenDocumentsOnly = false,
                                useModernNet = true,
                            },
                        },
                    })
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                else
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end
            end,
        })

        lspconfig.omnisharp.setup {
            cmd = { "omnisharp" },
            root_dir = lspconfig.util.root_pattern("*.sln", "*.scproj"),
            on_attach = function(client, bufnr)
                local function buf_set_option(...) vim.api.nvim_bug_set_option(bufnr, ...) end
                buf_set_option("omnisharp", "omnisharp")
            end
        }
    end,
  },
}
