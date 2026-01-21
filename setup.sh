#!/bin/bash
set -e

# Neovim
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
rm -rf /opt/nvim
mv nvim-linux-x86_64 /opt/nvim
ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz

# Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
mv lazygit /usr/local/bin/
rm lazygit.tar.gz

# Ripgrep & fd
apt update && apt install -y ripgrep fd-find
ln -sf $(which fdfind) /usr/local/bin/fd

# Tmux truecolor
echo -e 'set -g default-terminal "tmux-256color"\nset -ag terminal-overrides ",*:RGB"' >> ~/.tmux.conf

echo "Done! Clone your config: git clone https://github.com/alsibassi/lazyvim-config.git ~/.config/nvim"
