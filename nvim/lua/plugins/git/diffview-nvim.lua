--[[
Diffview.nvim - Git差分ビューア上書き設定

@概要
  - AstroCommunityのdiffview-nvim設定を上書きします。
  - カスタムのUI設定とフックを追加します。

@基本設定
  - community.luaで "astrocommunity.git.diffview-nvim" をimport
  - ここでカスタム設定を上書き

@参考
  - https://github.com/sindrets/diffview.nvim

]]

return {
  "sindrets/diffview.nvim",
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
    hooks = { diff_buf_read = function(bufnr) vim.b[bufnr].view_activated = false end },
  },
}
