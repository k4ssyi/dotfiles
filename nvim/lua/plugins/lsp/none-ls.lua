--[[
none-ls.nvim - 外部フォーマッタ/リンター統合プラグイン設定

@概要
  - 各種外部ツール（フォーマッタ・リンター等）をNeovimのLSPとして統合します。
  - sourcesで有効化するツールを柔軟に追加できます。

@主な仕様
  - opts.sources: 有効化するフォーマッタ・リンターのリスト
  - condition: ファイル存在等による有効化条件

@制限事項
  - 対応ツールは公式リストを参照してください。

@参考
  - https://github.com/nvimtools/none-ls.nvim

]]

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, opts)
    local null_ls = require("null-ls")
    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Set a formatter
      null_ls.builtins.formatting.biome.with({
        condition = function(utils) return utils.has_file({ "biome.json", "biome.jsonc" }) end,
      }),
    })
    return opts
  end,
}
