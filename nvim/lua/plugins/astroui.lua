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
    colorscheme = "catppuccin",
    -- ユーザーインターフェース用アイコンの追加
    icons = {
      VimIcon = "",
      ScrollText = "",
      GitBranch = "",
      GitAdd = "",
      GitChange = "",
      GitDelete = "",
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
    -- heirlineで直接定義されていない変数のカスタマイズ
    status = {
      -- 各セクション間のセパレータ定義
      separators = {
        left = { "", "" }, -- ステータスライン左側のセパレータ
        right = { " ", "" }, -- ステータスライン右側のセパレータ
        tab = { "", "" },
      },
      -- heirlineで使用可能な新しい色の追加
      colors = function(hl)
        local get_hlgroup = require("astroui").get_hlgroup
        -- ハイライトグループのプロパティ取得用ヘルパー関数を利用
        local comment_fg = get_hlgroup("Comment").fg
        hl.git_branch_fg = comment_fg
        hl.git_added = comment_fg
        hl.git_changed = comment_fg
        hl.git_removed = comment_fg
        hl.blank_bg = get_hlgroup("Folded").fg
        hl.file_info_bg = get_hlgroup("Visual").bg
        hl.nav_icon_bg = get_hlgroup("String").fg
        hl.nav_fg = hl.nav_icon_bg
        hl.folder_icon_bg = get_hlgroup("Error").fg
        return hl
      end,
      attributes = {
        mode = { bold = true },
      },
      icon_highlights = {
        file_icon = {
          statusline = false,
        },
      },
    },
    -- ハイライトグループのカスタマイズ（全カラースキーム共通）
    highlights = {
      init = function()
        local get_hlgroup = require("astroui").get_hlgroup
        -- ハイライトグループから色を取得
        local normal = get_hlgroup "Normal"
        local fg, bg = normal.fg, normal.bg
        local bg_alt = get_hlgroup("Visual").bg
        local green = get_hlgroup("String").fg
        local red = get_hlgroup("Error").fg
        -- telescope用のハイライトテーブルを返す
        return {
          TelescopeBorder = { fg = bg_alt, bg = bg },
          TelescopeNormal = { bg = bg },
          TelescopePreviewBorder = { fg = bg, bg = bg },
          TelescopePreviewNormal = { bg = bg },
          TelescopePreviewTitle = { fg = bg, bg = green },
          TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
          TelescopePromptNormal = { fg = fg, bg = bg_alt },
          TelescopePromptPrefix = { fg = red, bg = bg_alt },
          TelescopePromptTitle = { fg = bg, bg = red },
          TelescopeResultsBorder = { fg = bg, bg = bg },
          TelescopeResultsNormal = { bg = bg },
          TelescopeResultsTitle = { fg = bg, bg = bg },
        }
      end,
      astrodark = { -- astrothemeテーマ適用時の上書き・変更用テーブル
        -- Normal = { bg = "#000000" },
      },
    },
  },
}
