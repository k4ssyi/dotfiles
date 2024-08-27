return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = function(_, opts)
      opts.debug = true -- Enable debugging
      -- プロンプトの設定
      local select = require "CopilotChat.select"
      -- デフォルトは英語なので日本語でオーバーライドしています
      opts.prompts = {
        Review = {
          prompt = "/COPILOT_REVIEW コードをレビューしてください。コードの問題点を指摘し、改善の提案をしてください。",
          callback = function(response, source)
            local ns = vim.api.nvim_create_namespace "copilot_review"
            local diagnostics = {}
            for line in response:gmatch "[^\r\n]+" do
              if line:find "^line=" then
                local start_line = nil
                local end_line = nil
                local message = nil
                local single_match, message_match = line:match "^line=(%d+): (.*)$"
                if not single_match then
                  local start_match, end_match, m_message_match = line:match "^line=(%d+)-(%d+): (.*)$"
                  if start_match and end_match then
                    start_line = tonumber(start_match)
                    end_line = tonumber(end_match)
                    message = m_message_match
                  end
                else
                  start_line = tonumber(single_match)
                  end_line = start_line
                  message = message_match
                end

                if start_line and end_line then
                  table.insert(diagnostics, {
                    lnum = start_line - 1,
                    end_lnum = end_line - 1,
                    col = 0,
                    message = message,
                    severity = vim.diagnostic.severity.WARN,
                    source = "Copilot Review",
                  })
                end
              end
            end
            vim.diagnostic.set(ns, source.bufnr, diagnostics)
          end,
        },
        Explain = {
          prompt = "/COPILOT_EXPLAIN カーソル上のコードの説明を段落をつけて書いてください。",
        },
        Tests = {
          prompt = "/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。",
        },
        Fix = {
          prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。",
        },
        Optimize = {
          prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。",
        },
        Docs = {
          prompt = "/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）",
        },
        FixDiagnostic = {
          prompt = "ファイル内の次のような診断上の問題を解決してください：",
          selection = select.diagnostics,
        },
      }
      -- See Configuration section for rest
      opts.window = {
        layout = "horizontal",
        relative = "cursor",
      }
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}
