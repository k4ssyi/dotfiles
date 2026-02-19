# Homebrew の初期化（Apple Silicon / Intel 両対応）
BREW_PATH="$([ "$(uname -m)" = "arm64" ] && echo /opt/homebrew || echo /usr/local)/bin/brew"
[[ -f "$BREW_PATH" ]] && eval "$("$BREW_PATH" shellenv)"
unset BREW_PATH

# Android SDK（インストールされている場合のみ）
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools"
  export PATH="$PATH:$ANDROID_HOME/tools"
  export PATH="$PATH:$ANDROID_HOME/tools/bin"
fi

# libpq / openssl（brew shellenv が設定した HOMEBREW_PREFIX を再利用）
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  _libpq_bin="${HOMEBREW_PREFIX}/opt/libpq/bin"
  [[ -d "$_libpq_bin" ]] && export PATH="$_libpq_bin:$PATH"
  unset _libpq_bin

  _openssl_prefix="${HOMEBREW_PREFIX}/opt/openssl"
  if [[ -d "$_openssl_prefix" ]]; then
    export LDFLAGS="-L${_openssl_prefix}/lib${LDFLAGS:+ $LDFLAGS}"
    export CFLAGS="-I${_openssl_prefix}/include${CFLAGS:+ $CFLAGS}"
  fi
  unset _openssl_prefix
fi
