return {
  "akinsho/git-conflict.nvim",
  opts = function(_, opts)
    opts.default_mappings = true -- デフォルトのマッピングを有効にする
    opts.disable_diagnostics = false -- コンフリクト中の診断を無効にしない
    opts.highlights = { -- カスタムハイライトグループ
      incoming = "DiffText",
      current = "DiffAdd",
    }
  end,
}
