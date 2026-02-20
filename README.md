# My Dotfiles

macOS開発環境を最新ツールと設定で構築するためのdotfiles

<img width="1883" alt="Screenshot 0007-06-28 22 55 53" src="https://github.com/user-attachments/assets/ef4eeffc-a362-4cb4-b261-ff5c92cd37ac" />


## 特徴

- **ターミナル**: Ghostty + Catppuccin Mochaテーマ
- **シェル**: Zsh + Sheldonプラグインマネージャー
- **プロンプト**: Starship（最適化済み設定）
- **エディタ**: Neovim + lazy.nvim
- **ウィンドウ管理**: Hammerspoon + Karabiner-Elements
- **AI**: Claude Code（カスタムagents/skills付き）
- **ツール**: モダンなCLI代替品（lsd、ripgrepなど）

## クイックセットアップ

### 前提条件

- macOS 10.15 (Catalina) 以降
- 管理者権限（システムクリーンアップタスク用）
- インターネット接続

### インストール

1. このリポジトリをクローン:

```bash
git clone https://github.com/k4ssyi/dotfiles.git
cd dotfiles
```

1. **まずテスト実行**（推奨）:

```bash
./install.sh --dry-run
```

1. 実際のインストールを実行:

```bash
./install.sh
```

#### 利用可能なオプション

- `./install.sh` - インストールを実行
- `./install.sh --dry-run` - ファイル変更なしのテスト実行
- `./install.sh --help` - ヘルプ情報を表示

スクリプトは自動的に以下を実行します:

- システム前提条件チェック
- Xcode Command Line Toolsインストール（必要な場合）
- Homebrewとパッケージのインストール
- 全設定ファイルのシンボリックリンク作成
- Claude Code設定の展開（agents/skills含む）
- 既存設定のバックアップ作成（`~/.dotfiles_backup/`）

### インストール後の手動作業

一部のアプリケーションは手動で権限許可が必要です:

1. **Karabiner Elements**: システム設定でアクセシビリティ権限を許可
1. **Hammerspoon**: システム設定でアクセシビリティ権限を許可

## 手動前提条件チェック

インストール前に手動で前提条件をチェックしたい場合:

```bash
./scripts/check-prerequisites.sh
```

## トラブルシューティング

### よくある問題

1. **Xcode Command Line Toolsがインストールされていない**

   ```bash
   xcode-select --install
   ```

1. **Intel MacでのHomebrewパスの問題**
   - スクリプトがアーキテクチャを自動検出
   - Intel Mac: `/usr/local`、Apple Silicon: `/opt/homebrew`

1. **App Store認証が必要**

   ```bash
   mas signin your@email.com
   ```

1. **権限拒否エラー**
   - 管理者権限があることを確認
   - 一部の操作で`sudo`アクセスが必要

### アーキテクチャサポート

- ✅ Apple Silicon (M1/M2/M3) Mac
- ✅ Intel Mac
- ✅ アーキテクチャ自動検出

## ディレクトリ構成

```
dotfiles/
├── install.sh              # メインインストールスクリプト
├── CLAUDE.md               # プロジェクト固有のClaude Code指示
├── scripts/                # 個別セットアップスクリプト
│   ├── lib/
│   │   └── common.sh       # 共通ライブラリ（create_symlink等）
│   ├── check-prerequisites.sh
│   ├── setup-brew.sh
│   ├── install-brew-component.sh
│   ├── install-claude-conf.sh
│   └── ...
├── claude/                 # Claude Code設定 (-> ~/.claude/)
│   ├── CLAUDE.md           # グローバル指示
│   ├── settings.json       # Claude Code設定
│   ├── agents/             # カスタムagent定義
│   │   ├── references/     # agent用詳細資料（オンデマンド読み込み）
│   │   └── *.md
│   └── skills/             # Personal scope skills（全プロジェクト共通）
│       ├── commit/
│       ├── multi-agent-review/
│       └── skill-creator/
├── .claude/skills/         # Project scope skills（dotfiles専用）
│   ├── dotfiles-add/
│   ├── shell-lint/
│   └── brew-audit/
├── zsh/                    # Zsh + Sheldon設定
├── nvim/                   # Neovim設定（lazy.nvim）
├── ghostty/                # Ghosttyターミナル設定
├── starship/               # Starshipプロンプト設定
├── tmux/                   # tmux設定
├── hammerspoon/            # ウィンドウ管理設定
├── karabiner/              # キーマッピング設定
├── git/                    # Git設定
├── ssh/                    # SSH設定テンプレート
├── vscode-nvim/            # VSCode Neovim設定
└── alacritty/              # Alacritty設定（レガシー）
```

## ライセンス

このプロジェクトはオープンソースで、[MIT License](LICENSE)の下で公開されています。
