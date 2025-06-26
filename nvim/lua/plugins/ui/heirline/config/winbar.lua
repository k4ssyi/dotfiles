--[[
config/ui/heirline/winbar.lua - Winbar設定

@概要
  - heirlineのwinbar（ウィンドウバー）設定
  - アクティブ/非アクティブ状態での表示制御

@戻り値
  - heirlineのwinbar設定テーブル

]]

local function create_winbar_config()
  local status = require "astroui.status"

  return {
    -- 現在のバッファ番号を保存
    init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
    fallthrough = false, -- 条件に基づいて正しいwinbarを選択

    -- 非アクティブwinbar
    {
      condition = function() return not status.condition.is_active() end,
      -- 作業ディレクトリからの相対パスを表示
      status.component.separated_path {
        path_func = status.provider.filename { modify = ":.:h" },
      },
      -- ファイル名とアイコンを追加
      status.component.file_info {
        file_icon = {
          hl = status.hl.file_icon "winbar",
          padding = { left = 0 },
        },
        filename = {},
        filetype = false,
        file_modified = false,
        file_read_only = false,
        hl = status.hl.get_attributes("winbarnc", true),
        surround = false,
        update = "BufEnter",
      },
    },
    -- アクティブwinbar
    {
      -- 作業ディレクトリからの相対パスを表示
      status.component.separated_path {
        path_func = status.provider.filename { modify = ":.:h" },
      },
      -- ファイル名とアイコンを追加
      status.component.file_info {
        file_icon = {
          hl = status.hl.filetype_color,
          padding = { left = 0 },
        },
        filename = {},
        filetype = false,
        file_modified = false,
        file_read_only = false,
        hl = status.hl.get_attributes("winbar", true),
        surround = false,
        update = "BufEnter",
      },
      -- パンくずリストを表示
      status.component.breadcrumbs {
        icon = { hl = true },
        hl = status.hl.get_attributes("winbar", true),
        prefix = true,
        padding = { left = 0 },
      },
    },
  }
end

return create_winbar_config
