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
    handlers = require "config.lsp.handlers",
    -- 言語サーバーアタッチ時に追加するバッファローカル自動コマンドの設定
    autocmds = require "config.lsp.autocmds",
    -- 言語サーバーのアタッチ時に設定されるマッピング
    mappings = require "config.lsp.mappings",
    -- デフォルトの`on_attach`関数の後に実行されるカスタム`on_attach`関数
    -- 2つのパラメータ`client`と`bufnr`を受け取る (`:h lspconfig-setup`)
    on_attach = require "config.lsp.on_attach",
  },
}
