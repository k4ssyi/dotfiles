# My Dotfiles

macOS開発環境を最新ツールと設定で構築するためのdotfiles

## プレビュー

<img width="1796" alt="Screenshot 0005-07-19 19 19 31" src="https://github.com/k4ssyi/dotfiles/assets/36563045/aeafc294-7252-4a60-b1b7-5097c553b773">

<img width="1795" alt="Screenshot 0006-10-04 23 37 17" src="https://github.com/user-attachments/assets/bd8f68c3-2ac7-4e6c-8bbe-6c4fc0f6550b">

## 特徴

- **ターミナル**: Alacritty + Catppuccin Mochaテーマ
- **シェル**: Zsh + Sheldonプラグインマネージャー
- **プロンプト**: Starship（最適化済み設定）
- **エディタ**: Neovim + AstroNvimフレームワーク
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
- 全設定ファイルのセットアップ
- 開発環境の設定
- 既存設定のバックアップ作成

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
├── scripts/                # 個別セットアップスクリプト
│   ├── lib/
│   │   └── common.sh       # 共通ライブラリ
│   ├── check-prerequisites.sh
│   ├── setup-brew.sh
│   ├── install-brew-component.sh
│   ├── install-zsh-conf.sh
│   └── ...
├── zsh/                    # Zsh設定
│   ├── .zshrc
│   └── sheldon/
│       └── plugins.toml
├── nvim/                   # Neovim設定
├── vscode-nvim/            # VSCode Neovim設定
├── alacritty/              # ターミナル設定
├── starship.toml           # プロンプト設定
├── tmux/                   # tmux設定
├── karabiner/              # キーマッピング設定
├── hammerspoon/            # ウィンドウ管理設定
└── git/                    # Git設定
```

## ライセンス

このプロジェクトはオープンソースで、[MIT License](LICENSE)の下で公開されています。
