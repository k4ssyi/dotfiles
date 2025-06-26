--[[
config/lsp/mappings.lua - LSPキーマッピング設定

@概要
  - 言語サーバーアタッチ時に設定されるキーマッピング

@戻り値
  - AstroLSPのmappings設定に対応するテーブル

]]

return {
  n = {
    -- `cond`キーでサーバー機能の文字列を指定してアタッチ要件とするか、
    -- `on_attach`の`client`と`bufnr`パラメータを使った関数でbooleanを返すことが可能
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
    gd = {
      function() require("telescope.builtin").lsp_definitions { reuse_win = true } end,
      desc = "Go to definition",
    },
    gI = {
      function() require("telescope.builtin").lsp_implementations { reuse_win = true } end,
      desc = "Go to implementation",
    },
    gy = {
      function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end,
      desc = "Go to type definition",
    },
    gr = {
      function() require("telescope.builtin").lsp_references() end,
      desc = "List references",
    },
    ["<Leader>lG"] = {
      function()
        vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
          if query then
            -- クエリが空の場合はカーソル下の単語を使用
            if query == "" then query = vim.fn.expand "<cword>" end
            require("telescope.builtin").lsp_workspace_symbols {
              query = query,
              prompt_title = ("Find word (%s)"):format(query),
            }
          end
        end)
      end,
      desc = "Search workspace symbols",
    },
  },
}