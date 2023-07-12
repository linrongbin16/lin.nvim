#!/bin/bash

DEPS_HOME="$1"
source "$DEPS_HOME/util.sh"

if ! type clang >/dev/null 2>&1; then
    xcode-select --install
fi
if ! type brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
message "install dependencies with brew"
brew update

install_or_skip "brew install neovim" "nvim"
install_or_skip "brew install git" "git"
install_or_skip "brew install curl" "curl"
install_or_skip "brew install wget" "wget"
install_or_skip "brew install unzip" "unzip"
install_or_skip "brew install unrar" "unrar"
install_or_skip "brew install gzip" "gzip"
install_or_skip "brew install p7zip" "7z"
install_or_skip "brew install cmake" "cmake"
install_or_skip "brew install pkg-config" "pkg-config"

# python3
install_or_skip "brew install python3" "python3"

# nodejs
install_or_skip "brew install node" "node"

# ctags
install_or_skip "brew install universal-ctags" "ctags"