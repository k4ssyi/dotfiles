--[[
config/mappings.lua - キーマッピング設定

@概要
  - AstroNvimのキーマッピング設定を管理します。
  - モード別にキーマッピングを定義します。

@戻り値
  - AstroCoreのmappings設定に対応するテーブル

]]

local utils = require("utils")

-- 基本的なライン移動マッピングをutils.luaから取得
local base_mappings = utils.get_line_movement_mappings()

-- カスタムマッピングを追加
local custom_mappings = {
  -- ノーマルモード
  n = {
    -- 分割ウィンドウのリサイズ（Altキー）
    ["<A-j>"] = { ":resize +2<CR>", desc = "ウィンドウを上に拡大" },
    ["<A-k>"] = { ":resize -2<CR>", desc = "ウィンドウを下に縮小" },
    ["<A-l>"] = { ":vertical resize +2<CR>", desc = "ウィンドウを右に拡大" },
    ["<A-h>"] = { ":vertical resize -2<CR>", desc = "ウィンドウを左に縮小" },

    -- xでヤンクしない
    x = { '"_x', desc = "xでヤンクしない" },

    -- 分割ウィンドウ
    ["\\"] = { "<cmd>vsplit<cr>", desc = "縦分割" },
    ["-"] = { "<cmd>split<cr>", desc = "横分割" },

    -- バッファタブの移動
    ["L"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "次のバッファへ" },
    ["H"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "前のバッファへ" },

    -- "Buffer"グループのマッピング
    ["<Leader>bd"] = {
      function()
        require("astroui.status.heirline").buffer_picker(
          function(bufnr) require("astrocore.buffer").close(bufnr) end
        )
      end,
      desc = "タブラインからバッファを閉じる",
    },
    -- プラグイン用マッピング
    ["<leader>gnd"] = { "<cmd>DiffviewOpen<cr>", desc = "Git差分ビューを開く" },
  },
  -- 挿入モード
  i = {
    ["jj"] = { "<Esc>", desc = "挿入モードを抜ける", silent = true, noremap = true },
    ["ｊｊ"] = { "<Esc>", desc = "挿入モードを抜ける", silent = true, noremap = true },
    -- 行末にカーソル移動（カスタム動作）
    ["<C-e>"] = { "<Esc>A", desc = "行末に移動" },
    -- 行頭にカーソル移動（カスタム動作）
    ["<C-a>"] = { "<Esc>I", desc = "行頭に移動" },
  },
  -- ビジュアルモード
  v = {
    x = { '"_x', desc = "xでヤンクしない" },
  },
}

-- 基本マッピングとカスタムマッピングを安全にマージ
return utils.safe_merge(base_mappings, custom_mappings)