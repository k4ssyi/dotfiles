--[[
Mason - LSP/フォーマッタ/デバッガ自動インストール管理プラグイン設定

@概要
  - LSPサーバー、フォーマッタ、リンター、デバッガの自動インストール・管理を行います。
  - mason-lspconfig, mason-null-ls, mason-nvim-dapの各拡張を利用します。

@主な仕様
  - ensure_installed: インストール対象のサーバー・ツールリスト
  - settings: LSPサーバーごとの追加設定
  - 各拡張ごとに個別のoptsで詳細設定可能

@制限事項
  - 一部のツールはmason経由でインストールできない場合があります。

@参考
  - https://github.com/williamboman/mason.nvim

]]

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
        "vtsls",
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
