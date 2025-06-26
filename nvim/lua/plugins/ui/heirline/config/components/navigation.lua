--[[
config/ui/heirline/components/navigation.lua - ナビゲーションコンポーネント

@概要
  - ファイル内ナビゲーション情報
  - スクロールアイコン、Treesitter情報、進行状況

@戻り値
  - heirlineのナビゲーションコンポーネント設定

]]

return function()
  local status = require "astroui.status"

  return {
    -- スクロールアイコン
    status.component.builder {
      { provider = require("astroui").get_icon "ScrollText" },
      padding = { right = 1 },
      hl = { fg = "bg" },
      surround = {
        separator = "right",
        color = {
          main = "nav_icon_bg",
          left = "file_info_bg",
        },
      },
    },
    -- Treesitter情報
    status.component.treesitter(),
    -- ナビゲーション情報（パーセンテージ表示）
    status.component.nav {
      percentage = { padding = { right = 1 } },
      ruler = false,
      scrollbar = false,
      surround = {
        separator = "none",
        color = "file_info_bg",
      },
    },
  }
end
