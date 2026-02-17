#!/usr/bin/env bash

# リモートアクセス設定セットアップスクリプト
# Tailscale + SSH + tmux によるiPhoneからのリモート操作環境を構築
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "リモートアクセス設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# --- 1. macOSリモートログインの有効化 ---
if sudo systemsetup -getremotelogin | grep -q "On"; then
	log_info "リモートログインは既に有効です"
else
	log_warning "リモートログイン（SSH）を有効化します。このマシンへのリモートアクセスが可能になります。"
	printf "続行しますか？ [y/N]: "
	read -r response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		if sudo systemsetup -setremotelogin on; then
			log_success "リモートログインを有効化しました"
		else
			log_warning "リモートログインの有効化に失敗しました（システム環境設定から手動で有効化してください）"
		fi
	else
		log_info "リモートログインの有効化をスキップしました"
	fi
fi

# --- 2. SSHクライアント設定の配置 ---
log_step "SSHクライアント設定を配置中..."
ssh_config_source="$(pwd)/ssh/config"
ssh_config_target="${HOME}/.ssh/config"

if [[ -f "$ssh_config_source" ]]; then
	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"

	if [[ -e "$ssh_config_target" && ! -L "$ssh_config_target" ]]; then
		backup_path="${HOME}/.dotfiles_backup/ssh_config.$(date +%Y%m%d%H%M%S)"
		mkdir -p "${HOME}/.dotfiles_backup"
		cp "$ssh_config_target" "$backup_path"
		log_info "既存のSSHクライアント設定をバックアップしました: $backup_path"
	fi

	create_symlink "$ssh_config_source" "$ssh_config_target" true
	chmod 600 "$ssh_config_target"

	# config.local が未作成の場合、テンプレートを生成
	ssh_config_local="${HOME}/.ssh/config.local"
	if [[ ! -f "$ssh_config_local" ]]; then
		cat > "$ssh_config_local" <<-'TEMPLATE'
		# マシン固有のホスト設定（このファイルはgit管理外）
		# Host github.com
		#     HostName github.com
		#     User git
		#     IdentityFile ~/.ssh/id_ed25519
		TEMPLATE
		chmod 600 "$ssh_config_local"
		log_info "config.local テンプレートを作成しました: $ssh_config_local"
		log_warning "ホスト別の鍵パス等を config.local に記載してください"
	else
		log_info "config.local は既に存在します: $ssh_config_local"
	fi
else
	log_warning "SSHクライアント設定ファイルが見つかりません: $ssh_config_source"
fi

# --- 3. sshd_config.d drop-inファイルの配置 ---
log_step "sshd硬化設定を配置中..."
sshd_config_source="$(pwd)/ssh/sshd_config.d/99-remote-access.conf"
sshd_config_target="/etc/ssh/sshd_config.d/99-remote-access.conf"

if [[ ! -f "$sshd_config_source" ]]; then
	handle_error "sshd設定ファイルが見つかりません: $sshd_config_source"
fi

# /etc/ssh/sshd_config.d/ ディレクトリの存在確認
if [[ ! -d "/etc/ssh/sshd_config.d" ]]; then
	log_info "/etc/ssh/sshd_config.d/ を作成します"
	sudo mkdir -p /etc/ssh/sshd_config.d
fi

# /etc/ssh/sshd_configにIncludeディレクティブがあるか確認
if ! sudo grep -q "^Include /etc/ssh/sshd_config.d/" /etc/ssh/sshd_config; then
	log_warning "/etc/ssh/sshd_config に Include ディレクティブがありません"
	log_info "以下を /etc/ssh/sshd_config の先頭に追加してください:"
	log_info "  Include /etc/ssh/sshd_config.d/*.conf"
fi

actual_user="${SUDO_USER:-$(whoami)}"
if [[ "$actual_user" == "root" ]]; then
	handle_error "root ユーザーでの実行は許可されていません。通常ユーザーで sudo 経由で実行してください"
fi

tmpfile=$(mktemp)
sed "s/__CURRENT_USER__/$actual_user/" "$sshd_config_source" > "$tmpfile"
if sudo cp "$tmpfile" "$sshd_config_target"; then
	rm -f "$tmpfile"
	sudo chmod 644 "$sshd_config_target"
	log_success "sshd硬化設定を配置しました（AllowUsers=${actual_user}）: ${sshd_config_target}"

	# 設定の構文チェックとsshd再起動
	if sudo sshd -t 2>/dev/null; then
		log_info "sshd設定の構文チェックが成功しました"
		log_step "sshdを再起動中..."
		if sudo launchctl kickstart -k system/com.openssh.sshd 2>/dev/null; then
			log_success "sshdを再起動しました"
		else
			log_warning "sshdの再起動に失敗しました。手動で再起動してください"
		fi
	else
		log_warning "sshd設定に構文エラーがあります。設定を確認してください"
		sudo rm -f "$sshd_config_target"
		log_info "問題のある設定ファイルを削除しました"
	fi
