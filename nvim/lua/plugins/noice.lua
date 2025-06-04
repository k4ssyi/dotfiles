--[[
Noice - LSPメッセージUI拡張プラグイン

@概要
  - LSPのホバーやシグネチャヘルプなどのUIを拡張し、より見やすい表示にします。
  - 必要に応じてLSPのhoverやsignatureを無効化できます。

@主な仕様
  - lsp.hover.enabled: ホバーUIの有効/無効
  - lsp.signature.enabled: シグネチャUIの有効/無効

@制限事項
  - 他のLSP UI拡張プラグインと競合する場合があります。

@参考
  - https://github.com/folke/noice.nvim

]]

return {
  "folke/noice.nvim",
  config = function()
    require("noice").setup {
      lsp = {
        hover = {
          enabled = false,
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = false,
        },
      },
    }
  end,
}
