return {
  {
    "williamboman/mason.nvim",
    ensure_installed = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- C# stuff
      "omnisharp",
      "csharpier",

      -- HTML
      "prettier",

      -- xml stuff
      "xmlformat",

      -- yaml
      "yamlfix",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
}
