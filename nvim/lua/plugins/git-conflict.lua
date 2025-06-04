--[[
Git Conflict - Gitコンフリクト解決支援プラグイン設定

@概要
  - Gitマージ時のコンフリクト箇所をハイライトし、簡単に解決操作ができるようにします。
  - デフォルトのキーマッピングで各種操作が可能です。

@主な仕様
  - default_mappings: デフォルトのキーマッピング有効化
  - disable_diagnostics: コンフリクト中の診断表示制御
  - highlights: コンフリクト箇所のハイライトグループ指定

@制限事項
  - 設定内容によっては他のGitプラグインと競合する場合があります。

@参考
  - https://github.com/akinsho/git-conflict.nvim

]]

return {
  "akinsho/git-conflict.nvim",
  opts = function(_, opts)
    opts.default_mappings = true -- デフォルトのマッピングを有効にする
    opts.disable_diagnostics = false -- コンフリクト中の診断を無効にしない
    opts.highlights = { -- カスタムハイライトグループ
      incoming = "DiffText",
      current = "DiffAdd",
    }
  end,
}
