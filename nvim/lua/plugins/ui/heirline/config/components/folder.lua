--[[
config/ui/heirline/components/folder.lua - フォルダコンポーネント

@概要
  - 現在の作業ディレクトリ表示
  - フォルダアイコンと作業ディレクトリ名

@戻り値
  - heirlineのフォルダコンポーネント設定

]]

return function()
  local status = require "astroui.status"

  return {
    -- フォルダアイコン
    status.component.builder {
      { provider = require("astroui").get_icon "FolderClosed" },
      padding = { right = 1 },
      hl = { fg = "bg" },
      surround = {
        separator = "right",
        color = "folder_icon_bg",
      },
    },
    -- 作業ディレクトリ名
    status.component.file_info {
      filename = {
        fname = function(nr) return vim.fn.getcwd(nr) end,
        padding = { left = 1 },
      },
      filetype = false,
      file_icon = false,
      file_modified = false,
      file_read_only = false,
      surround = {
        separator = "none",
        color = "file_info_bg",
        condition = false,
      },
    },
  }
end
