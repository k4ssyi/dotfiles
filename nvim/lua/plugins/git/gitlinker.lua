--[[
GitLinker - GitリモートURL生成プラグイン設定

@概要
  - 現在の行や選択範囲のGitリモートURLを生成し、クリップボードにコピーまたはブラウザで開きます。
  - キーマップで簡単に呼び出し可能です。

@主な仕様
  - cmd: "GitLink" コマンドで起動
  - keys: <leader>gyでURLコピー、<leader>gYでブラウザで開く

@制限事項
  - 対応していないGitホスティングサービスもあります。

@参考
  - https://github.com/linrongbin16/gitlinker.nvim

]]

return {
  "linrongbin16/gitlinker.nvim",
  cmd = "GitLink",
  opts = {},
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
    { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
  },
}
