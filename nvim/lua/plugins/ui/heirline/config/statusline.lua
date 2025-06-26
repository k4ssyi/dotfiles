--[[
config/ui/heirline/statusline.lua - Statusline設定

@概要
  - heirlineのstatusline（ステータスライン）設定
  - モード、ファイル情報、Git情報、LSP情報、ナビゲーション情報の表示

@戻り値
  - heirlineのstatusline設定テーブル

]]

local function create_statusline_config()
  local status = require "astroui.status"

  return {
    -- ステータスライン全体のデフォルトハイライト
    hl = { fg = "fg", bg = "bg" },

    -- Vimモードコンポーネント
    require("plugins.ui.heirline.config.components.mode")(),

    -- 空白セクション
    require("plugins.ui.heirline.config.components.spacer")(),

    -- ファイル情報セクション
    require("plugins.ui.heirline.config.components.file_info")(),

    -- Gitブランチコンポーネント
    status.component.git_branch {
      git_branch = { padding = { left = 1 } },
      surround = { separator = "none" },
    },

    -- Git差分コンポーネント
    status.component.git_diff {
      padding = { left = 1 },
      surround = { separator = "none" },
    },

    -- 中央を埋める
    status.component.fill(),

    -- LSP読み込み状況
    status.component.lsp {
      lsp_client_names = false,
      surround = { separator = "none", color = "bg" },
    },

    -- 右側を埋める
    status.component.fill(),

    -- 診断情報
    status.component.diagnostics {
      surround = { separator = "right" },
    },

    -- LSPクライアント情報
    status.component.lsp {
      lsp_progress = false,
      surround = { separator = "right" },
    },

    -- フォルダセクション
    require("plugins.ui.heirline.config.components.folder")(),

    -- ナビゲーションセクション
    require("plugins.ui.heirline.config.components.navigation")(),
  }
end

return create_statusline_config
