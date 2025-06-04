--[[
Diffview.nvim - Git差分ビューアプラグイン設定

@概要
  - Gitの差分や履歴を専用ウィンドウで可視化します。
  - コマンドやイベントで差分ビューを起動できます。

@主な仕様
  - event: "User AstroGitFile" でGitファイル操作時に有効化
  - cmd: "DiffviewOpen" コマンドで起動
  - view: winbar_info等のUIカスタマイズ

@制限事項
  - 別途diffview.nvimのインストールが必要です。

@参考
  - https://github.com/sindrets/diffview.nvim

]]

return {
  {
    "sindrets/diffview.nvim",
    event = "User AstroGitFile",
    cmd = { "DiffviewOpen" },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { winbar_info = true },
        file_history = { winbar_info = true },
      },
      hooks = { diff_buf_read = function(bufnr) vim.b[bufnr].view_activated = false end },
    },
  },
}
