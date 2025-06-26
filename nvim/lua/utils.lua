--[[
utils.lua - 共通ユーティリティ関数

@概要
  - 複数のプラグイン設定で使用される共通の関数やヘルパーを提供します。
  - コードの重複を減らし、保守性を向上させます。

@主な機能
  - キーマップ作成のヘルパー関数
  - 設定値の定数定義
  - 共通の検証・チェック関数

@使用例
  local utils = require("utils")
  utils.map_keys(...)

]]

local M = {}

-- 定数定義
M.CONSTANTS = {
  TIMEOUT_MS = 1000,
  MAX_BUFFER_SIZE = 1024 * 1024,
  MAX_HISTORY_SIZE = 10000,
}

-- アイコン定義
M.ICONS = {
  SEPARATORS = {
    left = "",
    right = "",
  },
  GIT = {
    branch = "",
    added = "+",
    modified = "~",
    removed = "-",
  },
  DIAGNOSTICS = {
    error = "",
    warn = "",
    info = "",
    hint = "󰌵",
  },
}

-- キーマップ作成ヘルパー
-- @param mappings table キーマップ定義のテーブル
-- @param opts table オプション（バッファローカルなど）
function M.map_keys(mappings, opts)
  opts = opts or {}
  for mode, mode_mappings in pairs(mappings) do
    for key, mapping in pairs(mode_mappings) do
      local desc = mapping.desc or mapping[2]
      local cmd = mapping.cmd or mapping[1]
      vim.keymap.set(mode, key, cmd, vim.tbl_extend("force", opts, { desc = desc }))
    end
  end
end

-- 共通のライン移動キーマップ生成
function M.get_line_movement_mappings()
  return {
    n = {
      ["<C-a>"] = { "^", desc = "行の最初に移動" },
      ["<C-e>"] = { "$", desc = "行の最後に移動" },
    },
    i = {
      ["<C-a>"] = { "<Home>", desc = "行の最初に移動" },
      ["<C-e>"] = { "<End>", desc = "行の最後に移動" },
    },
    v = {
      ["<C-a>"] = { "^", desc = "行の最初に移動" },
      ["<C-e>"] = { "$", desc = "行の最後に移動" },
    },
  }
end

-- ファイル存在チェック
-- @param path string ファイルパス
-- @return boolean ファイルが存在するかどうか
function M.file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end

-- 設定値の安全なマージ
-- @param base table ベースとなる設定テーブル
-- @param override table 上書きする設定テーブル
-- @return table マージされた設定テーブル
function M.safe_merge(base, override)
  if not override then return base end
  return vim.tbl_deep_extend("force", base, override)
end

return M
