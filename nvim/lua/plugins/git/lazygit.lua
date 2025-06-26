--[[
LazyGit - ターミナルGitクライアント連携プラグイン

@概要
  - NeovimからLazyGit（ターミナルGitクライアント）を起動できるプラグインです。
  - コマンドやイベントでLazyGitを呼び出せます。

@主な仕様
  - event: "User AstroGitFile" でGitファイル操作時に有効化

@制限事項
  - 別途lazygitコマンドのインストールが必要です。
  - AstroCommunityに対応するパックが存在しないため、個別設定として維持

@参考
  - https://github.com/kdheepak/lazygit.nvim

]]

return {
  {
    "kdheepak/lazygit.nvim",
    event = "User AstroGitFile",
  },
}
