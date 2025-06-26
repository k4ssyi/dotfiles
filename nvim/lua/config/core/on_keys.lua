--[[
config/on_keys.lua - キー入力時の動作設定

@概要
  - キー入力時に実行される動的な処理を定義します。
  - 検索時のhlsearch自動制御などを管理します。

@戻り値
  - AstroCoreのon_keys設定に対応するテーブル

]]

return {
  -- 最初のキーは名前空間
  auto_hlsearch = {
    -- キー入力時に実行する関数のリスト
    function(char) -- 検索中以外は自動的にhlsearchを無効化
      if vim.fn.mode() == "n" then
        local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
        if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
      end
    end,
  },
}