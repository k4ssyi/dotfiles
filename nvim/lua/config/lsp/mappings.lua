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
    grr = {
      function() require("snacks").picker.lsp_references() end,
      desc = "Search references",
      cond = "textDocument/references",
    },
    gd = {
      function() require("snacks").picker.lsp_definitions() end,
      desc = "Go to definition",
      cond = "textDocument/definition",
    },
    gri = {
      function() require("snacks").picker.lsp_implementations() end,
      desc = "Go to implementation",
      cond = "textDocument/implementation",
    },
    grt = {
      function() require("snacks").picker.lsp_type_definitions() end,
      desc = "Go to type definition",
      cond = "textDocument/typeDefinition",
    },
    ["<Leader>uY"] = {
      function() require("astrolsp.toggles").buffer_semantic_tokens() end,
      desc = "Toggle LSP semantic highlight (buffer)",
      cond = function(client)
        return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
      end,
    },
    ["<Leader>lG"] = {
      function() require("snacks").picker.lsp_workspace_symbols() end,
      desc = "Search workspace symbols",
    },
  },
}
