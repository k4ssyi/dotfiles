--[[
AstroCore - AstroNvimのコア設定モジュール

@概要
  - キーマッピング、Vimオプション、自動コマンドなどの中心的な設定を行うためのモジュールです。
  - 設定内容は `:h astrocore` でドキュメントを参照できます。
  - Lua言語サーバー（:LspInstall lua_ls）の導入を強く推奨します。これにより補完やドキュメント参照が可能になります。

@主な仕様
  - features: AstroNvimのコア機能の有効/無効化
  - diagnostics: 診断表示の設定
  - autocmds: 自動コマンドの設定
  - options: Vimオプションの一括設定
  - mappings: キーマッピングの一括設定
  - on_keys: キー入力時の関数実行設定
  - rooter: プロジェクトルート検出の設定
  - sessions: セッション管理の設定

@制限事項
  - 設定内容によっては他プラグインと競合する場合があります。
  - mapleader/maplocalleaderは `lua/lazy_setup.lua` で事前に設定してください。

  @参考
  - https://github.com/AstroNvim/AstroNvim
  - :h astrocore

]]

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- AstroNvimのコア機能設定
    features = require("config.core.features").features,
    -- 診断表示の設定（vim.diagnostics.config({...})に渡される）
    diagnostics = require("config.core.features").diagnostics,
    -- 自動コマンドの設定
    autocmds = require("config.core.autocmds"),
    -- Vimオプションの一括設定
    options = require("config.core.options"),
    -- キーマッピングの一括設定
    -- キーコードはvimドキュメントの表記に従い、大文字小文字を区別します（例: <Leader>）
    mappings = require("config.core.mappings"),
    -- キー入力時に実行する関数の設定
    on_keys = require("config.core.on_keys"),
    -- プロジェクトルート検出の設定（:AstroRootInfoで状態確認可能）
    rooter = require("config.core.rooter"),
    -- セッション管理（Resessionによる）の設定
    sessions = require("config.core.sessions"),
  },
}
