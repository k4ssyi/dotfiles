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
    root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
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

  -- root_markers + workspace_required でbiome.jsonの祖先を持つファイルにのみアタッチ
  biome = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
    },
    root_markers = { "biome.json", "biome.jsonc" },
    workspace_required = true,
  },

  -- package.jsonを含めるとbiomeプロジェクトにもアタッチするため、eslint設定ファイルのみ指定
  eslint = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    root_markers = {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.mjs",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
    },
    workspace_required = true,
    settings = {
      format = false,
      workingDirectories = { mode = "auto" },
    },
  },
}