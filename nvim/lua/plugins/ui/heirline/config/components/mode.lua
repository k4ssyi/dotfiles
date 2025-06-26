--[[
config/ui/heirline/components/mode.lua - モードコンポーネント

@概要
  - Vimモード表示コンポーネント
  - アイコンとテキスト付きモード表示

@戻り値
  - heirlineのmodeコンポーネント設定

]]

return function()
  local status = require "astroui.status"

  return status.component.mode {
    -- アイコンとパディング付きのモードテキストを有効化
    mode_text = {
      icon = {
        kind = "VimIcon",
        padding = { right = 1, left = 1 },
      },
    },
    -- コンポーネントをセパレータで囲む
    surround = {
      -- 左側要素なので左セパレータを使用
      separator = "left",
      -- 現在のモードに基づいて色を設定
      color = function()
        return {
          main = status.hl.mode_bg(),
          right = "blank_bg",
        }
      end,
    },
  }
end
