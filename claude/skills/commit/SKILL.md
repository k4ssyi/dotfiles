---
name: commit
description: "Conventional Commits 1.0.0準拠のコミットメッセージ生成スキル。ステージ済み変更を分析し、適切なtype/scope/descriptionを含むコミットメッセージを生成する。This skill should be used when the user asks to 'commit', 'コミット', or wants to create a git commit message."
disable-model-invocation: true
allowed-tools: Bash(git *), AskUserQuestion
---

# Commit Message Generator

Conventional Commits 1.0.0準拠のコミットメッセージを生成し、ユーザー確認後にコミットを実行する。

## Workflow

1. `git status` でワーキングツリーの状態を確認
2. `git diff --staged` でステージ済みの変更内容を取得
3. ステージ済み変更がない場合、ユーザーに通知して終了
4. 変更内容を分析し、適切なtype/scope/descriptionを決定
5. コミットメッセージを生成してユーザーに提示
6. ユーザー確認後、`git commit` を実行

## Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **description**: 変更の「何を・なぜ」を簡潔に記述。日本語可
- **body**: 変更の動機や詳細が必要な場合に記述
- **footer**: `BREAKING CHANGE:` や `Co-Authored-By:` 等
- **破壊的変更**: `type!:` または footer に `BREAKING CHANGE:` を記載

## Type Prefix

変更の性質に最も合致するtypeを選択する。迷った場合は上位のものを優先:

### 基本（Conventional Commits準拠）

| prefix | 用途 | 判断基準 |
|--------|------|----------|
| feat | 新しい機能・ファイルの追加 | ユーザーから見て「できることが増えた」 |
| fix | 既存機能の問題修正 | 「壊れていたものが直った」 |
| refactor | 動作を変えないコード改善 | 外部挙動は同じ、内部構造が変わった |
| docs | ドキュメントのみの変更 | コード変更なし |
| style | フォーマット・空白等の修正 | 動作もロジックも変わらない |
| perf | パフォーマンス改善 | 計測可能な速度・効率の向上 |
| test | テストコードの追加・修正 | プロダクションコード変更なし |
| chore | ビルド・CI・依存関係・その他 | 上記いずれにも該当しない |

### 拡張（プロジェクト固有）

| prefix | 用途 | 判断基準 |
|--------|------|----------|
| hotfix | 緊急の修正 | 本番障害等、即時対応が必要 |
| update | 既存機能の強化 | バグではないが動作が改善・拡張された |
| remove | ファイル・機能の削除 | 不要になったものの除去 |
| rename | ファイル・変数等の名前変更 | 名前のみ変更、ロジック変更なし |
| move | ファイル・ディレクトリの移動 | パスのみ変更 |
| upgrade | 依存パッケージのバージョン更新 | ライブラリ・ツールのアップデート |
| revert | 以前のコミットへの復元 | `git revert` 相当 |
| disable | 機能の一時的無効化 | 削除ではなくフラグ等で無効化 |

## Rules

- `git log --oneline -10` で直近のコミット履歴を確認し、リポジトリのスタイルに合わせる
- scopeはディレクトリ名やモジュール名から推定（例: `fix(nvim):`, `feat(zsh):`）
- 1コミット1関心事。複数の無関係な変更が混在している場合はユーザーに分割を提案
- descriptionは命令形で始める（英語の場合）。日本語の場合は体言止めまたは動詞終止形
- footerに `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` を付与
- コミットメッセージはHEREDOC形式で渡す:
  ```bash
  git commit -m "$(cat <<'EOF'
  type(scope): description

  Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
  EOF
  )"
  ```
