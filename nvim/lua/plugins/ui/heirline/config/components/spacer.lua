--[[
config/ui/heirline/components/spacer.lua - スペーサーコンポーネント

@概要
  - 空白セクション用のコンポーネント
  - セクション間の視覚的分離

@戻り値
  - heirlineの空白コンポーネント設定

]]

return function()
  local status = require "astroui.status"

  return status.component.builder {
    { provider = "" },
    -- セパレータと色の定義
    surround = {
      separator = "left",
      color = {
        main = "blank_bg",
        right = "file_info_bg",
      },
    },
  }
end
