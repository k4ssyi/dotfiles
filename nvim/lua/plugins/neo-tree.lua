return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false, -- デフォルトで隠されているかどうか
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
        ["c"] = { -- takes text input for destination, also accepts the optional config.show_path option like "add":
          "copy",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
        ["m"] = { -- takes text input for destination, also accepts the optional config.show_path option like "add":
          "move",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
      },
    },
  },
}
