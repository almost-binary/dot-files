#!/usr/bin/env sh
set -eu

OS="$(uname -s)"
case "$OS" in
  Linux|Darwin) ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

mkdir -p "$HOME/.config/nvim"

ln -sfn "$DOTFILES/zsh/zshenv" "$HOME/.zshenv"
ln -sfn "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo "Bootstrap complete."