else
	rm -f "$tmpfile"
	log_warning "sshd設定の配置に失敗しました"
fi

# --- 4. SSH鍵ペアの生成 ---
log_step "SSH鍵ペアを確認中..."
ssh_key_path="${HOME}/.ssh/id_ed25519_mobile"

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

if [[ -f "$ssh_key_path" ]]; then
	log_info "SSH鍵は既に存在します: $ssh_key_path"
	chmod 600 "$ssh_key_path"
	chmod 644 "${ssh_key_path}.pub"
else
	log_step "ed25519鍵ペアを生成中..."
	log_warning "セキュリティのため、パスフレーズの設定を推奨します"
	if ssh-keygen -t ed25519 -f "$ssh_key_path" -C "mobile-remote-access"; then
		chmod 600 "$ssh_key_path"
		chmod 644 "${ssh_key_path}.pub"
		log_success "SSH鍵ペアを生成しました: $ssh_key_path"
	else
		handle_error "SSH鍵ペアの生成に失敗しました"
	fi
fi

# --- 5. authorized_keysへの公開鍵追加 ---
log_step "authorized_keysを設定中..."
authorized_keys="${HOME}/.ssh/authorized_keys"
public_key_path="${ssh_key_path}.pub"

if [[ ! -f "$public_key_path" ]]; then
	handle_error "公開鍵が見つかりません: $public_key_path"
fi

public_key=$(cat "$public_key_path")

if [[ -f "$authorized_keys" ]] && grep -qF "$public_key" "$authorized_keys"; then
	log_info "公開鍵は既にauthorized_keysに登録済みです"
else
	# restrict: 全転送を無効化、pty: tmuxセッションに必要なターミナル割当のみ許可
	echo "restrict,pty ${public_key}" >>"$authorized_keys"
	chmod 600 "$authorized_keys"
	log_success "公開鍵をauthorized_keysに追加しました（restrict,pty制約付き）"
fi

# --- 6. Tailscaleセットアップガイダンス ---
log_step "Tailscaleの状態を確認中..."
echo ""
echo "================================="
echo "  Tailscale セットアップガイド"
echo "================================="
echo ""

if command_exists tailscale; then
	tailscale_status=$(tailscale status 2>&1 || true)
	if echo "$tailscale_status" | grep -q "Tailscale is stopped"; then
		log_warning "Tailscaleはインストール済みですが、起動していません"
		log_info "以下の手順で設定してください:"
	else
		log_success "Tailscaleは動作中です"
		log_info "Tailscale IP:"
		tailscale ip -4 2>/dev/null || true
	fi
else
	log_warning "Tailscaleがインストールされていません"
	log_info "brew install --cask tailscale でインストールしてください"
fi

echo ""
log_info "Tailscale手動セットアップ手順:"
log_info "  1. メニューバーのTailscaleアイコンをクリック"
log_info "  2. 「Log in」からアカウントにログイン"
log_info "  3. Tailscale管理画面でSSH ACLを確認"
echo ""

# --- 7. iPhone側の設定ガイダンス ---
echo "================================="
echo "  iPhone側の設定ガイド"
echo "================================="
echo ""
log_info "1. iPhoneにTailscaleアプリをインストールし、同じアカウントでログイン"
log_info "2. iPhoneにSSHクライアントをインストール:"
log_info "     無料: Secure ShellFish / Termius（基本機能無料）"
log_info "     有料: Blink Shell（Mosh対応）/ Prompt 3"
log_info ""
log_warning "=== SSH鍵の安全な設定方法 ==="
log_info "  【推奨】iPhone側で鍵ペアを生成する方式（秘密鍵がネットワークを経由しない）:"
log_info "    a. SSHクライアントアプリ内でed25519鍵ペアを生成"
log_info "    b. 公開鍵のみをMacの authorized_keys に追加:"
log_info "       echo '<公開鍵>' >> ~/.ssh/authorized_keys"
log_info ""
log_info "  【代替】Mac側で生成した鍵を転送する場合:"
log_info "    秘密鍵パス: $ssh_key_path"
log_info "    転送後、Mac側の秘密鍵は削除を推奨: rm $ssh_key_path"
log_warning "    AirDropやQRコードでの秘密鍵転送はインターセプトリスクがあります"
log_warning "    必ずパスフレーズ付きの鍵を使用してください"
log_info ""
log_info "3. SSHクライアントで以下の接続情報を設定:"
log_info "     ホスト: $(hostname) または Tailscale IP"
log_info "     ユーザー: $(whoami)"
log_info "     認証: 秘密鍵 (ed25519)"
log_info "4. 接続後、tmuxセッションにアタッチ:"
log_info "     tmux new -s work  (新規セッション)"
log_info "     tmux a -t work    (既存セッションにアタッチ)"
echo ""

log_success "リモートアクセス設定のセットアップが完了しました"
