--[[
config/ui/heirline/components/file_info.lua - ファイル情報コンポーネント

@概要
  - 現在開いているファイルの情報表示
  - ファイルアイコンと相対パス

@戻り値
  - heirlineのファイル情報コンポーネント設定

]]

return function()
  local status = require "astroui.status"

  return status.component.builder {
    {
      -- ファイルアイコンプロバイダー
      provider = function()
        local icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
        return icon and (icon .. " ") or ""
      end,
      hl = { fg = "fg", bg = "bg" },
      padding = { right = 1 },
    },
    {
      -- ファイルパスプロバイダー
      provider = function()
        local fullpath = vim.fn.expand "%:p"
        local relative_path = vim.fn.fnamemodify(fullpath, ":~:")
        return relative_path
      end,
      hl = { fg = "fg", bg = "bg", bold = true },
    },
    surround = {
      separator = "left",
      color = {
        main = "file_info_bg",
        right = "file_info_bg",
      },
    },
  }
end
