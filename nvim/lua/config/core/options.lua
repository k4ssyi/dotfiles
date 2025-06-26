--[[
config/options.lua - エディタオプション設定

@概要
  - AstroCore用のVimオプション設定を管理します。
  - opt、gの設定を分離して保守性を向上させます。

@戻り値
  - AstroCoreのoptions設定に対応するテーブル

]]

return {
  opt = { -- vim.opt.<key>
    relativenumber = false, -- 相対行番号を無効化
    number = true, -- 行番号を有効化
    spell = false, -- スペルチェックを無効化
    signcolumn = "auto", -- サインカラムを自動表示
    swapfile = false, -- スワップファイルを無効化
    wrap = true, -- テキストの折り返しを有効化
  },
  g = { -- vim.g.<key>
    -- グローバル変数の設定（vim.g）
    -- mapleader/maplocalleaderはAstroNvimのoptsまたは`lazy.setup`前に設定してください
    -- 詳細は`lua/lazy_setup.lua`を参照
  },
}