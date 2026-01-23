#!/bin/bash

# set -x

info "install deps with brew"

if ! type clang >/dev/null 2>&1; then
	xcode-select --install
fi
if ! type brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew update

# c++ toolchain
install "brew install cmake" "cmake"
install "brew install pkg-config" "pkg-config"

# download tools
install "brew install git" "git"
install "brew install curl" "curl"
install "brew install wget" "wget"

# compress tools
install "brew install gzip" "gzip"
install "brew install p7zip" "7z"
install "brew install unzip" "unzip"

# python3
install "brew install python3" "python3"

# nodejs
install "brew install node" "node"
install "brew install deno" "deno"
install "brew install oven-sh/bun/bun" "bun"

# go
install "brew install go" "go"

# cli tools
install "brew install macos-trash" "/opt/homebrew/opt/macos-trash/bin/trash"
install "brew install fzf" "fzf"
install "brew install lazygit" "lazygit"
install "brew install ripgrep" "rg"
install "brew install bat" "bat"
install "brew install fd" "fd"
install "brew install eza" "eza"
# install "brew install tree-sitter-cli" "tree-sitter"

# trash
install "brew install trash" "/opt/homebrew/opt/trash/bin/trash"

# neovim
install "brew install neovim" "nvim"
