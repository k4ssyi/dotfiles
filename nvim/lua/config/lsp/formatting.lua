--[[
config/lsp/formatting.lua - LSPフォーマット設定

@概要
  - 保存時自動フォーマット、タイムアウト、無効化サーバー指定

@戻り値
  - AstroLSPのformatting設定に対応するテーブル

]]

return {
  -- 保存時自動フォーマット制御
  format_on_save = {
    enabled = true, -- 保存時フォーマットをグローバルで有効化
    allow_filetypes = { -- 指定したファイルタイプのみ保存時フォーマットを有効化
      -- "go",
    },
    ignore_filetypes = { -- 指定したファイルタイプの保存時フォーマットを無効化
      -- "python",
    },
  },
  disabled = { -- 指定した言語サーバーのフォーマット機能を無効化
    -- StyLuaを使ってluaコードをフォーマットしたい場合はlua_lsのフォーマット機能を無効化
    -- "lua_ls",
    -- TypeScript/JavaScript関連（Biome/Prettierに任せる）
    "tsserver",
    "vtsls",
    "pylsp",
  },
  timeout_ms = require("utils").CONSTANTS.TIMEOUT_MS * 10, -- デフォルトフォーマットタイムアウト（10秒）
  -- filter = function(client) -- デフォルトフォーマット関数を完全に上書き
  --   return true
  -- end
}