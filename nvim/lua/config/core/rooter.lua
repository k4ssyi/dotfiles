--[[
config/rooter.lua - プロジェクトルート検出設定

@概要
  - AstroNvimのプロジェクトルート検出設定を管理します。
  - LSP、VCS、プロジェクトファイルによる検出ルールを定義します。

@戻り値
  - AstroCoreのrooter設定に対応するテーブル

]]

return {
  -- 優先順に検出方法をリスト
  detector = {
    "lsp", -- 最優先は稼働中のLSPからワークスペース取得
    { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- 次にバージョン管理ディレクトリを探索
    { "lua", "MakeFile", "package.json" }, -- 最後に既知のプロジェクトルートファイルを探索
  },
  -- ルート検出から除外するもの
  ignore = {
    servers = {}, -- 除外するLSPサーバー名リスト（例: { "efm" }）
    dirs = {}, -- 除外するディレクトリパターン（例: { "~/.cargo/*" }）
  },
  -- 作業ディレクトリを自動で更新（手動更新は:AstroRoot）
  autochdir = false,
  -- 作業ディレクトリの変更範囲（"global"|"tab"|"win"）
  scope = "global",
  -- 作業ディレクトリ変更時に毎回通知を表示
  notify = false,
}