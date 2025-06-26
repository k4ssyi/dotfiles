--[[
Noice - LSPメッセージUI上書き設定

@概要
  - AstroCommunityのnoice-nvim設定を上書きします。
  - LSPのhoverとsignatureを無効化します。

@基本設定
  - community.luaで "astrocommunity.utility.noice-nvim" をimport
  - ここでカスタム設定を上書き

@参考
  - https://github.com/folke/noice.nvim

]]

return {
  "folke/noice.nvim",
  opts = {
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
  },
}
