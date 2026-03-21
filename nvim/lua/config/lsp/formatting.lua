--[[
config/lsp/formatting.lua - LSPフォーマット設定

@概要
  - 保存時自動フォーマット、タイムアウト、無効化サーバー指定

@戻り値
  - AstroLSPのformatting設定に対応するテーブル

]]

return {
  -- 保存時フォーマットはカスタムBufWritePre autocmd（autocmds.lua）で一元管理
  -- AstroLSPのformat_on_saveは無効化し、二重フォーマットを防止
  format_on_save = {
    enabled = false,
  },
  timeout_ms = require("utils").CONSTANTS.TIMEOUT_MS * 10, -- デフォルトフォーマットタイムアウト（10秒）
}
