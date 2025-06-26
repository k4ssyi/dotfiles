--[[
config/lsp/server_config.lua - LSPサーバー個別設定

@概要
  - lspconfigに渡す言語サーバーの詳細設定

@戻り値
  - AstroLSPのconfig設定に対応するテーブル

]]

---@diagnostic disable: missing-fields
return {
  vtsls = {
    cmd = { "vtsls", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    settings = {
      vtsls = {
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
            entriesLimit = 10,
          },
        },
        autoUseWorkspaceTsdk = true,
      },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
        tsserver = {
          maxTsServerMemory = 8192,
        },
      },
    },
  },
}