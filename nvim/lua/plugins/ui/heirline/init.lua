--[[
heirline.nvim - ステータスライン・ウィンバー設定

@概要
  - heirlineプラグインの設定
  - カスタムステータスラインとウィンバーの定義

@主な仕様
  - winbar: カスタムウィンバー設定
  - statusline: カスタムステータスライン設定

@参考
  - https://github.com/rebelot/heirline.nvim

]]

return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    -- カスタムウィンバー設定
    opts.winbar = require "plugins.ui.heirline.config.winbar"()

    -- カスタムステータスライン設定
    opts.statusline = require "plugins.ui.heirline.config.statusline"()

    return opts
  end,
}
