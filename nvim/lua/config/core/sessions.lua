--[[
config/sessions.lua - セッション管理設定

@概要
  - AstroNvimのセッション管理（Resession）設定を管理します。
  - 自動保存設定と除外パターンを定義します。

@戻り値
  - AstroCoreのsessions設定に対応するテーブル

]]

return {
  -- 自動保存の設定
  autosave = {
    last = true, -- 最後のセッションを自動保存
    cwd = true, -- 作業ディレクトリごとにセッションを自動保存
  },
  -- セッション保存時に無視するパターン
  ignore = {
    dirs = {}, -- セッションを無視する作業ディレクトリ
    filetypes = { "gitcommit", "gitrebase" }, -- セッションを無視するファイルタイプ
    buftypes = {}, -- セッションを無視するバッファタイプ
  },
}