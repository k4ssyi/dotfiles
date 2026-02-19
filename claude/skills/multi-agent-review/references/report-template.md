# Multi-Agent Review Report Template

レビュー結果の統合時に使用するMarkdownテンプレート。

## テンプレート

```markdown
# コードレビュー総合結果

## レビュー対象

- **diffソース**: {親ブランチとの差分 (`{base_branch}`) / 現在の変更}
- **レビューエージェント**: {実行したエージェント一覧}

## サマリー

| 観点 | BLOCKER | CRITICAL | MAJOR | MINOR |
|------|---------|----------|-------|-------|
| アーキテクチャ | 0 | 0 | 0 | 0 |
| バックエンド設計 | 0 | 0 | 0 | 0 |
| コード品質 | 0 | 0 | 0 | 0 |
| TypeScript型安全性 | 0 | 0 | 0 | 0 |
| データベース設計 | 0 | 0 | 0 | 0 |

**マージ可否:** ✅ / ❌

---

## 重大な問題（BLOCKER / CRITICAL）

### [{severity}] {issue_title}
- **検出元**: {agent}
- **箇所**: `{file_path}:{line}`
- **内容**: {description}
- **修正案**: {recommendation}

---

## 要改善（MAJOR）

### [MAJOR] {issue_title}
- **検出元**: {agent}
- **箇所**: `{file_path}:{line}`
- **内容**: {description}
- **修正案**: {recommendation}

---

## 改善推奨（MINOR）

### [MINOR] {issue_title}
- **検出元**: {agent}
- **箇所**: `{file_path}:{line}`

---

## 良い点

| 観点 | 内容 |
|------|------|
| {agent} | {positive_point} |

---

## 確認依頼事項

- [ ] {action_item}
```

## 重要度の定義

| レベル | 意味 | マージ可否 |
|--------|------|-----------|
| **BLOCKER** | マージ不可。即座に修正必須 | ❌ |
| **CRITICAL** | 重大な問題。リリース前に修正必須 | ⚠️ 要判断 |
| **MAJOR** | 修正すべき問題 | ✅ 修正後マージ可 |
| **MINOR** | 改善推奨 | ✅ マージ可 |

## ルール

- 問題がないセクションは省略可
- 複数エージェントが同じ箇所を指摘した場合、検出元を併記して重複を排除する
- 良い点セクションは必ず含める（レビューのバランスを保つため）
