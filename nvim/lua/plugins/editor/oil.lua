--[[
Oil.nvim - バッファベースのファイルエクスプローラー設定
]]

return {
  "stevearc/oil.nvim",
  opts = {
    -- デフォルトのファイルエクスプローラーとして使用
    default_file_explorer = true,

    -- 表示するカラム
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },

    -- バッファオプション
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },

    -- ウィンドウオプション
    win_options = {
      wrap = false,
      signcolumn = "yes:2",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },

    -- 削除時に確認を表示
    delete_to_trash = false,
    skip_confirm_for_simple_edits = false,

    -- 隠しファイルやgitignoreファイルの表示制御
    view_options = {
      show_hidden = true, -- 隠しファイルを表示
      is_hidden_file = function(name)
        -- .DS_Storeや.historyは常に非表示
        return name == ".DS_Store" or name == ".history"
      end,
      is_always_hidden = function() return false end,
      -- gitignoreファイルを表示
      natural_order = true,
      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },
    },

    -- フロートウィンドウの設定
    float = {
      padding = 2,
      max_width = 90,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },

    -- プレビューウィンドウの設定
    preview = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },

    -- プログレス表示
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      minimized_border = "none",
      win_options = {
        winblend = 0,
      },
    },

    -- キーマッピング
    keymaps = {
      ["g?"] = "actions.show_help",
      ["l"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<Esc>"] = { "actions.close", mode = { "n", "i" } },
      ["<Esc><Esc>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["h"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },

    -- external integrations用の追加設定
    use_default_keymaps = true,

    -- ファイル操作時の動作
    watch_for_changes = true,

    -- ファイル操作の確認メッセージ
    cleanup_delay_ms = 2000,

    -- LSP file operations対応
    lsp_file_methods = {
      timeout_ms = 1000,
      autosave_changes = false,
    },

    -- ssh/scp経由のファイル操作
    ssh = {
      border = "rounded",
    },
  },

  -- 依存関係
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  -- キーマッピング設定
  keys = {
    {
      "<leader>e",
      function() require("oil").open_float() end,
      desc = "Oil: フロートウィンドウで開く",
    },
  },
}
