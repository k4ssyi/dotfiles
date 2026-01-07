--[[
AstroLSP - AstroNvimのLSP設定エンジン拡張

@概要
  - LSP（Language Server Protocol）機能の詳細なカスタマイズを提供します。
  - フォーマット、サーバー設定、マッピング、autocmd、on_attach等を柔軟に制御できます。

@主な仕様
  - features: コードレンズ・インレイヒント・セマンティックトークン等の有効/無効
  - formatting: 保存時自動フォーマットやタイムアウト、無効化サーバー指定
  - servers: mason未使用サーバーの手動有効化
  - config: lspconfigに渡す詳細設定
  - handlers: サーバーごとのカスタムセットアップ
  - autocmds: LSPアタッチ時の自動コマンド
  - mappings: LSP関連のキーマッピング
  - on_attach: LSPアタッチ時の追加処理

@制限事項
  - 設定内容によっては他のLSPプラグインやツールと競合する場合があります。

@参考
  - https://github.com/AstroNvim/AstroNvim

]]

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- AstroLSPが提供する機能の設定テーブル
    features = require "config.lsp.features",
    -- LSPフォーマットオプションのカスタマイズ
    formatting = require "config.lsp.formatting",
    -- mason未使用でインストール済みのサーバーを有効化
    servers = require "config.lsp.servers",
    -- `lspconfig`に渡す言語サーバー設定オプションのカスタマイズ
    config = require "config.lsp.server_config",
    -- 言語サーバーのカスタムセットアップ方法
    handlers = {
      -- キーなしの関数は単純にデフォルトハンドラー、関数は2つのパラメータ（サーバー名と設定されたオプションテーブル）を受け取る
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- キーは`lspconfig`でセットアップされるサーバー
      -- rust_analyzer = false, -- ハンドラーをfalseに設定すると、その言語サーバーのセットアップが無効化される
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- カスタムハンドラー関数を渡すことも可能

      -- Biome: biome.json/biome.jsonc がある場合のみ有効化
      biome = function(_, opts)
        local has_biome_config = vim.fn.filereadable(vim.fn.getcwd() .. "/biome.json") == 1
          or vim.fn.filereadable(vim.fn.getcwd() .. "/biome.jsonc") == 1

        if has_biome_config then
          ---@diagnostic disable-next-line: param-type-mismatch
          require("lspconfig").biome.setup(opts)
        end
      end,

      -- ESLint: Biomeがなく、ESLint設定ファイルがある場合のみ有効化
      eslint = function(_, opts)
        local has_biome_config = vim.fn.filereadable(vim.fn.getcwd() .. "/biome.json") == 1
          or vim.fn.filereadable(vim.fn.getcwd() .. "/biome.jsonc") == 1

        -- Biomeがある場合はESLintを無効化
        if has_biome_config then return end

        -- ESLint設定ファイルを確認
        local eslint_configs = {
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
        }

        for _, config in ipairs(eslint_configs) do
          if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. config) == 1 then
            ---@diagnostic disable-next-line: param-type-mismatch
            require("lspconfig").eslint.setup(opts)
            return
          end
        end
      end,
    },
    -- 言語サーバーアタッチ時に追加するバッファローカル自動コマンドの設定
    autocmds = require "config.lsp.autocmds",
    -- 言語サーバーのアタッチ時に設定されるマッピング
    mappings = require "config.lsp.mappings",
    -- デフォルトの`on_attach`関数の後に実行されるカスタム`on_attach`関数
    -- 2つのパラメータ`client`と`bufnr`を受け取る (`:h lspconfig-setup`)
    on_attach = require "config.lsp.on_attach",
  },
}
