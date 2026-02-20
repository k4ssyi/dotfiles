---
name: brew-audit
description: "Homebrewパッケージの棚卸しスキル。install-brew-component.shの定義と実環境のインストール状況を比較し、差分を検出する。This skill should be used when the user asks to 'brew-audit', 'brew棚卸し', 'パッケージ監査', or wants to check Homebrew package consistency."
disable-model-invocation: true
allowed-tools: Bash(brew *), Read, Grep, Glob
---

# Brew Audit - Homebrew Package Consistency Check

`scripts/install-brew-component.sh` で定義されたパッケージ一覧と、実環境のインストール状況を比較する。

## Workflow

### 1. 定義の読み取り

`scripts/install-brew-component.sh` を Read で読み込み、以下の配列を抽出:
- `formulae`: Homebrew formula一覧
- `casks`: Homebrew cask一覧
- `taps`: Homebrew tap一覧

### 2. 実環境の取得

```bash
brew list --formula
brew list --cask
brew tap
```

### 3. 差分分析

3種類の差分を検出:

| カテゴリ | 意味 | アクション候補 |
|---|---|---|
| **Missing** | 定義にあるが未インストール | `brew install` で追加 |
| **Extra** | 未定義だがインストール済み | 定義に追加 or `brew uninstall` |
| **Orphaned deps** | 他のパッケージの依存としてのみ存在 | `brew autoremove` で削除可能 |

### 4. Tap整合性

```bash
brew tap
```
の結果と定義済みtapを比較。

### 5. 古いパッケージ

```bash
brew outdated
```
でアップデート可能なパッケージを一覧表示。

## Output Format

```
## Brew Audit Results

### Formula
- Defined: N packages
- Installed: N packages
- Missing: [list]
- Extra: [list]

### Cask
- Defined: N packages
- Installed: N packages
- Missing: [list]
- Extra: [list]

### Taps
- Defined: N taps
- Active: N taps
- Missing: [list]
- Extra: [list]

### Outdated
- N packages have updates available
  - package: current -> latest

### Recommendations
1. [prioritized action items]
```

## Notes

- `brew list` はキャッシュの状態により結果が異なる場合がある。`brew update` を事前に実行することを推奨
- Extra判定ではHomebrewのデフォルトtap (`homebrew/core`, `homebrew/cask`) は除外
- 依存パッケージ（`brew deps --installed`）は Extra 判定から除外
