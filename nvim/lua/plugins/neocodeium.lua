--[[
NeoCodeium - AI補完プラグイン設定

@description Codeiumを使用したAI補完機能を提供するプラグイン
@features
  - AI補完機能（Codeium API使用）
  - nvim-cmpとの併用対応
  - 基本的なキーマップ設定
  - バッファ単位での有効/無効化

@limitations
  - インターネット接続が必要
  - 初回使用時にCodeium認証が必要（:NeoCodeium auth）
  - UTF-8またはLATIN-1エンコーディングのみサポート

@keymaps
  - <Right>: 補完を受け入れ
@commands
  - :NeoCodeium auth - 認証
  - :NeoCodeium enable/disable - 有効/無効化
  - :NeoCodeium toggle - 切り替え
--]]
return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  opts = {
    -- nvim-cmpとの競合を避けるため、手動トリガーを推奨
    manual = false,
    -- デバッグ用ログレベル（通常はwarn以上を推奨）
    log_level = "warn",
    -- 特定のファイルタイプで無効化
    filetypes = {
      help = false,
      gitcommit = false,
      gitrebase = false,
      ["."] = false,
    },
    -- バッファフィルター関数
    filter = function(bufnr)
      -- 特殊なバッファタイプでは無効化
      local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
      if buftype ~= "" then return false end
      return true
    end,
  },
  keys = {
    -- 補完を受け入れ
    {
      "<Right>",
      function() require("neocodeium").accept() end,
      mode = "i",
      desc = "Accept neocodeium suggestion",
    },
    -- -- 単語単位で補完を受け入れ
    -- {
    --   "<A-w>",
    --   function() require("neocodeium").accept_word() end,
    --   mode = "i",
    --   desc = "Accept neocodeium word",
    -- },
    -- -- 行単位で補完を受け入れ
    -- {
    --   "<A-a>",
    --   function() require("neocodeium").accept_line() end,
    --   mode = "i",
    --   desc = "Accept neocodeium line",
    -- },
    -- -- 次の補完候補に切り替え
    -- {
    --   "<A-e>",
    --   function() require("neocodeium").cycle_or_complete() end,
    --   mode = "i",
    --   desc = "Cycle to next neocodeium suggestion",
    -- },
    -- -- 前の補完候補に切り替え
    -- {
    --   "<A-r>",
    --   function() require("neocodeium").cycle_or_complete(-1) end,
    --   mode = "i",
    --   desc = "Cycle to previous neocodeium suggestion",
    -- },
    -- -- 補完をクリア
    -- {
    --   "<A-c>",
    --   function() require("neocodeium").clear() end,
    --   mode = "i",
    --   desc = "Clear neocodeium suggestions",
    -- },
  },
  config = function(_, opts)
    local neocodeium = require "neocodeium"
    neocodeium.setup(opts)

    -- ハイライトグループの設定
    vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { fg = "#808080", italic = true })
    vim.api.nvim_set_hl(0, "NeoCodeiumLabel", { fg = "#ffffff", bg = "#005577", bold = true })
  end,
}
