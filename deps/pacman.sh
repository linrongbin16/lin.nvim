#!/bin/bash

DEPS_HOME="$1"
source "$DEPS_HOME/util.sh"

message "install dependencies with pacman"
sudo pacman -Syy

# neovim
install_or_skip "yes | sudo pacman -S neovim" "nvim"

# c++ toolchain
install_or_skip "yes | sudo pacman -S base-devel" "gcc"
install_or_skip "yes | sudo pacman -S base-devel" "make"
install_or_skip "yes | sudo pacman -S autoconf" "autoconf"
install_or_skip "yes | sudo pacman -S automake" "automake"
install_or_skip "yes | sudo pacman -S pkg-config" "pkg-config"
install_or_skip "yes | sudo pacman -S cmake" "cmake"

# download tools
install_or_skip "yes | sudo pacman -S git" "git"
install_or_skip "yes | sudo pacman -S curl" "curl"
install_or_skip "yes | sudo pacman -S wget" "wget"

# compress tools
install_or_skip "yes | sudo pacman -S gzip" "gzip"
install_or_skip "yes | sudo pacman -S p7zip" "7z"
install_or_skip "yes | sudo pacman -S unzip" "unzip"
install_or_skip "yes | sudo pacman -S unrar" "unrar"

# luarocks
install_or_skip "yes | sudo pacman -S luarocks" "luarocks"

# copy/paste tools
install_or_skip "yes | sudo pacman -S xsel" "xsel"
install_or_skip "yes | sudo pacman -S xclip" "xclip"

# python3
install_or_skip "yes | sudo pacman -S python python-pip" "python3"
install_or_skip "yes | sudo pacman -S python python-pip" "pip3"

# node
install_or_skip "yes | sudo pacman -S nodejs npm" "node"

# ctags
install_or_skip "yes | sudo pacman -S ctags" "ctags"