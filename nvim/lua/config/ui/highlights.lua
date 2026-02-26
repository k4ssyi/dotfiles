--[[
config/ui/highlights.lua - ハイライト設定

@概要
  - ハイライトグループのカスタマイズ（全カラースキーム共通）
  - telescopeやastrothemeテーマ用の色設定

@戻り値
  - AstroUIのhighlights設定に対応するテーブル

]]

return {
  init = function()
    -- catppuccin の telescope integration + transparent_background に委譲
    return {}
  end,
  astrodark = { -- astrothemeテーマ適用時の上書き・変更用テーブル
    -- Normal = { bg = "#000000" },
  },
}