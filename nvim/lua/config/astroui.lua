--[[
AstroUI - AstroNvimのユーザーインターフェース設定モジュール

@概要
  - AstroNvimのユーザーインターフェース（UI）全体の外観やアイコン、ステータスライン、ハイライトなどを一元的に設定します。
  - 設定内容は `:h astroui` でドキュメントを参照できます。
  - Lua言語サーバー（:LspInstall lua_ls）の導入を強く推奨します。これにより補完やドキュメント参照が可能になります。

@主な仕様
  - colorscheme: カラースキームの指定
  - icons: UIで使用するアイコンの定義
  - status: heirline用のステータスラインやウィンバーのカスタマイズ
  - highlights: カラースキームごとのハイライトグループの上書き
  - その他、UI全体の細かな調整が可能

@制限事項
  - 設定内容によっては他プラグインと競合する場合があります。
  - カラースキームやアイコンは、使用するフォントやテーマに依存する場合があります。

@参考
  - https://github.com/AstroNvim/AstroNvim
  - :h astroui

]]

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- カラースキームの指定
    colorscheme = require("config.ui.colorscheme"),
    -- ユーザーインターフェース用アイコンの追加
    icons = require("config.ui.icons"),
    -- heirlineで直接定義されていない変数のカスタマイズ
    status = require("config.ui.status"),
    -- ハイライトグループのカスタマイズ（全カラースキーム共通）
    highlights = require("config.ui.highlights"),
  },
}