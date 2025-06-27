--[[
lazy_setup.lua - AstroNvim/Lazy.nvim初期化・設定ファイル

@概要
  - Lazy.nvimのセットアップとAstroNvim本体・community・pluginsディレクトリのプラグイン仕様を読み込みます。
  - leader/localleaderやアイコン有効化などのグローバルオプションもここで指定します。

@主な仕様
  - import: AstroNvim本体・community・pluginsの順でimport
  - opts: mapleader, maplocalleader, icons_enabled等のグローバル設定
  - install: デフォルトカラースキーム指定
  - performance: rtpプラグインの無効化

@制限事項
  - 設定内容によっては他のプラグインやユーザー設定と競合する場合があります。

@参考
  - https://github.com/folke/lazy.nvim
  - https://github.com/AstroNvim/AstroNvim

]]

require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^4", -- バージョン固定を解除するとnightly版AstroNvimを利用可能
    import = "astronvim.plugins",
    opts = { -- AstroNvimのグローバルオプション
      mapleader = " ", -- leaderキーの設定（Lazyセットアップ前に必須）
      maplocalleader = ",", -- localleaderキーの設定（Lazyセットアップ前に必須）
      icons_enabled = true, -- アイコン有効化（Nerd Font未導入時はfalse推奨）
      pin_plugins = nil, -- デフォルトはAstroNvimのバージョン追従時にプラグインをpin
      update_notifications = true, -- :Lazy update実行時の通知有無
    },
  },
  { import = "config" },
  { import = "community" },
  { import = "plugins.git" },
  { import = "plugins.editor" },
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.ui.heirline" },
} --[[@as LazySpec]], {
  -- その他のlazy.nvim設定
  install = { colorscheme = { "astrotheme" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      -- 無効化するrtpプラグイン（パフォーマンス最適化）
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
        "matchit", -- マッチングプラグイン
        "matchparen", -- 括弧マッチング
        "logiPat", -- ロジカルパターン
        "rrhelper", -- リモートヘルプ
        "spellfile_plugin", -- スペルファイルプラグイン
        "getscript", -- スクリプト取得
        "getscriptPlugin", -- スクリプト取得プラグイン
        "vimball", -- vimball
        "vimballPlugin", -- vimballプラグイン
        "2html_plugin", -- HTML変換
        "tutor_mode_plugin", -- チュートリアル
      },
    },
    -- モジュールキャッシュを有効化
    cache = {
      enabled = true,
    },
    -- プラグインの遅延読み込みを有効化
    reset_packpath = true,
  },
} --[[@as LazyConfig]])
