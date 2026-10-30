#!/bin/bash
set -e

# Latest stable by default (config needs 0.12+). Pin with: NVIM_VERSION=v0.12.6 ./setup.sh
NVIM_VERSION="${NVIM_VERSION:-latest}"
CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"

install_lazygit_config() {
  mkdir -p ~/.config/lazygit
  cp "$CONFIG_DIR/lazygit-config.yml" ~/.config/lazygit/config.yml
}

# Tmux truecolor (idempotent, so re-running doesn't stack duplicates)
install_tmux_conf() {
  grep -q 'terminal-overrides ",\*:RGB"' ~/.tmux.conf 2>/dev/null && return
  echo -e 'set -g default-terminal "tmux-256color"\nset -ag terminal-overrides ",*:RGB"' >> ~/.tmux.conf
}

setup_macos() {
  if ! command -v brew >/dev/null; then
    echo "Homebrew required on macOS: https://brew.sh" >&2
    exit 1
  fi
  brew install neovim lazygit ripgrep fd
  install_lazygit_config
  install_tmux_conf
}

setup_linux() {
  # Root-owned installs need sudo unless we're already root
  SUDO=""
  [ "$(id -u)" -ne 0 ] && SUDO="sudo"
  $SUDO mkdir -p /usr/local/bin

  case "$(uname -m)" in
    x86_64)          NVIM_ARCH="linux-x86_64"; LG_ARCH="Linux_x86_64" ;;
    aarch64|arm64)   NVIM_ARCH="linux-arm64";  LG_ARCH="Linux_arm64"  ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
  esac

  # Packages first: minimal images (e.g. Jetson) ship without curl
  $SUDO apt update && $SUDO apt install -y curl ripgrep fd-find
  # Debian ships fd as fdfind
  command -v fdfind >/dev/null && $SUDO ln -sf "$(which fdfind)" /usr/local/bin/fd

  # Neovim
  if [ "$NVIM_VERSION" = latest ]; then
    curl -fLO "https://github.com/neovim/neovim/releases/latest/download/nvim-${NVIM_ARCH}.tar.gz"
  else
    curl -fLO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-${NVIM_ARCH}.tar.gz"
  fi
  tar xzf "nvim-${NVIM_ARCH}.tar.gz"
  $SUDO rm -rf /opt/nvim
  $SUDO mv "nvim-${NVIM_ARCH}" /opt/nvim
  $SUDO ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm "nvim-${NVIM_ARCH}.tar.gz"

  # Lazygit
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${LG_ARCH}.tar.gz"
  tar xf lazygit.tar.gz lazygit
  $SUDO mv lazygit /usr/local/bin/
  rm lazygit.tar.gz

  install_lazygit_config
  install_tmux_conf
}

case "$(uname -s)" in
  Darwin) setup_macos ;;
  Linux)  setup_linux ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

nvim --version | head -1
echo "Done! Run nvim to finish the plugin setup."
