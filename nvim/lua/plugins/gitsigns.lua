--[[
Gitsigns - Git差分・ブレーム表示プラグイン設定

@概要
  - ファイルのGit差分（追加・変更・削除）をサインカラムや行番号に表示します。
  - 現在行のGit blame情報を表示できます。
  - コマンドやキーマップで各種表示の切り替えが可能です。

@主な仕様
  - signcolumn: サインカラムで差分表示
  - numhl: 行番号で差分表示
  - linehl: 行全体のハイライト
  - word_diff: 単語単位の差分表示
  - current_line_blame: 現在行のblame情報表示
  - preview_config: 差分プレビューウィンドウの設定

@制限事項
  - 大きなファイル（max_file_length以上）は自動的に無効化されます。
  - yadmリポジトリにはデフォルトで非対応です。

@参考
  - https://github.com/lewis6991/gitsigns.nvim

]]

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signcolumn = true, -- サインカラムで差分を表示（:Gitsigns toggle_signsで切替）
    numhl = true, -- 行番号で差分を表示（:Gitsigns toggle_numhlで切替）
    linehl = false, -- 行全体のハイライト（:Gitsigns toggle_linehlで切替）
    word_diff = false, -- 単語単位の差分表示（:Gitsigns toggle_word_diffで切替）
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = true, -- 現在行のblame情報を表示（:Gitsigns toggle_current_line_blameで切替）
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- デフォルトのフォーマッタを使用
    max_file_length = 40000, -- この行数を超えるファイルでは無効化
    preview_config = {
      -- nvim_open_winに渡すオプション
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    yadm = {
      enable = false,
    },
  },
}
