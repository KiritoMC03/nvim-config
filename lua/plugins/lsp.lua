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
    opts = {
      ensure_installed = {
        "eslint_d",
        "isort",
        "luacheck",
        "prettierd",
        "prosemd-lsp",
        "ruff",
        "selene",
        "shellcheck",
        "shfmt",
        "stylua",
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
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
        keys = {
          { "<leader>cln", "<cmd>Navbuddy<cr>", desc = "Lsp Navigation" },
        },
      },
    },
    -- init = function()
    --   local keys = require("lazyvim.plugins.lsp.keymaps").get()

    --   -- move cl to cli
    --   keys[#keys + 1] = { "<leader>cl", false }
    --   keys[#keys + 1] = { "<leader>cli", "<cmd>LspInfo<cr>", desc = "LspInfo" }

    --   -- add more lsp keymaps
    --   keys[#keys + 1] = { "<leader>cla", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" }
    --   keys[#keys + 1] = { "<leader>clr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" }
    --   keys[#keys + 1] = {
    --     "<leader>cll",
    --     "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
    --     desc = "List Folders",
    --   }
    --   keys[#keys + 1] = { "<leader>clh", vim.lsp.codelens.run, desc = "Run Code Lens" }
    --   keys[#keys + 1] = { "<leader>cld", vim.lsp.codelens.refresh, desc = "Refresh Code Lens" }
    --   keys[#keys + 1] = { "<leader>cls", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }

    --   require("which-key").register({
    --     ["<leader>cl"] = { name = "+lsp" },
    --   })

    --   local format = require("lazyvim.plugins.lsp.format")
    --   ---@diagnostic disable-next-line: duplicate-set-field
    --   format.on_attach = function(client, buf)
    --     if client.supports_method("textDocument/formatting") then
    --       vim.api.nvim_create_autocmd("BufWritePre", {
    --         group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
    --         buffer = buf,
    --         callback = function()
    --           if format.autoformat then
    --             format.format()
    --           end
    --         end,
    --       })
    --     end

    --     if client.supports_method("textDocument/codeLens") then
    --       vim.cmd([[
		-- 				augroup lsp_document_codelens
		-- 					au! * <buffer>
		-- 					autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
		-- 					autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
		-- 				augroup END
		-- 			]])
    --     end
    --   end
    -- end,
    -- opts = {
    --   ---@type lspconfig.options
    --   servers = {
    --     ansiblels = {},
    --     asm_lsp = {},
    --     bashls = {},
    --     cmake = {},
    --     cssls = {},
    --     html = {},
    --     -- lua_ls = {
    --     --   single_file_support = true,
    --     --   ---@type lspconfig.settings.lua_ls
    --     --   settings = {
    --     --     Lua = {
    --     --       workspace = {
    --     --         checkThirdParty = false,
    --     --       },
    --     --       completion = {
    --     --         workspaceWord = true,
    --     --         callSnippet = "Both",
    --     --       },
    --     --       misc = {
    --     --         parameters = {
    --     --           "--log-level=trace",
    --     --         },
    --     --       },
    --     --       diagnostics = {
    --     --         -- enable = false,
    --     --         groupSeverity = {
    --     --           strong = "Warning",
    --     --           strict = "Warning",
    --     --         },
    --     --         groupFileStatus = {
    --     --           ["ambiguity"] = "Opened",
    --     --           ["await"] = "Opened",
    --     --           ["codestyle"] = "None",
    --     --           ["duplicate"] = "Opened",
    --     --           ["global"] = "Opened",
    --     --           ["luadoc"] = "Opened",
    --     --           ["redefined"] = "Opened",
    --     --           ["strict"] = "Opened",
    --     --           ["strong"] = "Opened",
    --     --           ["type-check"] = "Opened",
    --     --           ["unbalanced"] = "Opened",
    --     --           ["unused"] = "Opened",
    --     --         },
    --     --         unusedLocalExclude = { "_*" },
    --     --       },
    --     --       format = {
    --     --         enable = false,
    --     --         defaultConfig = {
    --     --           indent_style = "tab",
    --     --           indent_size = "4",
    --     --           continuation_indent_size = "4",
    --     --         },
    --     --       },
    --     --     },
    --     --   },
    --     -- },
    --     marksman = {},
    --     omnisharp = {},
    --     prosemd_lsp = {},
    --     pyright = {},
    --     teal_ls = {},
    --     texlab = {},
    --     -- tsserver = {
    --     --   settings = {
    --     --     typescript = {
    --     --       inlayHints = {
    --     --         includeInlayParameterNameHints = "literal",
    --     --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --     --         includeInlayFunctionParameterTypeHints = false,
    --     --         includeInlayVariableTypeHints = false,
    --     --         includeInlayPropertyDeclarationTypeHints = false,
    --     --         includeInlayFunctionLikeReturnTypeHints = true,
    --     --         includeInlayEnumMemberValueHints = true,
    --     --       },
    --     --     },
    --     --     javascript = {
    --     --       inlayHints = {
    --     --         includeInlayParameterNameHints = "all",
    --     --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --     --         includeInlayFunctionParameterTypeHints = true,
    --     --         includeInlayVariableTypeHints = true,
    --     --         includeInlayPropertyDeclarationTypeHints = true,
    --     --         includeInlayFunctionLikeReturnTypeHints = true,
    --     --         includeInlayEnumMemberValueHints = true,
    --     --       },
    --     --     },
    --     --   },
    --     -- },
    --     vala_ls = {},
    --     vimls = {},
    --     -- yamlls = {
    --     --   settings = {
    --     --     yaml = {
    --     --       customTags = {
    --     --         "!reference sequence", -- necessary for gitlab-ci.yaml files
    --     --       },
    --     --     },
    --     --   },
    --     -- },
    --     zls = {},
    --   },
    --   setup = {},
    -- },
  },
}
