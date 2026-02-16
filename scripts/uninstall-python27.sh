#!/usr/bin/env bash

# Python 2.7 のアンインストール
# 危険な操作のため事前確認を実装

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

log_info "Python 2.7 のアンインストールを開始します"

# Python 2.7 の存在確認
PYTHON27_FRAMEWORK="/Library/Frameworks/Python.framework/Versions/2.7"
PYTHON27_APP="/Applications/Python 2.7"

# 削除対象の確認
targets_to_remove=()

if [[ -d "$PYTHON27_FRAMEWORK" ]]; then
	targets_to_remove+=("$PYTHON27_FRAMEWORK")
	log_info "Python 2.7 フレームワークが見つかりました: $PYTHON27_FRAMEWORK"
fi

if [[ -d "$PYTHON27_APP" ]]; then
	targets_to_remove+=("$PYTHON27_APP")
	log_info "Python 2.7 アプリケーションが見つかりました: $PYTHON27_APP"
fi

# 削除対象がない場合
if [[ ${#targets_to_remove[@]} -eq 0 ]]; then
	log_success "Python 2.7 は既にアンインストールされています"
	exit 0
fi

# 警告メッセージと確認
log_warning "以下のPython 2.7 関連ファイルを削除します:"
for target in "${targets_to_remove[@]}"; do
	echo "  - $target"
done

log_warning "この操作は元に戻せません。続行しますか？ [y/N]"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
	log_info "操作をキャンセルしました"
	exit 0
fi

# 削除実行（各ファイル個別に確認、安全性ガード付き）
for target in "${targets_to_remove[@]}"; do
	# 安全性チェック: 空文字列やルートパスの防止
	if [[ -z "$target" || "$target" == "/" ]]; then
		log_error "無効な削除対象: '$target'（スキップ）"
		continue
	fi
	# 安全性チェック: 想定されるパスプレフィックスの検証
	if [[ "$target" != /Library/* && "$target" != /Applications/* ]]; then
		log_error "予期しないパス: '$target'（スキップ）"
		continue
	fi
	if [[ -d "$target" ]]; then
		log_step "$target を削除中..."
		if sudo rm -rf "$target"; then
			log_success "$target を削除しました"
		else
			log_error "$target の削除に失敗しました"
		fi
	fi
done

log_success "Python 2.7 のアンインストールが完了しました"
