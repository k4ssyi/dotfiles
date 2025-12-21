--[[
Oil-git-status.nvim - Oil.nvimのGit統合プラグイン

@概要
  - oil.nvimでgit statusを表示するプラグイン
  - signカラムにgitの変更状態を表示

@参考
  - https://github.com/refractalize/oil-git-status.nvim

]]

return {
  "refractalize/oil-git-status.nvim",
  dependencies = {
    "stevearc/oil.nvim",
  },
  config = function()
    require("oil-git-status").setup()
  end,
}
