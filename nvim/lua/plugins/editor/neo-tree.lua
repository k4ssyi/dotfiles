--[[
Neo-tree - ファイラ/ツリービュー プラグイン設定

@概要
  - Neovim上でファイル・ディレクトリをツリー表示し、直感的なファイル操作が可能です。
  - 隠しファイルやgitignoreファイルの表示制御、カスタムマッピングなど柔軟な設定が可能です。

@主な仕様
  - filtered_items: 隠しファイルや特定ファイルの表示制御
  - window: ウィンドウ幅や操作マッピングのカスタマイズ

@制限事項
  - 設定内容によっては他のファイラ系プラグインと競合する場合があります。

@参考
  - https://github.com/nvim-neo-tree/neo-tree.nvim

]]

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true, -- デフォルトで隠されているかどうか
        show_hidden_count = true,
        hide_dotfiles = false, -- dotfileを隠すかどうか
        hide_gitignored = false, -- gitignoreされているファイルを隠すかどうか
        hide_by_name = {
          "node_modules",
          "thumbs.db",
        },
        never_show = {
          ".DS_Store",
          ".history",
        },
      },
    },
    window = {
      width = 40,
      mappings = {
        ["c"] = {
          "copy",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
        ["m"] = {
          "move",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
      },
    },
  },
}
