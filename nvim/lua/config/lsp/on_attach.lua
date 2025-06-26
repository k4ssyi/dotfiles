--[[
config/lsp/on_attach.lua - LSPアタッチ時処理

@概要
  - デフォルトの`on_attach`関数の後に実行されるカスタム`on_attach`関数

@戻り値
  - AstroLSPのon_attach設定に対応する関数

]]

-- カスタム`on_attach`関数
-- 2つのパラメータ`client`と`bufnr`を受け取る (`:h lspconfig-setup`)
return function(client, bufnr)
  -- これはすべてのクライアントでsemanticTokensProviderを無効化する例
  -- client.server_capabilities.semanticTokensProvider = nil
end