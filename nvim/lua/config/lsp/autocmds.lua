--[[
config/lsp/autocmds.lua - LSP自動コマンド設定

@概要
  - LSPアタッチ時のバッファローカル自動コマンド設定

@戻り値
  - AstroLSPのautocmds設定に対応するテーブル

]]

return {
  -- 最初のキーはaugroup名 (:h augroup)
  lsp_document_highlight = {
    -- 自動コマンドグループを作成/削除する条件
    -- クライアント機能の文字列か、`fun(client, bufnr): boolean`の関数を指定可能
    -- 条件は各クライアントの各実行時に解決され、すべてのクライアントで失敗した場合、
    -- そのバッファの自動コマンドが削除される
    cond = "textDocument/documentHighlight",
    -- 設定する自動コマンドのリスト
    {
      -- トリガーするイベント
      event = { "CursorHold", "CursorHoldI" },
      -- 残りはautocmdオプション (:h nvim_create_autocmd)
      desc = "Document Highlighting",
      callback = function() vim.lsp.buf.document_highlight() end,
    },
    {
      event = { "CursorMoved", "CursorMovedI", "BufLeave" },
      desc = "Document Highlighting Clear",
      callback = function() vim.lsp.buf.clear_references() end,
    },
  },
}