--[[
TypeScript開発支援プラグイン設定

@概要
  - TypeScript開発に特化した追加機能を提供します。
  - ファイル操作時の自動インポート更新など、開発効率を向上させる機能が含まれます。

@主な機能
  - ファイルリネーム/移動時のインポートパス自動更新
  - プロジェクト内の参照更新

@制限事項
  - LSPサーバー（vtsls）が正常に動作している必要があります。

@参考
  - https://github.com/antosha417/nvim-lsp-file-operations

]]

return {
  -- ファイル操作時のインポート自動更新
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/oil.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}