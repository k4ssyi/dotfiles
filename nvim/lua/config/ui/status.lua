--[[
config/ui/status.lua - ステータスライン設定

@概要
  - heirlineで直接定義されていない変数のカスタマイズ
  - セパレータ、色、属性、アイコンハイライトの設定

@戻り値
  - AstroUIのstatus設定に対応するテーブル

]]

local utils = require("utils")

return {
  -- 各セクション間のセパレータ定義（utils.luaから取得）
  separators = {
    left = { utils.ICONS.SEPARATORS.left, "" }, -- ステータスライン左側のセパレータ
    right = { " ", utils.ICONS.SEPARATORS.right }, -- ステータスライン右側のセパレータ
    tab = { "", "" },
  },
  -- heirlineで使用可能な新しい色の追加
  colors = function(hl)
    local get_hlgroup = require("astroui").get_hlgroup
    -- ハイライトグループのプロパティ取得用ヘルパー関数を利用
    local comment_fg = get_hlgroup("Comment").fg
    hl.git_branch_fg = comment_fg
    hl.git_added = comment_fg
    hl.git_changed = comment_fg
    hl.git_removed = comment_fg
    hl.blank_bg = get_hlgroup("Folded").fg
    hl.file_info_bg = get_hlgroup("Visual").bg
    hl.nav_icon_bg = get_hlgroup("String").fg
    hl.nav_fg = hl.nav_icon_bg
    hl.folder_icon_bg = get_hlgroup("Error").fg
    return hl
  end,
  attributes = {
    mode = { bold = true },
  },
  icon_highlights = {
    file_icon = {
      statusline = false,
    },
  },
}