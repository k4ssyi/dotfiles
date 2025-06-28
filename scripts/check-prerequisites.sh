#!/usr/bin/env bash

echo "🔍 Checking system prerequisites..."
echo "================================="

# Exit on any error
set -e

# 1. Check macOS only
if [[ "$(uname)" != "Darwin" ]]; then
	echo "❌ This script is designed for macOS only"
	exit 1
fi

# 2. Check macOS version (require macOS 10.15+)
MACOS_VERSION=$(sw_vers -productVersion)
MAJOR_VERSION=$(echo "$MACOS_VERSION" | cut -d '.' -f 1)
MINOR_VERSION=$(echo "$MACOS_VERSION" | cut -d '.' -f 2)

if [[ "$MAJOR_VERSION" -lt 10 ]] || [[ "$MAJOR_VERSION" -eq 10 && "$MINOR_VERSION" -lt 15 ]]; then
	echo "❌ macOS 10.15 (Catalina) or later is required. Current version: $MACOS_VERSION"
	exit 1
fi

echo "✅ macOS $MACOS_VERSION detected"

# 3. Check and install Xcode Command Line Tools
echo "📦 Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
	echo "⚠️  Xcode Command Line Tools not found. Installing..."
	xcode-select --install
	echo "⚠️  Please complete the Xcode Command Line Tools installation and re-run this script"
	echo "   You can check installation status with: xcode-select -p"
	exit 1
else
	echo "✅ Xcode Command Line Tools found: $(xcode-select -p)"
fi

# 4. Detect architecture for Homebrew paths
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
	export HOMEBREW_PREFIX="/opt/homebrew"
	echo "✅ Apple Silicon (ARM64) detected - Homebrew path: $HOMEBREW_PREFIX"
elif [[ "$ARCH" == "x86_64" ]]; then
	export HOMEBREW_PREFIX="/usr/local"
	echo "✅ Intel (x86_64) detected - Homebrew path: $HOMEBREW_PREFIX"
else
	echo "❌ Unsupported architecture: $ARCH"
	exit 1
fi

# Save architecture info for other scripts
echo "export HOMEBREW_PREFIX=\"$HOMEBREW_PREFIX\"" >/tmp/dotfiles_arch_info.sh

# 5. Check for admin privileges (for Python 2.7 removal)
echo "🔐 Checking admin privileges..."
if [[ "${DRYRUN_MODE:-false}" == "true" ]]; then
	echo "🧪 [DRYRUN] Skipping sudo check in dry-run mode"
elif ! sudo -n true 2>/dev/null; then
	echo "⚠️  This script requires sudo privileges for system cleanup tasks"
	echo "   You will be prompted for your password during installation"
	# Test sudo access
	sudo -v || {
		echo "❌ Unable to obtain sudo privileges"
		exit 1
	}
else
	echo "✅ Admin privileges available"
fi

# 6. Check internet connectivity
echo "🌐 Checking internet connectivity..."
if ! curl -s --head --connect-timeout 5 https://github.com >/dev/null; then
	echo "❌ Internet connection required for installation"
	echo "   Please check your network connection and try again"
	exit 1
fi
echo "✅ Internet connection verified"

# 7. Ensure running from correct directory
if [[ ! -f "./install.sh" ]]; then
	echo "❌ Please run this script from the dotfiles directory"
	echo "   Current directory: $(pwd)"
	echo "   Expected files: install.sh, scripts/, zsh/, nvim/, etc."
	exit 1
fi
echo "✅ Running from correct directory: $(pwd)"

# 8. Check if App Store is signed in (for mas installs)
echo "🏪 Checking App Store authentication..."
if command -v mas &>/dev/null; then
	if mas account &>/dev/null; then
		APPLE_ID=$(mas account)
		echo "✅ App Store signed in as: $APPLE_ID"
	else
		echo "⚠️  Not signed in to App Store"
		echo "   Some applications will be skipped during installation"
		echo "   To install all apps, sign in with: mas signin your@email.com"
	fi
else
	echo "ℹ️  mas (Mac App Store CLI) not installed - will be installed later"
fi

# 9. Check available disk space (require at least 2GB)
echo "💾 Checking available disk space..."
AVAILABLE_SPACE=$(df -g . | tail -1 | awk '{print $4}')
if [[ "$AVAILABLE_SPACE" -lt 2 ]]; then
	echo "❌ Insufficient disk space. At least 2GB required, $AVAILABLE_SPACE GB available"
	exit 1
fi
echo "✅ Sufficient disk space: ${AVAILABLE_SPACE}GB available"

# 10. Check if zsh is available
echo "🐚 Checking shell availability..."
if ! command -v zsh &>/dev/null; then
	echo "❌ zsh is required but not found"
	echo "   zsh should be available on macOS 10.15+ by default"
	exit 1
fi

# Check if zsh is already the default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
	echo "⚠️  Current shell is $SHELL, but zsh is recommended"
	echo "   The installation will configure zsh settings"
	echo "   To make zsh your default shell: chsh -s $(which zsh)"
fi
echo "✅ zsh available at: $(which zsh)"

# 11. Warning about permissions that require manual intervention
echo ""
echo "⚠️  IMPORTANT NOTES:"
echo "   - Karabiner Elements will require accessibility permissions"
echo "   - Hammerspoon will require accessibility permissions"
echo "   - Some installations may require your password"
echo "   - First-time Homebrew installation may take 10+ minutes"
echo ""

echo "================================="
echo "✅ All prerequisites check passed!"
echo "🚀 Ready to run ./install.sh"
echo ""
