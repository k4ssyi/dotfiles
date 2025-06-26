--[[
nvim-treesitter - 構文解析/ハイライトプラグイン設定

@概要
  - 各種言語の構文解析・ハイライト・インデント・リファクタリング機能を提供します。
  - 必要なパーサーをensure_installedで指定できます。

@主な仕様
  - ensure_installed: インストールするパーサーのリスト
  - dependencies: playgroundやrefactor等の拡張

@制限事項
  - 一部の言語はパーサーが未対応の場合があります。

@参考
  - https://github.com/nvim-treesitter/nvim-treesitter

]]

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  opts = {
    ensure_installed = {
      -- add more arguments for adding more treesitter parsers
      "c",
      "lua",
      "luadoc",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "prisma",
      "python",
      "query",
      "sql",
      "toml",
      "tsv",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
}
