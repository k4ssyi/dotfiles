---
name: multi-agent-review
description: >-
  This skill should be used when the user asks to "マルチエージェントレビュー",
  "multi-agent review", "全方位レビュー", or "レビュー".
  2つの専門エージェント（architect-reviewer, code-reviewer）による並列コードレビューを実行し、
  優先度別にMarkdown形式でサマリーを出力する。
  DB関連diffがある場合は database-architect、セキュリティ観点が必要な場合は security-auditor を追加で起動する。
  任意のプロジェクトで使用可能。
version: 2.0.0
allowed-tools: Bash(git diff:*), Bash(git log:*), Task, AskUserQuestion, Read, Grep, Glob
---

# Multi-Agent Review

専門エージェントによる並列コードレビューを実行し、結果を統合する汎用スキル。

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

デフォルトは `architect-reviewer` + `code-reviewer` の2エージェントを並列実行。diff内容やユーザー指定に応じて追加エージェントを起動する。

| エージェント | 観点 | 起動条件 |
|-------------|------|----------|
| `architect-reviewer` | SOLID原則、レイヤー分離、依存関係、パターン一貫性 | **デフォルト** |
| `code-reviewer` | コード品質、セキュリティ、TypeScript型安全性、API設計 | **デフォルト** |
| `database-architect` | スキーマ設計、インデックス、クエリ最適化、データモデリング | **条件付き**（後述） |

#### 条件付き: database-architect

以下のいずれかに該当する場合、デフォルト2エージェントに加えて `database-architect` を並列起動する:

- diff に DB 関連ファイルが含まれる（`*.sql`, `*migration*`, `*schema*`, `prisma/`, `drizzle/`, `**/models/**` 等）
- ユーザーが「データベース」「DB」「スキーマ」を明示した場合

#### 条件付き: security-auditor

ユーザーが「セキュリティ」「監査」「脆弱性」を明示した場合に追加で並列起動する。

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

### Step 5: 指摘事項の検証

統合レポート出力後、MAJOR以上の指摘について以下を実施する。

1. **妥当性の調査**: 指摘が正確か、実際のコード・ドキュメント・ツール仕様を確認して裏付けを取る
2. **動作検証**: 修正が必要な場合、修正後に実際に動作するか検証する（コマンド実行、ファイル存在確認など）
3. **結果の整理**: 各指摘について「確認済み / 誤検知 / 要ユーザー判断」を付けて報告する
