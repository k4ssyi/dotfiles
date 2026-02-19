---
name: multi-agent-review
description: >-
  This skill should be used when the user asks to "マルチエージェントレビュー",
  "multi-agent review", "全方位レビュー", or "5エージェントでレビュー".
  5つの専門エージェント（architect-reviewer, backend-architect, code-reviewer,
  typescript-pro, database-architect）による汎用コードレビューを実行し、
  優先度別にMarkdown形式でサマリーを出力する。任意のプロジェクトで使用可能。
version: 1.0.0
allowed-tools: Bash(git diff:*), Bash(git log:*), Task, AskUserQuestion, Read, Grep, Glob
---

# Multi-Agent Review

5つの専門ビルトインエージェントによる並列コードレビューを実行し、結果を統合する汎用スキル。

## Workflow

### Step 1: Diff対象の選択

AskUserQuestionツールでレビュー対象を確認する。

```
質問: 「レビュー対象のdiffを選択してください」
header: "Diff対象"
選択肢:
- 「親ブランチとの差分」: 分岐元ブランチからHEADまでの全変更をレビュー（PR作成前に最適）
- 「現在の変更」: ステージ済み＋未ステージの作業中の変更をレビュー（実装途中のチェックに最適）
```

#### 親ブランチの自動検出

「親ブランチとの差分」が選択された場合、以下の手順でベースブランチを特定する。

1. デフォルトブランチの検出: `git symbolic-ref refs/remotes/origin/HEAD` からリモートのデフォルトブランチを取得
2. 失敗した場合のフォールバック: `main` → `master` → `develop` の順に `git rev-parse --verify` で存在確認
3. いずれも見つからない場合: AskUserQuestionでベースブランチ名をユーザーに確認

#### diff取得コマンド

| 選択 | コマンド |
|------|---------|
| 親ブランチとの差分 | `git diff $(git merge-base {base_branch} HEAD)..HEAD` |
| 現在の変更 | `git diff HEAD` |

diffが空の場合、ユーザーに通知してレビューを中断する。

### Step 2: エージェント選択

デフォルトは5つすべてを並列実行。ユーザーが特定の観点を指定した場合、該当エージェントのみ実行する。

| エージェント | 観点 | トリガーキーワード |
|-------------|------|-------------------|
| `architect-reviewer` | SOLID原則、レイヤー分離、依存関係、パターン一貫性 | アーキテクチャ、設計 |
| `backend-architect` | API設計、破壊的変更、マイグレーション、パフォーマンス | バックエンド、API |
| `code-reviewer` | セキュリティ、エラーハンドリング、可読性、テスト品質 | セキュリティ、コード品質 |
| `typescript-pro` | 型定義、型安全性、ジェネリクス、DTOと内部型の整合性 | 型、TypeScript |
| `database-architect` | スキーマ設計、インデックス、クエリ最適化、データモデリング | データベース、DB |

### Step 3: 並列レビューの実行

Taskツールで選択したエージェントを**単一メッセージで並列起動**する。

各エージェントへのプロンプト:

```
以下のdiffに対して{agent_perspective}の観点からレビューを実行してください。

レビュー観点:
{review_points}

問題点は重要度（BLOCKER/CRITICAL/MAJOR/MINOR）を付けて、
具体的な改善提案とともに日本語で報告してください。
良い点も含めてください。

---

{diff_content}
```

### Step 4: 結果の統合

全エージェントの結果を `references/report-template.md` の形式に従って統合する。

統合時のルール:

- 複数エージェントが同じ箇所を指摘した場合、検出元を併記して重複を排除する
- 重要度の高い順（BLOCKER > CRITICAL > MAJOR > MINOR）に並べる
- 良い点セクションを必ず含める
