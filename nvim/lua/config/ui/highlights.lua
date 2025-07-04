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
    local get_hlgroup = require("astroui").get_hlgroup
    -- ハイライトグループから色を取得
    local normal = get_hlgroup "Normal"
    local fg, bg = normal.fg, normal.bg
    local bg_alt = get_hlgroup("Visual").bg
    local green = get_hlgroup("String").fg
    local red = get_hlgroup("Error").fg
    -- telescope用のハイライトテーブルを返す
    return {
      TelescopeBorder = { fg = bg_alt, bg = bg },
      TelescopeNormal = { bg = bg },
      TelescopePreviewBorder = { fg = bg, bg = bg },
      TelescopePreviewNormal = { bg = bg },
      TelescopePreviewTitle = { fg = bg, bg = green },
      TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
      TelescopePromptNormal = { fg = fg, bg = bg_alt },
      TelescopePromptPrefix = { fg = red, bg = bg_alt },
      TelescopePromptTitle = { fg = bg, bg = red },
      TelescopeResultsBorder = { fg = bg, bg = bg },
      TelescopeResultsNormal = { bg = bg },
      TelescopeResultsTitle = { fg = bg, bg = bg },
    }
  end,
  astrodark = { -- astrothemeテーマ適用時の上書き・変更用テーブル
    -- Normal = { bg = "#000000" },
  },
}