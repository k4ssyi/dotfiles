--[[
config/lsp/server_config.lua - LSPサーバー個別設定

@概要
  - lspconfigに渡す言語サーバーの詳細設定

@戻り値
  - AstroLSPのconfig設定に対応するテーブル

]]

local util = require("lspconfig.util")

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
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
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

  -- root_dir + single_file_support=false でbiome.jsonの祖先を持つファイルにのみアタッチ
  biome = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
    },
    root_dir = util.root_pattern("biome.json", "biome.jsonc"),
    single_file_support = false,
    -- monorepo対応: root_dirからローカルbiomeバイナリを優先解決
    on_new_config = function(new_config, new_root_dir)
      local local_biome = new_root_dir .. "/node_modules/.bin/biome"
      if vim.uv.fs_stat(local_biome) then new_config.cmd = { local_biome, "lsp-proxy" } end
    end,
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
    root_dir = util.root_pattern(
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
      "eslint.config.cts"
    ),
    single_file_support = false,
    settings = {
      format = false, -- Prettierに任せる
      workingDirectories = { mode = "auto" },
    },
  },
}