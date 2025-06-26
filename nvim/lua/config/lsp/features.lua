--[[
config/lsp/features.lua - LSP機能設定

@概要
  - LSPの各種機能（コードレンズ、インレイヒント、セマンティックトークン）の有効化設定

@戻り値
  - AstroLSPのfeatures設定に対応するテーブル

]]

return {
  codelens = true, -- コードレンズのリフレッシュを有効化
  inlay_hints = false, -- インレイヒントを無効化
  semantic_tokens = true, -- セマンティックトークンハイライトを有効化
}