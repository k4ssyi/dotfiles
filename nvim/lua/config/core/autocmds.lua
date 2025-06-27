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

  -- 大きいファイルのパフォーマンス最適化
  large_file_optimizations = {
    {
      event = { "BufEnter", "BufWinEnter" },
      desc = "大きいファイル用のパフォーマンス最適化",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        local file_size = vim.fn.getfsize(vim.fn.expand "%")

        -- 5000行または1MB以上のファイルで最適化を適用
        if line_count > 5000 or file_size > 1024 * 1024 then
          -- スムーススクロールの速度を上げる
          vim.b.neoscroll_performance_mode = true

          -- シンタックスハイライトを簡略化（必要に応じて）
          vim.opt_local.synmaxcol = 200 -- 長い行のハイライトを制限

          -- ステータスラインにパフォーマンスモードを表示
          vim.notify("大きいファイルを検出: パフォーマンス最適化を適用", vim.log.levels.INFO)
        end
      end,
    },
  },
}
