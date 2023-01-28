#!/bin/bash

DEPS_HOME=~/.nvim/deps
source $DEPS_HOME/util.sh

message "install dependencies with brew"
brew update

install_or_skip "brew install neovim" "nvim"
install_or_skip "brew install git" "git"
install_or_skip "brew install curl" "curl"
install_or_skip "brew install wget" "wget"
install_or_skip "brew install unzip" "unzip"
install_or_skip "brew install gzip" "gzip"
install_or_skip "brew install cmake" "cmake"
install_or_skip "brew install pkg-config" "pkg-config"
install_or_skip "brew install bat" "bat"
install_or_skip "brew install ripgrep" "rg"
install_or_skip "brew install fd" "fd"
install_or_skip "brew install git-delta" "delta"

# python3
install_or_skip "brew install python3" "python3"

# nodejs
install_or_skip "brew install node" "node"

# ctags
install_or_skip "brew install universal-ctags" "ctags"
