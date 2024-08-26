-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        -- add more arguments for adding more language servers
        "typos_lsp",
        "bashls",
        "yamlls",
        "tsserver",
        "docker_compose_language_service",
        "dockerls",
        "html",
        "jsonls",
        "prismals",
        "sqlls",
        "vimls",
        "biome",
        "pylsp",
      },
      settings = {
        ["pylsp"] = {
          codeLens = { enable = true },
        },
        ["tsserver"] = {
          codeLens = { enable = true },
        },
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        -- add more arguments for adding more null-ls sources
        "gitlint",
        "shellcheck",
        "jsonlint",
        "markdownlint",
        "yamllint",
        "fixjson",
        "biome",
        "jq",
        "flake8",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        -- add more arguments for adding more debuggers
        -- "python",
      },
    },
  },
}
