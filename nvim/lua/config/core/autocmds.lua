--[[
config/autocmds.lua - 自動コマンド設定

@概要
  - AstroCore用の自動コマンド設定を管理します。
  - URLハイライトなどの自動実行コマンドを定義します。

@戻り値
  - AstroCoreのautocmds設定に対応するテーブル

]]

return {
  -- 最初のキーはaugroup名
  highlighturl = {
    -- 設定する自動コマンドのリスト
    {
      -- トリガーとなるイベント
      event = { "VimEnter", "FileType", "BufEnter", "WinEnter" },
      -- その他のautocmdオプション
      desc = "URLハイライト",
      callback = function() require("astrocore").set_url_match() end,
    },
  },
}
