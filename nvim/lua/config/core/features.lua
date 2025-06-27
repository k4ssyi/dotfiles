--[[
config/features.lua - AstroNvim機能設定

@概要
  - AstroNvimのコア機能の有効/無効を制御します。
  - 大容量ファイル設定、autopairs、補完、診断表示などを管理します。

@戻り値
  - AstroCoreのfeatures/diagnostics設定に対応するテーブル

]]

local M = {}

-- 基本機能設定
M.features = {
  large_buf = { size = 512 * 1024, lines = 10000 }, -- 闾値を低下（パフォーマンス向上） -- 大きなバッファの閾値（サイズ・行数）
  autopairs = true, -- 起動時に自動ペア補完を有効化
  cmp = true, -- 起動時に補完機能を有効化
  diagnostics_mode = 3, -- 仮想テキストなし -- 診断表示モード（0:無効, 1:サイン/仮想テキストなし, 2:仮想テキストなし, 3:全て表示）
  highlighturl = true, -- URLハイライトを無効化（パフォーマンス向上） -- 起動時にURLをハイライト
  notifications = true, -- 起動時に通知機能を有効化
}

-- 診断表示設定
M.diagnostics = {
  virtual_text = true, -- 無効化（パフォーマンス向上） -- 仮想テキストで診断を表示
  underline = true,
  update_in_insert = false, -- 挿入モード中の更新を無効化
  severity_sort = true, -- 下線で診断を表示
}

return M
