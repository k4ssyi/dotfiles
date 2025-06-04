--[[
User Plugins - ユーザー独自プラグイン設定例

@概要
  - plugins/ フォルダ内で追加・上書き・無効化など柔軟なプラグイン管理が可能です。
  - サンプルとして追加・上書き・無効化・カスタム設定例を記載しています。

@主な仕様
  - 追加: プラグイン名のみ、または詳細テーブルで記述
  - 上書き: optsやconfigで既存プラグインの設定を変更
  - 無効化: enabled = falseで無効化
  - カスタム設定: config関数で詳細な初期化処理

@制限事項
  - 設定内容によっては他のプラグインと競合する場合があります。

@参考
  - https://github.com/AstroNvim/AstroNvim

]]

---@type LazySpec
return {

  -- == プラグイン追加例 ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == プラグイン上書き例 ==

  -- alpha-nvimのオプションカスタマイズ例
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- ダッシュボードヘッダーのカスタマイズ
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- デフォルトプラグインの無効化例
  { "max397574/better-escape.nvim", enabled = false },

  -- プラグインsetup外での追加設定例
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- デフォルトのastronvim設定を呼び出し
      -- ファイルタイプ拡張やカスタムスニペットの追加例
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- デフォルトのastronvim設定を呼び出し
      -- カスタムルール追加例
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- 次の文字が%の場合はペアを追加しない
            :with_pair(cond.not_after_regex "%%")
            -- 直前3文字がxxxの場合はペアを追加しない
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- 同じ文字が連続する場合は右に移動しない
            :with_move(cond.none())
            -- 次の文字がxxの場合は削除しない
            :with_del(cond.not_after_regex "xx")
            -- <cr>で改行を追加しない
            :with_cr(cond.none()),
        },
        -- .vimファイルでは無効化（他ファイルタイプでは有効）
        Rule("a", "a", "-vim")
      )
    end,
  },
}
