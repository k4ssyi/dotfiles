--[[
config/lsp/mappings.lua - LSPキーマッピング設定

@概要
  - 言語サーバーアタッチ時に設定されるキーマッピング

@戻り値
  - AstroLSPのmappings設定に対応するテーブル

]]

return {
  n = {
    gD = {
      function() vim.lsp.buf.declaration() end,
      desc = "Declaration of current symbol",
      cond = "textDocument/declaration",
    },
    ["<Leader>uY"] = {
      function() require("astrolsp.toggles").buffer_semantic_tokens() end,
      desc = "Toggle LSP semantic highlight (buffer)",
      cond = function(client)
        return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
      end,
    },
    ["<Leader>lG"] = {
      function() Snacks.picker.lsp_workspace_symbols() end,
      desc = "Search workspace symbols",
    },
  },
}
